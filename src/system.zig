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
        assert(std.mem.eql(u8, "path", fields[fields.len-1].name));
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

pub const cmsg = struct {
    pub const hdr = extern struct {
        cmsg_len: system.socklen_t,
        cmsg_level: c_int,
        cmsg_type: c_int,
        // __extension__ unsigned char __cmsg_data __flexarr // Ancillary data.
    };

    // #define CMSG_DATA(cmsg) ((unsigned char *) (cmsg) + CMSG_ALIGN (sizeof (struct cmsghdr)))
    pub fn data(mhdr: *hdr) *u8 {
        return @as(*u8, @ptrCast(mhdr)) + @"align"(@sizeOf(hdr));
    }

    // #define CMSG_FIRSTHDR(mhdr)
    // ((size_t) (mhdr)->msg_controllen >= sizeof (struct cmsghdr)
    //     ? (struct cmsghdr *) (mhdr)->msg_control
    //     : (struct cmsghdr *) 0)
    pub fn firsthdr(mhdr: posix.msghdr) ?*hdr {
        return if ( mhdr.msg_controllen >= @sizeOf(hdr) )
            @ptrCast(mhdr.msg_control) else null;
    }

    // #define CMSG_ALIGN(len) (((len) + sizeof (size_t) - 1) & (size_t) ~(sizeof (size_t) - 1))
    pub fn @"align"(length: usize) usize {
        const size_t_size: usize = @sizeOf(usize);
        const rem_bits: usize = size_t_size - 1;
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
};
