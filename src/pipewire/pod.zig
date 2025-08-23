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
            Rectangle, Fraction, Pointer, Fd,
            object.RawAudioFormatUnpositioned,
            object.RawAudioFormat(1),
            object.RawAudioFormat(2),
            object.RawAudioFormat(3),
            object.RawAudioFormatChoiceUnpositioned(1),
            object.RawAudioFormatChoiceUnpositioned(2),
            object.RawAudioFormatChoiceUnpositioned(3),
            object.RawAudioFormatChoice(1, 1),
            object.RawAudioFormatChoice(1, 2),
            object.RawAudioFormatChoice(1, 3),
            object.RawAudioFormatChoice(2, 1),
            object.RawAudioFormatChoice(2, 2),
            object.RawAudioFormatChoice(2, 3),
            object.RawAudioFormatChoice(3, 1),
            object.RawAudioFormatChoice(3, 2),
            object.RawAudioFormatChoice(3, 3),
    }) |POD| {
        std.debug.assert(isPacked(POD));
        const header_size = @typeInfo(POD).@"struct".fields[0].defaultValue().?;
        std.debug.assert(totalSize(header_size) == @sizeOf(POD));
        std.debug.assert(@sizeOf(POD)%8==0);
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

pub const object = struct {
    pub const RawAudioFormatUnpositioned = extern struct {
        header_size: u32 align(alignment) =
            @sizeOf(@This())
            - @sizeOf(u32)
            - @sizeOf(spa.Type), // TODO test
        header_type: spa.Type = .object,
        object_type: spa.Type.Object = .format,
        object_id: spa.Parameter = .format,

        media_type_key: spa.Format = .media_type,
        media_type_flag: u32 = 0,
        media_type_header_size: u32 align(alignment) = 4,
        media_type_header_type: spa.Type = .id,
        media_type: spa.MediaType = .audio,
        _media_type_padding: u32 = 0,

        media_subtype_key: spa.Format = .media_subtype,
        media_subtype_flag: u32 = 0,
        media_subtype_header_size: u32 align(alignment) = 4,
        media_subtype_header_type: spa.Type = .id,
        media_subtype: spa.MediaSubtype = .raw,
        _media_subtype_padding: u32 = 0,

        format_key: spa.Format = .format,
        format_flags: u32 = 0,
        format_header_size: u32 align(alignment) = 4,
        format_header_type: spa.Type = .id,
        format: spa.RawAudioFormat,
        _format_padding: u32 = 0,

        rate_key: spa.Format = .rate,
        rate_flags: u32 = 0,
        rate_header_size: u32 align(alignment) = 4,
        rate_header_type: spa.Type = .int,
        rate: i32,
        _rate_padding: u32 = 0,

        channels_key: spa.Format = .channels,
        channels_flags: u32 = 0,
        channels_header_size: u32 align(alignment) = 4,
        channels_header_type: spa.Type = .int,
        channels: i32,
        _channels_padding: u32 = 0,
    };

    pub fn RawAudioFormat(comptime channels: i32) type {
        if (channels > spa.max_audio_channels) {
            @compileError(std.fmt.comptimePrint(
                // TODO supply API version in error
                "{d} channels exceeds the maximum {d} from PipeWire",
                .{ channels, spa.max_audio_channels },
            ));
        }

        if (channels <= 0) {
            @compileError(std.fmt.comptimePrint(
                "cannot create a {s} POD of {d} channels",
                .{ @typeName(@This()), channels },
            ));
        }

        return extern struct {
            header_size: u32 align(alignment) =
                @sizeOf(@This())
                - @sizeOf(u32)
                - @sizeOf(spa.Type), // TODO test
            header_type: spa.Type = .object,
            object_type: spa.Type.Object = .format,
            object_id: spa.Parameter = .format,

            media_type_key: spa.Format = .media_type,
            media_type_flag: u32 = 0,
            media_type_header_size: u32 align(alignment) = 4,
            media_type_header_type: spa.Type = .id,
            media_type: spa.MediaType = .audio,
            _media_type_padding: u32 = 0,

            media_subtype_key: spa.Format = .media_subtype,
            media_subtype_flag: u32 = 0,
            media_subtype_header_size: u32 align(alignment) = 4,
            media_subtype_header_type: spa.Type = .id,
            media_subtype: spa.MediaSubtype = .raw,
            _media_subtype_padding: u32 = 0,

            format_key: spa.Format = .format,
            format_flags: u32 = 0,
            format_header_size: u32 align(alignment) = 4,
            format_header_type: spa.Type = .id,
            format: spa.RawAudioFormat,
            _format_padding: u32 = 0,

            rate_key: spa.Format = .rate,
            rate_flags: u32 = 0,
            rate_header_size: u32 align(alignment) = 4,
            rate_header_type: spa.Type = .int,
            rate: i32,
            _rate_padding: u32 = 0,

            channels_key: spa.Format = .channels,
            channels_flags: u32 = 0,
            channels_header_size: u32 align(alignment) = 4,
            channels_header_type: spa.Type = .int,
            channels: i32 = channels,
            _channels_padding: u32 = 0,

            positions_key: spa.Format = .position,
            positions_flags: u32 = 0,
            positions_header_size: u32 align(alignment) =
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([channels]spa.AudioChannel),
            positions_header_type: spa.Type = .array,
            positions_child_size: u32 = 4,
            positions_child_type: spa.Type = .id,
            positions: [channels]spa.AudioChannel,
            _positions_padding: @Type(.{ .int = .{
                .signedness = .unsigned,
                .bits = if (channels%2==0) 0 else std.mem.byte_size_in_bits*4,
            }}) = 0,
        };
    }

    pub fn RawAudioFormatChoiceUnpositioned(comptime format_choices: usize) type {
        if (format_choices == 0) {
            @compileError(std.fmt.comptimePrint(
                "cannot create a {s} POD of {d} formats",
                .{ @typeName(@This()), format_choices },
            ));
        }

        return extern struct {
            header_size: u32 align(alignment) =
                @sizeOf(@This())
                - @sizeOf(u32)
                - @sizeOf(spa.Type), // TODO test
            header_type: spa.Type = .object,
            object_type: spa.Type.Object = .format,
            object_id: spa.Parameter = .enum_format,

            media_type_key: spa.Format = .media_type,
            media_type_flag: u32 = 0,
            media_type_header_size: u32 align(alignment) = 4,
            media_type_header_type: spa.Type = .id,
            media_type: spa.MediaType = .audio,
            _media_type_padding: u32 = 0,

            media_subtype_key: spa.Format = .media_subtype,
            media_subtype_flag: u32 = 0,
            media_subtype_header_size: u32 align(alignment) = 4,
            media_subtype_header_type: spa.Type = .id,
            media_subtype: spa.MediaSubtype = .raw,
            _media_subtype_padding: u32 = 0,

            format_key: spa.Format = .format,
            format_flags: u32 = 0,
            format_header_size: u32 align(alignment) =
                @sizeOf(spa.Choice) +
                @sizeOf(u32) +
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([format_choices]spa.RawAudioFormat),
            format_header_type: spa.Type = .choice,
            format_choice_type: spa.Choice = .@"enum",
            format_choice_flags: u32 = 0,
            format_choice_child_size: u32 = 4,
            format_choice_child_type: spa.Type = .id,
            /// The possible formats, in descending order of preference.
            formats: [format_choices]spa.RawAudioFormat,
            _format_padding: @Type(.{ .int = .{
                .signedness = .unsigned,
                .bits = if (format_choices%2==0) 0 else std.mem.byte_size_in_bits*4,
            }}) = 0,

            rate_key: spa.Format = .rate,
            rate_flags: u32 = 0,
            rate_header_size: u32 align(alignment) =
                @sizeOf(spa.Choice) +
                @sizeOf(u32) +
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([3]i32),
            rate_header_type: spa.Type = .choice,
            rate_choice_type: spa.Choice = .range,
            rate_choice_flags: u32 = 0,
            rate_choice_child_size: u32 = 4,
            rate_choice_child_type: spa.Type = .int,
            /// The range of possible rates;
            /// default, minimum, and maximum respectively.
            rates: [3]i32,
            _rate_padding: u32 = 0,

            channels_key: spa.Format = .channels,
            channels_flags: u32 = 0,
            channels_header_size: u32 align(alignment) = 4,
            channels_header_type: spa.Type = .int,
            channels: i32,
            _channels_padding: u32 = 0,
        };
    }

    pub fn RawAudioFormatChoice(
        comptime format_choices: usize,
        comptime channels: i32,
    ) type {
        if (format_choices == 0) {
            @compileError(std.fmt.comptimePrint(
                "cannot create a {s} POD of {d} format choices",
                .{ @typeName(@This()), format_choices },
            ));
        }

        if (channels > spa.max_audio_channels) {
            @compileError(std.fmt.comptimePrint(
                // TODO supply API version in error
                "{d} channels exceeds the maximum {d} from PipeWire",
                .{ channels, spa.max_audio_channels },
            ));
        }

        if (channels <= 0) {
            @compileError(std.fmt.comptimePrint(
                "cannot create a {s} POD of {d} channels",
                .{ @typeName(@This()), channels },
            ));
        }

        return extern struct {
            header_size: u32 align(alignment) =
                @sizeOf(@This())
                - @sizeOf(u32)
                - @sizeOf(spa.Type), // TODO test
            header_type: spa.Type = .object,
            object_type: spa.Type.Object = .format,
            object_id: spa.Parameter = .enum_format,

            media_type_key: spa.Format = .media_type,
            media_type_flag: u32 = 0,
            media_type_header_size: u32 align(alignment) = 4,
            media_type_header_type: spa.Type = .id,
            media_type: spa.MediaType = .audio,
            _media_type_padding: u32 = 0,

            media_subtype_key: spa.Format = .media_subtype,
            media_subtype_flag: u32 = 0,
            media_subtype_header_size: u32 align(alignment) = 4,
            media_subtype_header_type: spa.Type = .id,
            media_subtype: spa.MediaSubtype = .raw,
            _media_subtype_padding: u32 = 0,

            format_key: spa.Format = .format,
            format_flags: u32 = 0,
            format_header_size: u32 align(alignment) =
                @sizeOf(spa.Choice) +
                @sizeOf(u32) +
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([format_choices]spa.RawAudioFormat),
            format_header_type: spa.Type = .choice,
            format_choice_type: spa.Choice = .@"enum",
            format_choice_flags: u32 = 0,
            format_choice_child_size: u32 = 4,
            format_choice_child_type: spa.Type = .id,
            /// The possible formats, in descending order of preference.
            formats: [format_choices]spa.RawAudioFormat,
            _format_padding: @Type(.{ .int = .{
                .signedness = .unsigned,
                .bits = if (format_choices%2==0) 0 else std.mem.byte_size_in_bits*4,
            }}) = 0,

            rate_key: spa.Format = .rate,
            rate_flags: u32 = 0,
            rate_header_size: u32 align(alignment) =
                @sizeOf(spa.Choice) +
                @sizeOf(u32) +
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([3]i32),
            rate_header_type: spa.Type = .choice,
            rate_choice_type: spa.Choice = .range,
            rate_choice_flags: u32 = 0,
            rate_choice_child_size: u32 = 4,
            rate_choice_child_type: spa.Type = .int,
            /// The range of possible rates;
            /// default, minimum, and maximum respectively.
            rates: [3]i32,
            _rate_padding: u32 = 0,

            channels_key: spa.Format = .channels,
            channels_flags: u32 = 0,
            channels_header_size: u32 align(alignment) = 4,
            channels_header_type: spa.Type = .int,
            channels: i32 = channels,
            _channels_padding: u32 = 0,

            positions_key: spa.Format = .position,
            positions_flags: u32 = 0,
            positions_header_size: u32 align(alignment) =
                @sizeOf(u32) +
                @sizeOf(spa.Type) +
                @sizeOf([channels]spa.AudioChannel),
            positions_header_type: spa.Type = .array,
            positions_child_size: u32 = 4,
            positions_child_type: spa.Type = .id,
            positions: [channels]spa.AudioChannel,
            _positions_padding: @Type(.{ .int = .{
                .signedness = .unsigned,
                .bits = if (channels%2==0) 0 else std.mem.byte_size_in_bits*4,
            }}) = 0,
        };
    }
};
