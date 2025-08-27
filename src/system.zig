const std = @import("std");
const mem = std.mem;
const posix = std.posix;
const system = posix.system;
const assert = std.debug.assert;

const Socket = posix.socket_t;
const FD = posix.fd_t;

pub fn connect(path: []const u8) !Socket {
    const SocketAddress = system.sockaddr.un;
    const path_buffer_len = @typeInfo(@FieldType(SocketAddress, "path")).array.len;
    var addr = SocketAddress{
        .family = system.AF.LOCAL,
        .path = [1]u8{0} ** path_buffer_len,
    };

    const path_len_with_sentinel = path.len + 1;

    if (path_len_with_sentinel <= path_buffer_len) {
        @memcpy(addr.path[0..path.len], path);
    } else {
        return error.PathTooLong;
    }

    // Confirm that path is the last field
    // (... sockaddr.un shouldn't really ever change...)
    comptime {
        const fields = @typeInfo(SocketAddress).@"struct".fields;
        assert(mem.eql(u8, "path", fields[fields.len-1].name));
    }
    const size: system.socklen_t = @offsetOf(SocketAddress, "path")
        + @as(system.socklen_t, @intCast(path_len_with_sentinel));

    const fd: Socket = try posix.socket(
        system.PF.LOCAL,
        system.SOCK.STREAM | system.SOCK.CLOEXEC | system.SOCK.NONBLOCK,
        0,
    );
    errdefer posix.close(fd);

    try posix.connect(fd, @ptrCast(&addr), size);

    return fd;
}

/// Send all bytes of `data` over the `socket`,
/// with `fds` sent as ancillary data,
/// by at most `fds_per_msg` per sendmsg.
/// Returns any unsent FDs.
pub fn send(
    socket: Socket,
    data: []const u8,
    fds: []const FD,
    comptime fds_per_msg: usize,
) ![]const FD {
    var cmsg_buffer: [cmsg.space(@sizeOf(FD)*fds_per_msg)]u8 = undefined;

    var data_to_send = data[0..];
    var fds_to_send = fds[0..];

    defer {
        for ( fds[0..(fds.len - fds_to_send.len)] ) |sent_fd| {
            posix.close(sent_fd);
        }
    }

    while (data_to_send.len > 0) {
        const sending_data, const sending_fds =
            if (fds_to_send.len > fds_per_msg) .{
                // If we have to split the fds into multiple sends,
                // limit the actual data of each sendmsg to four bytes
                // until the remainder can be sent in one.
                data_to_send[0..@min(@sizeOf(u32), sending_data.len)],
                fds_to_send[0..fds_per_msg],
            } else .{
                data_to_send,
                fds_to_send,
            };

        const control, const controllen = if (sending_fds.len > 0) ctrl_data: {
            const control_len = cmsg.len(@sizeOf(FD)*sending_fds.len);

            const control_header: *cmsg.hdr = mem.bytesAsValue(
                cmsg.hdr,
                cmsg_buffer[0..@sizeOf(cmsg.hdr)],
            );
            control_header.* = .{
                .cmsg_len = control_len,
                .cmsg_level = system.SOL.SOCKET,
                .cmsg_type = 0x01, // os.linux.SCM.RIGHTS (missing) TODO
            };

            const control_data: []u8
                = cmsg_buffer[cmsg.@"align"(@sizeOf(cmsg.hdr))..];
            const fds_as_bytes: []const u8
                = mem.sliceAsBytes(sending_fds);
            @memcpy(control_data[0..fds_as_bytes.len], fds_as_bytes);

            break :ctrl_data .{
                @ptrCast(&cmsg_buffer),
                control_len,
            };
        } else .{ null, 0 };

        const msg = posix.msghdr_const{
            .name = null,
            .namelen = 0,
            .iov = &.{
                .base = sending_data.ptr,
                .len = sending_data.len,
            },
            .iovlen = 1,
            .control = control,
            .controllen = controllen,
            .flags = 0,
        };

        const sent = posix.sendmsg(
            socket,
            &msg,
            system.MSG.NOSIGNAL | system.MSG.DONTWAIT,
        ) catch |err| switch (err) {
            // Assume local socket
            error.NetworkSubsystemFailed,
            error.NetworkUnreachable => unreachable,
            else => return err;
        };

        data_to_send = data_to_send[sent..];
        fds_to_send = fds_to_send[sending_fds.len..];
    }

    // TODO actually have this function handle closing any fds that were sent,
    // even if we return with error
    // we need to somehow know which fds were unsent even if we return with
    // an error... so that needs to be handled within this function too i guess
    return fds_to_send;
}

