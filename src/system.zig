const std = @import("std");
const posix = std.posix;
const system = posix.system;
const assert = std.debug.assert;

pub fn connect(path: []const u8) !posix.socket_t {
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

    const fd: posix.socket_t = try posix.socket(
        system.PF.LOCAL,
        system.SOCK.STREAM | system.SOCK.CLOEXEC | system.SOCK.NONBLOCK,
        0,
    );
    errdefer posix.close(fd);

    try posix.connect(fd, @ptrCast(&addr), size);

    return fd;
}
