const std = @import("std");
const spa = @import("def.zig");

pub const alignment = 8;

fn totalSize(size: u32) u32 {
    return roundUpAssertNonzero(8 + size, 8);
}

inline fn roundUpAssertNonzero(
    n: anytype,
    least_multiple_of: @TypeOf(n),
) @TypeOf(n) {
    const n_info = @typeInfo(@TypeOf(n));
    if (n_info != .int or n_info.int.signedness != .unsigned)
        @compileError("unsupported roundup type " ++ @typeName(@TypeOf(n)));

    std.debug.assert(least_multiple_of != 0);
    std.debug.assert(n != 0);

    // See std.math.divCeil
    return ( @divFloor(n - 1, least_multiple_of) + 1 ) * least_multiple_of;
}
test roundUpAssertNonzero {
    try std.testing.expectEqual(8,  roundUpAssertNonzero(8, 8));
    try std.testing.expectEqual(16, roundUpAssertNonzero(8+4, 8));
    try std.testing.expectEqual(16, roundUpAssertNonzero(8+8, 8));
    try std.testing.expectEqual(16, roundUpAssertNonzero(8+1, 8));
    try std.testing.expectEqual(16, roundUpAssertNonzero(8+6, 8));
    try std.testing.expectEqual(24, roundUpAssertNonzero(8+9, 8));
}

fn isPacked(comptime POD: type) bool {
    var fields_size = 0;
    for ( @typeInfo(POD).@"struct".fields ) |field|
        fields_size += @sizeOf(field.type);
    return fields_size == @sizeOf(POD);
}

// POD structs are defined as extern to keep the fields in sequential order.

comptime {
    for (.{ None, Bool, Id, Int, Long, Float, Double,
            Rectangle, Fraction, Pointer, Fd }) |POD| {
        std.debug.assert(isPacked(POD));
        const header_size = @typeInfo(POD).@"struct".fields[0].defaultValue().?;
        std.debug.assert(totalSize(header_size) == @sizeOf(POD));
    }
}

pub const None = extern struct {
    size: u32 align(alignment) = 0,
    @"type": spa.Type = .none,
};

pub const Bool = extern struct {
    size: u32 align(alignment) = 4,
    @"type": spa.Type = .@"bool",
    value: i32,
    _padding: u32 = 0,

    pub inline fn toBool(@"bool": Bool) bool {
        return if ( @"bool".value == 0 ) false else true;
    }
};

pub const Id = extern struct {
    size: u32 align(alignment) = 4,
    @"type": spa.Type = .id,
    value: u32,
    _padding: u32 = 0,
};

pub const Int = extern struct {
    size: u32 align(alignment) = 4,
    @"type": spa.Type = .int,
    value: i32,
    _padding: u32 = 0,
};

pub const Long = extern struct {
    size: u32 align(alignment) = 8,
    @"type": spa.Type = .long,
    value: i64,
    _padding: u32 = 0,
};

pub const Float = extern struct {
    size: u32 align(alignment) = 4,
    @"type": spa.Type = .float,
    value: f32,
    _padding: u32 = 0,
};

pub const Double = extern struct {
    size: u32 align(alignment) = 8,
    @"type": spa.Type = .double,
    value: f64,
};

pub const Rectangle = extern struct {
    size: u32 align(alignment) = 8,
    @"type": spa.Type = .rectangle,
    width: u32,
    height: u32,
};

pub const Fraction = extern struct {
    size: u32 align(alignment) = 8,
    @"type": spa.Type = .fraction,
    numerator: u32,
    denominator: u32,
};

pub const Pointer = extern struct {
    size: u32 align(alignment) = 16,
    @"type": spa.Type = .pointer,
    pointer_type: spa.Type.Pointer,
    _padding: u32 = 0,
    value: usize,
    _end_padding: decide_padding: {
        const remainder_padding: u16 = (16*std.mem.byte_size_in_bits)
            - @bitSizeOf(spa.Type.Pointer)
            - @bitSizeOf(u32)
            - @bitSizeOf(usize);
        if (remainder_padding >= 0) {
            break :decide_padding @Type(.{ .int = .{
                .signedness = .unsigned,
                .bits = remainder_padding,
            }});
        } else {
            @compileError(std.fmt.comptimePrint(
                "native pointer bitwidth {d} overflows"
                    ++ " the SPA declared 16 byte Pointer POD body size"
            ));
        }
    } = 0,
};

pub const Fd = extern struct {
    size: u32 align(alignment) = 8,
    @"type": spa.Type = .fd,
    value: i64,
};