pub fn receive(
    socket: Socket,
    data: []u8,
    fds: []FD,
    comptime fds_per_msg: usize,
) !void {
    var cmsg_buffer: [cmsg.space(@sizeOf(FD)*fds_per_msg)]u8 = undefined;

    var msg = posix.msghdr{
        .name = null,
        .namelen = 0,
        .iov = &.{
            .base = data.ptr,
            .len = data.len,
        },
        .control = &cmsg_buffer,
        .controllen = @sizeOf(@TypeOf(cmsg_buffer)),
        .flags = system.MSG.CMSG_CLOEXEC | system.MSG.DONTWAIT,
    };

    const received = try recvmsg(socket, &msg, msg.flags);
    if (received == 0) return error.BrokenPipe;
    if ((msg.flags & system.MSG.CTRUNC) != 0) {
        // TODO close received fds here too
        return error.TruncatedControlMessages;
    }

    // copy fds in from the control message (need CMSG_NXTHDR)
    if (cmsg.firsthdr(msg)) |first_hdr| {
        var control_header: ?*const cmsg.hdr = cmsg.firsthdr(msg);
        while (control_header) |control_message| : ({
            control_header = cmsg.nxthdr(msg, control_header);
        }) {
            if (
                control_message.cmsg_level == system.SOL.SOCKET and
                control_message.cmsg_type == 0x01 // os.linux.SCM.RIGHTS TODO
            ) {
                const in_fds: []const FD = mem.bytesAsSlice(FD,
                    @as([*]const u8, @ptrCast(control_message))
                        [0..control_message.cmsg_len]
                        [cmsg.@"align"(@sizeOf(hdr))..]
                );
                if (fds.len >= in_fds.len) {
                    @memcpy(fds[0..in_fds.len], in_fds);
                    fds_written += in_fds.len;
                } else {
                    for (in_fds) |fd| posix.close(fd);
                    return error.FDOverflow;
                }
            }
        }
    }
}

pub fn recvmsg(fd: FD, msg: *msghdr, flags: u32) !usize {
    while (true) {
        const received = system.recvmsg(fd, msg, flags);
        // Possibly incomplete. Look for posix.recvmsg eventually TODO
        switch (posix.errno(received)) {
            .SUCCESS => return @intCast(received),
            .INTR => continue,

            .BADF => unreachable,
            .FAULT => unreachable,
            .INVAL => unreachable,
            .NOTSOCK => unreachable,
            .PIPE => return error.BrokenPipe,
            .ACCES => return error.AccessDenied,
            .MSGSIZE => return error.MessageTooBig,
            .NOBUFFS => return error.SystemResources,
            .NOMEM => return error.SystemResources,
            .AGAIN => return error.WouldBlock,
            .NOTCONN => return error.SocketNotConnected,

            else => |err| return posix.unexpectedErrno(err),
        }
    }
}

pub const cmsg = struct {
    pub const hdr = extern struct {
        cmsg_len: system.socklen_t,
        cmsg_level: c_int,
        cmsg_type: c_int,
        // __extension__ unsigned char __cmsg_data __flexarr // Ancillary data.
    };

    // #define CMSG_DATA(cmsg) ((unsigned char *) (cmsg) + CMSG_ALIGN (sizeof (struct cmsghdr)))
    pub fn data(mhdr: *hdr) [*]u8 {
        return @as([*]u8, @ptrCast(mhdr)) + @"align"(@sizeOf(hdr));
    }

    // #define CMSG_FIRSTHDR(mhdr)
    // ((size_t) (mhdr)->msg_controllen >= sizeof (struct cmsghdr)
    //     ? (struct cmsghdr *) (mhdr)->msg_control
    //     : (struct cmsghdr *) 0)
    pub fn firsthdr(mhdr: *const posix.msghdr) ?*const hdr {
        return if ( mhdr.msg_controllen >= @sizeOf(hdr) )
            @ptrCast(mhdr.msg_control) else null;
    }

    pub fn nxthdr(mhdr: *const posix.msghdr, ctrlmsg: *const hdr) ?*const hdr {
        const control_ptr: [*]const u8 = @ptrCast(mhdr.control.?);
        const cmsg_ptr: [*]const u8 = @ptrCast(ctrlmsg);
        std.debug.assert(@intFromPtr(cmsg_ptr) >= @intFromPtr(control_ptr));
        const cmsg_offset = @intFromPtr(cmsg_ptr) - @intFromPtr(control_ptr);
        const buffer_at_msg: []const u8 = control_ptr[0..mhdr.controllen][cmsg_offset..];
        const size_needed = padding(ctrlmsg.cmsg_len) + @sizeOf(cmsg.hdr);

        if (ctrlmsg.cmsg_len < @sizeOf(cmsg.hdr)) return null;

        if (
            ( buffer_at_msg.len >= size_needed ) and
            ( buffer_at_msg.len - size_needed >= ctrlmsg.cmsg_len )
        ) {
            return @ptrCast(cmsg_ptr + cmsg.@"align"(ctrlmsg.cmsg_len))
        } else {
            return null;
        }
    }

    // #define CMSG_ALIGN(len) (((len) + sizeof (size_t) - 1) & (size_t) ~(sizeof (size_t) - 1))
    pub fn @"align"(length: usize) usize {
        const align_size: usize = @sizeOf(usize);
        const rem_bits: usize = align_size - 1;
        return ( length + rem_bits ) & ( ~rem_bits );
    }

    // #define CMSG_SPACE(len) (CMSG_ALIGN (len) + CMSG_ALIGN (sizeof (struct cmsghdr)))
    pub fn space(length: usize) usize {
        return @"align"(length) + @"align"(@sizeOf(hdr));
    }

    // #define CMSG_LEN(len) (CMSG_ALIGN (sizeof (struct cmsghdr)) + (len))
    pub fn len(length: usize) usize {
        return @"align"(@sizeOf(hdr)) + length;
    }
    // #define __CMSG_PADDING(len) ((sizeof (size_t) \
    //                           - ((len) & (sizeof (size_t) - 1))) \
    //                          & (sizeof (size_t) - 1))
    /// Given a length, return the additional apdding necessary such that
    /// length + padding(length) = align(length)
    pub fn padding(length: usize) usize) {
        const align_size: usize = @sizeOf(usize)
        const rem_bits = align_size - 1;
        return ( align_size - (length & rem_bits) ) & rem_bits;
    }
};
