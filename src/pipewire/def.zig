const std = @import("std");
const builtin = @import("builtin");
const c = @cImport({ @cInclude("def.h"); });

/// The PipeWire source version that these definitions match.
/// This does not signify an equivalent implementation.
pub const version = std.SemanticVersion{
    .major = 1,
    .minor = 0,
    .patch = 0,
};

pub const spa_version = .{
    .major = 0,
    .minor = 2,
};

pub const api_version = .{
    .major = 0,
    .minor = 3,
};

// TODO these might be defined somewhere upstream but I couldn't find them,
// for now this is from https://docs.pipewire.org/page_native_protocol.html
pub const Op = struct {
    pub const Core = struct {
        pub const Method = enum(u8) {
            hello               = 1,
            sync                = 2,
            pong                = 3,
            @"error"            = 4,
            get_registry        = 5,
            create_object       = 6,
            destroy             = 7,
        };

        pub const Event = enum(u8) {
            info                = 0,
            done                = 1,
            ping                = 2,
            @"error"            = 3,
            remove_id           = 4,
            bound_id            = 5,
            add_mem             = 6,
            remove_mem          = 7,
            bound_props         = 8,
        };
    };

    pub const Registry = struct {
        pub const Method = enum(u8) {
            bind                = 1,
            destroy             = 2,
        };

        pub const Event = enum(u8) {
            global              = 0,
            global_remove       = 1,
        };
    };

    pub const Client = struct {
        pub const Method = enum(u8) {
            @"error"            = 1,
            update_properties   = 2,
            get_permissions     = 3,
            update_permissions  = 4,
        };

        pub const Event = enum(u8) {
            info                = 0,
            permissions         = 1,
        };
    };

    pub const Device = struct {
        pub const Method = enum(u8) {
            subscribe_params    = 1,
            enum_params         = 2,
            set_param           = 3,
        };

        pub const Event = enum(u8) {
            info                = 0,
            param               = 1,
        };
    };

    pub const Factory = struct {
        pub const Method = enum(u8) {
        };

        pub const Event = enum(u8) {
            info                = 0,
        };
    };

    pub const Link = struct {
        pub const Method = enum(u8) {
        };

        pub const Event = enum(u8) {
            info                = 0,
        };
    };

    pub const Module = struct {
        pub const Method = enum(u8) {
        };

        pub const Event = enum(u8) {
            info                = 0,
        };
    };

    pub const Node = struct {
        pub const Method = enum(u8) {
            subscribe_params    = 1,
            enum_params         = 2,
            set_param           = 3,
            send_command        = 4,
        };

        pub const Event = enum(u8) {
            info                = 0,
            param               = 1,
        };
    };

    pub const Port = struct {
        pub const Method = enum(u8) {
            subscribe_params    = 1,
            enum_params         = 2,
        };

        pub const Event = enum(u8) {
            info                = 0,
            param               = 1,
        };
    };

    pub const ClientNode = struct {
        pub const Method = enum(u8) {
            get_node            = 1,
            update              = 2,
            port_update         = 3,
            set_active          = 4,
            event               = 5,
            port_buffers        = 6,
        };

        pub const Event = enum(u8) {
            transport           = 0,
            set_param           = 1,
            set_io              = 2,
            event               = 3,
            command             = 4,
            add_port            = 5,
            remove_port         = 6,
            port_set_param      = 7,
            use_buffers         = 8,
            port_set_io         = 9,
            set_activation      = 10,
            port_set_mix_info   = 11,
        };
    };

    pub const Metadata = struct {
        pub const Method = enum(u8) {
            set_property        = 1,
            clear               = 2,
        };

        pub const Event = enum(u8) {
            property            = 0,
        };
    };

    pub const Profiler = struct {
        pub const Method = enum(u8) {
        };

        pub const Event = enum(u8) {
            profile             = 0,
        };
    };
};

pub const Type = enum(u32) {
    pub const start             = c.SPA_TYPE_START;
    none                        = c.SPA_TYPE_None,
    @"bool"                     = c.SPA_TYPE_Bool,
    id                          = c.SPA_TYPE_Id,
    int                         = c.SPA_TYPE_Int,
    long                        = c.SPA_TYPE_Long,
    float                       = c.SPA_TYPE_Float,
    double                      = c.SPA_TYPE_Double,
    string                      = c.SPA_TYPE_String,
    bytes                       = c.SPA_TYPE_Bytes,
    rectangle                   = c.SPA_TYPE_Rectangle,
    fraction                    = c.SPA_TYPE_Fraction,
    bitmap                      = c.SPA_TYPE_Bitmap,
    array                       = c.SPA_TYPE_Array,
    @"struct"                   = c.SPA_TYPE_Struct,
    object                      = c.SPA_TYPE_Object,
    sequence                    = c.SPA_TYPE_Sequence,
    pointer                     = c.SPA_TYPE_Pointer,
    fd                          = c.SPA_TYPE_Fd,
    choice                      = c.SPA_TYPE_Choice,
    pod                         = c.SPA_TYPE_Pod,
    pub const last              = c._SPA_TYPE_LAST;

    pub const Pointer = enum(u32) {
        pub const start         = c.SPA_TYPE_POINTER_START;
        buffer                  = c.SPA_TYPE_POINTER_Buffer,
        meta                    = c.SPA_TYPE_POINTER_Meta,
        dict                    = c.SPA_TYPE_POINTER_Dict,
        pub const last          = c._SPA_TYPE_POINTER_LAST;
    };

    pub const Event = enum(u32) {
        pub const start         = c.SPA_TYPE_EVENT_START;
        device                  = c.SPA_TYPE_EVENT_Device,
        node                    = c.SPA_TYPE_EVENT_Node,
        pub const last          = c._SPA_TYPE_EVENT_LAST;
    };

    pub const Command = enum(u32) {
        pub const start         = c.SPA_TYPE_COMMAND_START;
        device                  = c.SPA_TYPE_COMMAND_Device,
        node                    = c.SPA_TYPE_COMMAND_Node,
        pub const last          = c._SPA_TYPE_COMMAND_LAST;
    };

    pub const Object = enum(u32) {
        pub const start         = c.SPA_TYPE_OBJECT_START;
        prop_info               = c.SPA_TYPE_OBJECT_PropInfo,
        props                   = c.SPA_TYPE_OBJECT_Props,
        format                  = c.SPA_TYPE_OBJECT_Format,
        param_buffers           = c.SPA_TYPE_OBJECT_ParamBuffers,
        param_meta              = c.SPA_TYPE_OBJECT_ParamMeta,
        param_io                = c.SPA_TYPE_OBJECT_ParamIO,
        param_profile           = c.SPA_TYPE_OBJECT_ParamProfile,
        param_port_config       = c.SPA_TYPE_OBJECT_ParamPortConfig,
        param_route             = c.SPA_TYPE_OBJECT_ParamRoute,
        profiler                = c.SPA_TYPE_OBJECT_Profiler,
        param_latency           = c.SPA_TYPE_OBJECT_ParamLatency,
        param_process_latency   = c.SPA_TYPE_OBJECT_ParamProcessLatency,
        param_tag               = c.SPA_TYPE_OBJECT_ParamTag,
        pub const last          = c._SPA_TYPE_OBJECT_LAST;
    };

    pub const VendorExtension = enum(u32) {
        pipewire                = c.SPA_TYPE_VENDOR_PipeWire,
        other                   = c.SPA_TYPE_VENDOR_Other,
    };
};

pub const Parameter = enum(u32) {
    invalid                     = c.SPA_PARAM_Invalid,
    prop_info                   = c.SPA_PARAM_PropInfo,
    props                       = c.SPA_PARAM_Props,
    enum_format                 = c.SPA_PARAM_EnumFormat,
    format                      = c.SPA_PARAM_Format,
    buffers                     = c.SPA_PARAM_Buffers,
    meta                        = c.SPA_PARAM_Meta,
    io                          = c.SPA_PARAM_IO,
    enum_profile                = c.SPA_PARAM_EnumProfile,
    profile                     = c.SPA_PARAM_Profile,
    enum_port_config            = c.SPA_PARAM_EnumPortConfig,
    port_config                 = c.SPA_PARAM_PortConfig,
    enum_route                  = c.SPA_PARAM_EnumRoute,
    route                       = c.SPA_PARAM_Route,
    control                     = c.SPA_PARAM_Control,
    latency                     = c.SPA_PARAM_Latency,
    process_latency             = c.SPA_PARAM_ProcessLatency,
    tag                         = c.SPA_PARAM_Tag,

    pub const Buffers = enum(u32) {
        pub const start         = c.SPA_PARAM_BUFFERS_START;
        buffers                 = c.SPA_PARAM_BUFFERS_buffers,
        blocks                  = c.SPA_PARAM_BUFFERS_blocks,
        size                    = c.SPA_PARAM_BUFFERS_size,
        stride                  = c.SPA_PARAM_BUFFERS_stride,
        @"align"                = c.SPA_PARAM_BUFFERS_align,
        data_type               = c.SPA_PARAM_BUFFERS_dataType,
        meta_type               = c.SPA_PARAM_BUFFERS_metaType,
    };

    pub const Bitorder = enum(u32) {
        unknown                 = c.SPA_PARAM_BITORDER_unknown,
        msb                     = c.SPA_PARAM_BITORDER_msb,
        lsb                     = c.SPA_PARAM_BITORDER_lsb,
    };

    pub const Availability = enum(u32) {
        unknown                 = c.SPA_PARAM_AVAILABILITY_unknown,
        no                      = c.SPA_PARAM_AVAILABILITY_no,
        yes                     = c.SPA_PARAM_AVAILABILITY_yes,
    };

    pub const Meta = enum(u32) {
        pub const start         = c.SPA_PARAM_META_START;
        @"type"                 = c.SPA_PARAM_META_type,
        size                    = c.SPA_PARAM_META_size,
    };

    pub const IO = enum(u32) {
        pub const start         = c.SPA_PARAM_IO_START;
        id                      = c.SPA_PARAM_IO_id,
        size                    = c.SPA_PARAM_IO_size,
    };

    pub const Profile = enum(u32) {
        pub const start         = c.SPA_PARAM_PROFILE_START;
        index                   = c.SPA_PARAM_PROFILE_index,
        name                    = c.SPA_PARAM_PROFILE_name,
        description             = c.SPA_PARAM_PROFILE_description,
        priority                = c.SPA_PARAM_PROFILE_priority,
        available               = c.SPA_PARAM_PROFILE_available,
        info                    = c.SPA_PARAM_PROFILE_info,
        classes                 = c.SPA_PARAM_PROFILE_classes,
        save                    = c.SPA_PARAM_PROFILE_save,
    };

    pub const PortConfigMode = enum(u32) {
        none                    = c.SPA_PARAM_PORT_CONFIG_MODE_none,
        passthrough             = c.SPA_PARAM_PORT_CONFIG_MODE_passthrough,
        convert                 = c.SPA_PARAM_PORT_CONFIG_MODE_convert,
        dsp                     = c.SPA_PARAM_PORT_CONFIG_MODE_dsp,
    };

    pub const PortConfig = enum(u32) {
        pub const start         = c.SPA_PARAM_PORT_CONFIG_START;
        direction               = c.SPA_PARAM_PORT_CONFIG_direction,
        mode                    = c.SPA_PARAM_PORT_CONFIG_mode,
        monitor                 = c.SPA_PARAM_PORT_CONFIG_monitor,
        control                 = c.SPA_PARAM_PORT_CONFIG_control,
        format                  = c.SPA_PARAM_PORT_CONFIG_format,
    };

    pub const Route = enum(u32) {
        pub const start         = c.SPA_PARAM_ROUTE_START;
        index                   = c.SPA_PARAM_ROUTE_index,
        direction               = c.SPA_PARAM_ROUTE_direction,
        device                  = c.SPA_PARAM_ROUTE_device,
        name                    = c.SPA_PARAM_ROUTE_name,
        description             = c.SPA_PARAM_ROUTE_description,
        priority                = c.SPA_PARAM_ROUTE_priority,
        available               = c.SPA_PARAM_ROUTE_available,
        info                    = c.SPA_PARAM_ROUTE_info,
        profiles                = c.SPA_PARAM_ROUTE_profiles,
        props                   = c.SPA_PARAM_ROUTE_props,
        devices                 = c.SPA_PARAM_ROUTE_devices,
        profile                 = c.SPA_PARAM_ROUTE_profile,
        save                    = c.SPA_PARAM_ROUTE_save,
    };

    pub const Latency = enum(u32) {
        pub const start         = c.SPA_PARAM_LATENCY_START;
        direction               = c.SPA_PARAM_LATENCY_direction,
        min_quantum             = c.SPA_PARAM_LATENCY_minQuantum,
        max_quantum             = c.SPA_PARAM_LATENCY_maxQuantum,
        min_rate                = c.SPA_PARAM_LATENCY_minRate,
        max_rate                = c.SPA_PARAM_LATENCY_maxRate,
        min_ns                  = c.SPA_PARAM_LATENCY_minNs,
        max_ns                  = c.SPA_PARAM_LATENCY_maxNs,
    };

    pub const ProcessLatency = enum(u32) {
        pub const start         = c.SPA_PARAM_PROCESS_LATENCY_START;
        quantum                 = c.SPA_PARAM_PROCESS_LATENCY_quantum,
        rate                    = c.SPA_PARAM_PROCESS_LATENCY_rate,
        ns                      = c.SPA_PARAM_PROCESS_LATENCY_ns,
    };
};

pub const Property = enum(u32) {
    pub const start             = c.SPA_PROP_START;
    pub const start_device      = c.SPA_PROP_START_Device;
    pub const start_audio       = c.SPA_PROP_START_Audio;
    pub const start_video       = c.SPA_PROP_START_Video;
    pub const start_other       = c.SPA_PROP_START_Other;
    pub const start_custom      = c.SPA_PROP_START_CUSTOM;

    unknown                     = c.SPA_PROP_unknown,

    device                      = c.SPA_PROP_device,
    device_name                 = c.SPA_PROP_deviceName,
    device_fd                   = c.SPA_PROP_deviceFd,
    card                        = c.SPA_PROP_card,
    card_name                   = c.SPA_PROP_cardName,

    min_latency                 = c.SPA_PROP_minLatency,
    max_latency                 = c.SPA_PROP_maxLatency,
    periods                     = c.SPA_PROP_periods,
    period_size                 = c.SPA_PROP_periodSize,
    period_event                = c.SPA_PROP_periodEvent,
    live                        = c.SPA_PROP_live,
    rate                        = c.SPA_PROP_rate,
    quality                     = c.SPA_PROP_quality,
    bluetooth_audio_codec       = c.SPA_PROP_bluetoothAudioCodec,
    bluetooth_offload_active    = c.SPA_PROP_bluetoothOffloadActive,

    wave_type                   = c.SPA_PROP_waveType,
    frequency                   = c.SPA_PROP_frequency,
    volume                      = c.SPA_PROP_volume,
    mute                        = c.SPA_PROP_mute,
    pattern_type                = c.SPA_PROP_patternType,
    dither_type                 = c.SPA_PROP_ditherType,
    truncate                    = c.SPA_PROP_truncate,
    channel_volumes             = c.SPA_PROP_channelVolumes,
    volume_base                 = c.SPA_PROP_volumeBase,
    volume_step                 = c.SPA_PROP_volumeStep,
    channel_map                 = c.SPA_PROP_channelMap,
    monitor_mute                = c.SPA_PROP_monitorMute,
    monitor_volumes             = c.SPA_PROP_monitorVolumes,
    latency_offset_n_sec        = c.SPA_PROP_latencyOffsetNsec,
    soft_mute                   = c.SPA_PROP_softMute,
    soft_volumes                = c.SPA_PROP_softVolumes,
    iec_958_codecs              = c.SPA_PROP_iec958codecs,
    volume_ramp_samples         = c.SPA_PROP_volumeRampSamples,
    volume_ramp_step_samples    = c.SPA_PROP_volumeRampStepSamples,
    volume_ramp_time            = c.SPA_PROP_volumeRampTime,
    volume_ramp_step_time       = c.SPA_PROP_volumeRampStepTime,
    volume_ramp_scale           = c.SPA_PROP_volumeRampScale,

    brightness                  = c.SPA_PROP_brightness,
    contrast                    = c.SPA_PROP_contrast,
    saturation                  = c.SPA_PROP_saturation,
    hue                         = c.SPA_PROP_hue,
    gamma                       = c.SPA_PROP_gamma,
    exposure                    = c.SPA_PROP_exposure,
    gain                        = c.SPA_PROP_gain,
    sharpness                   = c.SPA_PROP_sharpness,

    params                      = c.SPA_PROP_params,

    pub const Info = enum(u32) {
        pub const start         = c.SPA_PROP_INFO_START;
        id                      = c.SPA_PROP_INFO_id,
        name                    = c.SPA_PROP_INFO_name,
        @"type"                 = c.SPA_PROP_INFO_type,
        labels                  = c.SPA_PROP_INFO_labels,
        container               = c.SPA_PROP_INFO_container,
        params                  = c.SPA_PROP_INFO_params,
        description             = c.SPA_PROP_INFO_description,
    };
};

pub const Tag = enum(u32) {
    pub const start             = c.SPA_PARAM_TAG_START;
    direction                   = c.SPA_PARAM_TAG_direction,
    info                        = c.SPA_PARAM_TAG_info,
};

pub const Meta = enum(u32) {
    invalid                     = c.SPA_META_Invalid,
    header                      = c.SPA_META_Header,
    video_crop                  = c.SPA_META_VideoCrop,
    video_damage                = c.SPA_META_VideoDamage,
    bitmap                      = c.SPA_META_Bitmap,
    cursor                      = c.SPA_META_Cursor,
    control                     = c.SPA_META_Control,
    busy                        = c.SPA_META_Busy,
    video_transform             = c.SPA_META_VideoTransform,
    pub const last              = c._SPA_META_LAST;

    pub const Transformation = enum(u32) {
        none                    = c.SPA_META_TRANSFORMATION_None,
        @"90"                   = c.SPA_META_TRANSFORMATION_90,
        @"180"                  = c.SPA_META_TRANSFORMATION_180,
        @"270"                  = c.SPA_META_TRANSFORMATION_270,
        flipped                 = c.SPA_META_TRANSFORMATION_Flipped,
        flipped_90              = c.SPA_META_TRANSFORMATION_Flipped90,
        flipped_180             = c.SPA_META_TRANSFORMATION_Flipped180,
        flipped_270             = c.SPA_META_TRANSFORMATION_Flipped270,
    };
};

pub const Data = enum(u32) {
    invalid                     = c.SPA_DATA_Invalid,
    mem_ptr                     = c.SPA_DATA_MemPtr,
    mem_fd                      = c.SPA_DATA_MemFd,
    dma_buf                     = c.SPA_DATA_DmaBuf,
    mem_id                      = c.SPA_DATA_MemId,
    pub const last              = c._SPA_DATA_LAST;
};

pub const AudioFormat = enum(u32) {
    pub const start_interleaved = c.SPA_AUDIO_FORMAT_START_Interleaved;
    pub const start_planar      = c.SPA_AUDIO_FORMAT_START_Planar;
    pub const start_other       = c.SPA_AUDIO_FORMAT_START_Other;

    unknown                     = c.SPA_AUDIO_FORMAT_UNKNOWN,
    encoded                     = c.SPA_AUDIO_FORMAT_ENCODED,

    s8                          = c.SPA_AUDIO_FORMAT_S8,
    u8                          = c.SPA_AUDIO_FORMAT_U8,
    s16_le                      = c.SPA_AUDIO_FORMAT_S16_LE,
    s16_be                      = c.SPA_AUDIO_FORMAT_S16_BE,
    u16_le                      = c.SPA_AUDIO_FORMAT_U16_LE,
    u16_be                      = c.SPA_AUDIO_FORMAT_U16_BE,
    s24_32_le                   = c.SPA_AUDIO_FORMAT_S24_32_LE,
    s24_32_be                   = c.SPA_AUDIO_FORMAT_S24_32_BE,
    u24_32_le                   = c.SPA_AUDIO_FORMAT_U24_32_LE,
    u24_32_be                   = c.SPA_AUDIO_FORMAT_U24_32_BE,
    s32_le                      = c.SPA_AUDIO_FORMAT_S32_LE,
    s32_be                      = c.SPA_AUDIO_FORMAT_S32_BE,
    u32_le                      = c.SPA_AUDIO_FORMAT_U32_LE,
    u32_be                      = c.SPA_AUDIO_FORMAT_U32_BE,
    s24_le                      = c.SPA_AUDIO_FORMAT_S24_LE,
    s24_be                      = c.SPA_AUDIO_FORMAT_S24_BE,
    u24_le                      = c.SPA_AUDIO_FORMAT_U24_LE,
    u24_be                      = c.SPA_AUDIO_FORMAT_U24_BE,
    s20_le                      = c.SPA_AUDIO_FORMAT_S20_LE,
    s20_be                      = c.SPA_AUDIO_FORMAT_S20_BE,
    u20_le                      = c.SPA_AUDIO_FORMAT_U20_LE,
    u20_be                      = c.SPA_AUDIO_FORMAT_U20_BE,
    s18_le                      = c.SPA_AUDIO_FORMAT_S18_LE,
    s18_be                      = c.SPA_AUDIO_FORMAT_S18_BE,
    u18_le                      = c.SPA_AUDIO_FORMAT_U18_LE,
    u18_be                      = c.SPA_AUDIO_FORMAT_U18_BE,
    f32_le                      = c.SPA_AUDIO_FORMAT_F32_LE,
    f32_be                      = c.SPA_AUDIO_FORMAT_F32_BE,
    f64_le                      = c.SPA_AUDIO_FORMAT_F64_LE,
    f64_be                      = c.SPA_AUDIO_FORMAT_F64_BE,

    ulaw                        = c.SPA_AUDIO_FORMAT_ULAW,
    alaw                        = c.SPA_AUDIO_FORMAT_ALAW,

    u8p                         = c.SPA_AUDIO_FORMAT_U8P,
    s16p                        = c.SPA_AUDIO_FORMAT_S16P,
    s24_32p                     = c.SPA_AUDIO_FORMAT_S24_32P,
    s32p                        = c.SPA_AUDIO_FORMAT_S32P,
    s24p                        = c.SPA_AUDIO_FORMAT_S24P,
    f32p                        = c.SPA_AUDIO_FORMAT_F32P,
    f64p                        = c.SPA_AUDIO_FORMAT_F64P,
    s8p                         = c.SPA_AUDIO_FORMAT_S8P,

    pub const Interleaved = enum {
        s8,
        u8,
        s16,
        u16,
        s24_32,
        u24_32,
        s32,
        u32,
        s24,
        u24,
        s20,
        u20,
        s18,
        u18,
        f32,
        f64,

        /// Assuming native endianness
        pub fn Sample(comptime interleaved: Interleaved) type {
            return switch (interleaved) {
                .s8 => i8,
                .u8 => u8,
                .s16 => i16,
                .u16 => u16,
                .s24_32 => packed struct { value: i24, _padding: u8 = 0 },
                .u24_32 => packed struct { value: u24, _padding: u8 = 0 },
                .s32 => i32,
                .u32 => u32,
                .s24 => i16,
                .u24 => u24,
                .s20 => i20,
                .u20 => u20,
                .s18 => i18,
                .u18 => u8,
                .f32 => f32,
                .f64 => f64,
            };
        }
    };

    pub const Planar = enum {
        u8,
        s16,
        s24_32,
        s32,
        s24,
        f32,
        f64,
        s8,

        /// Assuming native endianness
        pub fn Sample(comptime planar: Planar) type {
            return switch (planar) {
                .u8 => u8,
                .s16 => i16,
                .s24_32 => packed struct { value: i24, _padding: u8 = 0 },
                .s32 => i32,
                .s24 => i24,
                .f32 => f32,
                .f64 => f64,
                .s8 => i8,
            };
        }
    };

    pub inline fn fromInterleaved(
        interleaved: Interleaved,
        endian: std.builtin.Endian,
    ) AudioFormat {
        return switch (endian) {
            .little => switch (interleaved) {
                .s8 => .s8,
                .u8 => .u8,
                .s16 => .s16_le,
                .u16 => .u16_le,
                .s24_32 => .s24_32_le,
                .u24_32 => .u24_32_le,
                .s32 => .s32_le,
                .u32 => .u32_le,
                .s24 => .s24_le,
                .u24 => .u24_le,
                .s20 => .s20_le,
                .u20 => .u20_le,
                .s18 => .s18_le,
                .u18 => .u18_le,
                .f32 => .f32_le,
                .f64 => .f64_le,
            },
            .big => switch (interleaved) {
                .s8 => .s8,
                .u8 => .u8,
                .s16 => .s16_be,
                .u16 => .u16_be,
                .s24_32 => .s24_32_be,
                .u24_32 => .u24_32_be,
                .s32 => .s32_be,
                .u32 => .u32_be,
                .s24 => .s24_be,
                .u24 => .u24_be,
                .s20 => .s20_be,
                .u20 => .u20_be,
                .s18 => .s18_be,
                .u18 => .u18_be,
                .f32 => .f32_be,
                .f64 => .f64_be,
            },
        };
    }

    pub inline fn fromInterleavedNative(interleaved: Interleaved) AudioFormat {
        return fromInterleaved(interleaved, builtin.cpu.arch.endian());
    }

    pub inline fn fromPlanar(
        planar: Planar,
    ) AudioFormat {
        return switch (planar) {
            .u8 => .u8p,
            .s16 => .s16p,
            .s24_32 => .s24_32p,
            .s32 => .s32p,
            .s24 => .s24p,
            .f32 => .f32p,
            .f64 => .f64p,
            .s8 => .s8p,
        };
    }

    pub inline fn endianness(format: AudioFormat) ?std.builtin.Endian {
        return switch (format) {
            .unknown,
            .encoded,
            .ulaw,
            .alaw,
            .s8,
            .u8,
            .u8p,
            .s16p,
            .s24_32p,
            .s32p,
            .s24p,
            .f32p,
            .f64p,
            .s8p => null,
            .s16_le,
            .u16_le,
            .s24_32_le,
            .u24_32_le,
            .s32_le,
            .u32_le,
            .s24_le,
            .u24_le,
            .s20_le,
            .u20_le,
            .s18_le,
            .u18_le,
            .f32_le,
            .f64_le => .little,
            .s16_be,
            .u16_be,
            .s24_32_be,
            .u24_32_be,
            .s32_be,
            .u32_be,
            .s24_be,
            .u24_be,
            .s20_be,
            .u20_be,
            .s18_be,
            .u18_be,
            .f32_be,
            .f64_be => .big,
        };
    }

    pub inline fn isPadded(format: AudioFormat) ?bool {
        return switch (format) {
            .unknown,
            .encoded => null,
            .s24_32_le,
            .s24_32_be,
            .u24_32_le,
            .u24_32_be => true,
            .s8,
            .s8p,
            .u8,
            .u8p,
            .s16_le,
            .s16_be,
            .s16p,
            .u16_le,
            .u16_be,
            .s32_le,
            .s32_be,
            .s32p,
            .u32_le,
            .u32_be,
            .s24_le,
            .s24_be,
            .s24p,
            .u24_le,
            .u24_be,
            .s20_le,
            .s20_be,
            .u20_le,
            .u20_be,
            .s18_le,
            .s18_be,
            .u18_le,
            .u18_be,
            .f32_le,
            .f32_be,
            .f32p,
            .f64_le,
            .f64_be,
            .f64p,
            .ulaw,
            .alaw => false,
        };
    }
};

pub const max_audio_channels    = c.SPA_AUDIO_MAX_CHANNELS;

pub const AudioChannel = enum(u32) {
    pub const start_aux         = c.SPA_AUDIO_CHANNEL_START_Aux;
    pub const last_aux          = c.SPA_AUDIO_CHANNEL_LAST_Aux;
    pub const start_custom      = c.SPA_AUDIO_CHANNEL_START_Custom;

    unknown                     = c.SPA_AUDIO_CHANNEL_UNKNOWN,
    not_applicable              = c.SPA_AUDIO_CHANNEL_NA,

    mono                        = c.SPA_AUDIO_CHANNEL_MONO,

    front_left                  = c.SPA_AUDIO_CHANNEL_FL,
    front_right                 = c.SPA_AUDIO_CHANNEL_FR,
    front_center                = c.SPA_AUDIO_CHANNEL_FC,
    low_frequency_effects       = c.SPA_AUDIO_CHANNEL_LFE,
    side_left                   = c.SPA_AUDIO_CHANNEL_SL,
    side_right                  = c.SPA_AUDIO_CHANNEL_SR,
    front_left_center           = c.SPA_AUDIO_CHANNEL_FLC,
    front_right_center          = c.SPA_AUDIO_CHANNEL_FRC,
    rear_center                 = c.SPA_AUDIO_CHANNEL_RC,
    rear_left                   = c.SPA_AUDIO_CHANNEL_RL,
    rear_right                  = c.SPA_AUDIO_CHANNEL_RR,
    top_center                  = c.SPA_AUDIO_CHANNEL_TC,
    top_front_left              = c.SPA_AUDIO_CHANNEL_TFL,
    top_front_center            = c.SPA_AUDIO_CHANNEL_TFC,
    top_front_right             = c.SPA_AUDIO_CHANNEL_TFR,
    top_rear_left               = c.SPA_AUDIO_CHANNEL_TRL,
    top_rear_center             = c.SPA_AUDIO_CHANNEL_TRC,
    top_rear_right              = c.SPA_AUDIO_CHANNEL_TRR,
    rear_left_center            = c.SPA_AUDIO_CHANNEL_RLC,
    rear_right_center           = c.SPA_AUDIO_CHANNEL_RRC,
    front_left_wide             = c.SPA_AUDIO_CHANNEL_FLW,
    front_right_wide            = c.SPA_AUDIO_CHANNEL_FRW,
    low_frequency_effects_2     = c.SPA_AUDIO_CHANNEL_LFE2,
    front_left_high             = c.SPA_AUDIO_CHANNEL_FLH,
    front_center_high           = c.SPA_AUDIO_CHANNEL_FCH,
    front_right_high            = c.SPA_AUDIO_CHANNEL_FRH,
    top_front_left_center       = c.SPA_AUDIO_CHANNEL_TFLC,
    top_front_right_center      = c.SPA_AUDIO_CHANNEL_TFRC,
    top_side_left               = c.SPA_AUDIO_CHANNEL_TSL,
    top_side_right              = c.SPA_AUDIO_CHANNEL_TSR,
    left_low_frequency_effects  = c.SPA_AUDIO_CHANNEL_LLFE,
    right_low_frequency_effects = c.SPA_AUDIO_CHANNEL_RLFE,
    bottom_center               = c.SPA_AUDIO_CHANNEL_BC,
    bottom_left_center          = c.SPA_AUDIO_CHANNEL_BLC,
    bottom_right_center         = c.SPA_AUDIO_CHANNEL_BRC,

    aux_0                       = c.SPA_AUDIO_CHANNEL_AUX0,
    aux_1                       = c.SPA_AUDIO_CHANNEL_AUX1,
    aux_2                       = c.SPA_AUDIO_CHANNEL_AUX2,
    aux_3                       = c.SPA_AUDIO_CHANNEL_AUX3,
    aux_4                       = c.SPA_AUDIO_CHANNEL_AUX4,
    aux_5                       = c.SPA_AUDIO_CHANNEL_AUX5,
    aux_6                       = c.SPA_AUDIO_CHANNEL_AUX6,
    aux_7                       = c.SPA_AUDIO_CHANNEL_AUX7,
    aux_8                       = c.SPA_AUDIO_CHANNEL_AUX8,
    aux_9                       = c.SPA_AUDIO_CHANNEL_AUX9,
    aux_10                      = c.SPA_AUDIO_CHANNEL_AUX10,
    aux_11                      = c.SPA_AUDIO_CHANNEL_AUX11,
    aux_12                      = c.SPA_AUDIO_CHANNEL_AUX12,
    aux_13                      = c.SPA_AUDIO_CHANNEL_AUX13,
    aux_14                      = c.SPA_AUDIO_CHANNEL_AUX14,
    aux_15                      = c.SPA_AUDIO_CHANNEL_AUX15,
    aux_16                      = c.SPA_AUDIO_CHANNEL_AUX16,
    aux_17                      = c.SPA_AUDIO_CHANNEL_AUX17,
    aux_18                      = c.SPA_AUDIO_CHANNEL_AUX18,
    aux_19                      = c.SPA_AUDIO_CHANNEL_AUX19,
    aux_20                      = c.SPA_AUDIO_CHANNEL_AUX20,
    aux_21                      = c.SPA_AUDIO_CHANNEL_AUX21,
    aux_22                      = c.SPA_AUDIO_CHANNEL_AUX22,
    aux_23                      = c.SPA_AUDIO_CHANNEL_AUX23,
    aux_24                      = c.SPA_AUDIO_CHANNEL_AUX24,
    aux_25                      = c.SPA_AUDIO_CHANNEL_AUX25,
    aux_26                      = c.SPA_AUDIO_CHANNEL_AUX26,
    aux_27                      = c.SPA_AUDIO_CHANNEL_AUX27,
    aux_28                      = c.SPA_AUDIO_CHANNEL_AUX28,
    aux_29                      = c.SPA_AUDIO_CHANNEL_AUX29,
    aux_30                      = c.SPA_AUDIO_CHANNEL_AUX30,
    aux_31                      = c.SPA_AUDIO_CHANNEL_AUX31,
    aux_32                      = c.SPA_AUDIO_CHANNEL_AUX32,
    aux_33                      = c.SPA_AUDIO_CHANNEL_AUX33,
    aux_34                      = c.SPA_AUDIO_CHANNEL_AUX34,
    aux_35                      = c.SPA_AUDIO_CHANNEL_AUX35,
    aux_36                      = c.SPA_AUDIO_CHANNEL_AUX36,
    aux_37                      = c.SPA_AUDIO_CHANNEL_AUX37,
    aux_38                      = c.SPA_AUDIO_CHANNEL_AUX38,
    aux_39                      = c.SPA_AUDIO_CHANNEL_AUX39,
    aux_40                      = c.SPA_AUDIO_CHANNEL_AUX40,
    aux_41                      = c.SPA_AUDIO_CHANNEL_AUX41,
    aux_42                      = c.SPA_AUDIO_CHANNEL_AUX42,
    aux_43                      = c.SPA_AUDIO_CHANNEL_AUX43,
    aux_44                      = c.SPA_AUDIO_CHANNEL_AUX44,
    aux_45                      = c.SPA_AUDIO_CHANNEL_AUX45,
    aux_46                      = c.SPA_AUDIO_CHANNEL_AUX46,
    aux_47                      = c.SPA_AUDIO_CHANNEL_AUX47,
    aux_48                      = c.SPA_AUDIO_CHANNEL_AUX48,
    aux_49                      = c.SPA_AUDIO_CHANNEL_AUX49,
    aux_50                      = c.SPA_AUDIO_CHANNEL_AUX50,
    aux_51                      = c.SPA_AUDIO_CHANNEL_AUX51,
    aux_52                      = c.SPA_AUDIO_CHANNEL_AUX52,
    aux_53                      = c.SPA_AUDIO_CHANNEL_AUX53,
    aux_54                      = c.SPA_AUDIO_CHANNEL_AUX54,
    aux_55                      = c.SPA_AUDIO_CHANNEL_AUX55,
    aux_56                      = c.SPA_AUDIO_CHANNEL_AUX56,
    aux_57                      = c.SPA_AUDIO_CHANNEL_AUX57,
    aux_58                      = c.SPA_AUDIO_CHANNEL_AUX58,
    aux_59                      = c.SPA_AUDIO_CHANNEL_AUX59,
    aux_60                      = c.SPA_AUDIO_CHANNEL_AUX60,
    aux_61                      = c.SPA_AUDIO_CHANNEL_AUX61,
    aux_62                      = c.SPA_AUDIO_CHANNEL_AUX62,
    aux_63                      = c.SPA_AUDIO_CHANNEL_AUX63,
};

pub const AudioVolumeRampScale = enum(u32) {
    invalid                     = c.SPA_AUDIO_VOLUME_RAMP_INVALID,
    linear                      = c.SPA_AUDIO_VOLUME_RAMP_LINEAR,
    cubic                       = c.SPA_AUDIO_VOLUME_RAMP_CUBIC,
};

pub const MediaType = enum(u32) {
    unknown                     = c.SPA_MEDIA_TYPE_unknown,
    audio                       = c.SPA_MEDIA_TYPE_audio,
    video                       = c.SPA_MEDIA_TYPE_video,
    image                       = c.SPA_MEDIA_TYPE_image,
    binary                      = c.SPA_MEDIA_TYPE_binary,
    stream                      = c.SPA_MEDIA_TYPE_stream,
    application                 = c.SPA_MEDIA_TYPE_application,
};

pub const MediaSubtype = enum(u32) {
    pub const start_audio       = c.SPA_MEDIA_SUBTYPE_START_Audio;
    pub const start_video       = c.SPA_MEDIA_SUBTYPE_START_Video;
    pub const start_image       = c.SPA_MEDIA_SUBTYPE_START_Image;
    pub const start_binary      = c.SPA_MEDIA_SUBTYPE_START_Binary;
    pub const start_stream      = c.SPA_MEDIA_SUBTYPE_START_Stream;
    pub const start_application = c.SPA_MEDIA_SUBTYPE_START_Application;

    unknown                     = c.SPA_MEDIA_SUBTYPE_unknown,
    raw                         = c.SPA_MEDIA_SUBTYPE_raw,
    dsp                         = c.SPA_MEDIA_SUBTYPE_dsp,
    /// S/PDIF
    iec958                      = c.SPA_MEDIA_SUBTYPE_iec958,
    dsd                         = c.SPA_MEDIA_SUBTYPE_dsd,

    // Audio
    mp3                         = c.SPA_MEDIA_SUBTYPE_mp3,
    aac                         = c.SPA_MEDIA_SUBTYPE_aac,
    vorbis                      = c.SPA_MEDIA_SUBTYPE_vorbis,
    wma                         = c.SPA_MEDIA_SUBTYPE_wma,
    ra                          = c.SPA_MEDIA_SUBTYPE_ra,
    sbc                         = c.SPA_MEDIA_SUBTYPE_sbc,
    adpcm                       = c.SPA_MEDIA_SUBTYPE_adpcm,
    g723                        = c.SPA_MEDIA_SUBTYPE_g723,
    g726                        = c.SPA_MEDIA_SUBTYPE_g726,
    g729                        = c.SPA_MEDIA_SUBTYPE_g729,
    amr                         = c.SPA_MEDIA_SUBTYPE_amr,
    gsm                         = c.SPA_MEDIA_SUBTYPE_gsm,
    alac                        = c.SPA_MEDIA_SUBTYPE_alac,
    flac                        = c.SPA_MEDIA_SUBTYPE_flac,
    ape                         = c.SPA_MEDIA_SUBTYPE_ape,
    opus                        = c.SPA_MEDIA_SUBTYPE_opus,

    // Video
    h264                        = c.SPA_MEDIA_SUBTYPE_h264,
    mjpg                        = c.SPA_MEDIA_SUBTYPE_mjpg,
    dv                          = c.SPA_MEDIA_SUBTYPE_dv,
    mpegts                      = c.SPA_MEDIA_SUBTYPE_mpegts,
    h263                        = c.SPA_MEDIA_SUBTYPE_h263,
    mpeg1                       = c.SPA_MEDIA_SUBTYPE_mpeg1,
    mpeg2                       = c.SPA_MEDIA_SUBTYPE_mpeg2,
    mpeg4                       = c.SPA_MEDIA_SUBTYPE_mpeg4,
    xvid                        = c.SPA_MEDIA_SUBTYPE_xvid,
    vc1                         = c.SPA_MEDIA_SUBTYPE_vc1,
    vp8                         = c.SPA_MEDIA_SUBTYPE_vp8,
    vp9                         = c.SPA_MEDIA_SUBTYPE_vp9,
    bayer                       = c.SPA_MEDIA_SUBTYPE_bayer,

    // Image
    jpeg                        = c.SPA_MEDIA_SUBTYPE_jpeg,

    // Stream
    midi                        = c.SPA_MEDIA_SUBTYPE_midi,

    // Application
    control                     = c.SPA_MEDIA_SUBTYPE_control,
};

pub const Format = enum(u32) {
    pub const start             = c.SPA_FORMAT_START;
    /// Media type (Id enum MediaType)
    media_type                  = c.SPA_FORMAT_media_type,
    /// Media subtype (Id enum MediaSubtype)
    media_subtype               = c.SPA_FORMAT_media_subtype,

    pub const Audio = enum(u32) {
        pub const start         = c.SPA_FORMAT_START_Audio;
        /// Audio format (Id enum AudioFormat)
        format                  = c.SPA_FORMAT_AUDIO_format,
        /// Optional flags (Int)
        flags                   = c.SPA_FORMAT_AUDIO_flags,
        /// Sample rate (Int)
        rate                    = c.SPA_FORMAT_AUDIO_rate,
        /// Number of audio channels (Int)
        channels                = c.SPA_FORMAT_AUDIO_channels,
        /// Channel positions (Id enum AudioPosition)
        position                = c.SPA_FORMAT_AUDIO_position,

        /// Codec used (IEC958) (Id enum AudioIEC958Codec)
        audio_iec958_codec      = c.SPA_FORMAT_AUDIO_iec958Codec,

        /// Bit order (Id enum Parameter.Bitorder)
        audio_bitorder          = c.SPA_FORMAT_AUDIO_bitorder,
        /// Interleave bytes (Int)
        audio_interleave        = c.SPA_FORMAT_AUDIO_interleave,
        /// Bit rate (Int)
        audio_bitrate           = c.SPA_FORMAT_AUDIO_bitrate,
        /// Audio data block alignment (Int)
        block_align             = c.SPA_FORMAT_AUDIO_blockAlign,

        /// AAC stream format (Id enum AudioAACStreamFormat)
        aac_stream_format       = c.SPA_FORMAT_AUDIO_AAC_streamFormat,

        /// WMA profile (Id enum AudioWMAProfile)
        wma_profile             = c.SPA_FORMAT_AUDIO_WMA_profile,

        /// AMR band mode (Id enum AudioAMRBandMode)
        amr_band_mode           = c.SPA_FORMAT_AUDIO_AMR_bandMode,
    };

    pub const Video = enum(u32) {
        pub const start         = c.SPA_FORMAT_START_Video;
        /// Video format (Id enum VideoFormat)
        format                  = c.SPA_FORMAT_VIDEO_format,
        /// Format modifier (Long),
        /// use only with DMA_BUF and omit for other buffer types
        modifier                = c.SPA_FORMAT_VIDEO_modifier,
        /// Size (Rectangle)
        size                    = c.SPA_FORMAT_VIDEO_size,
        /// Frame rate (Fraction)
        framerate               = c.SPA_FORMAT_VIDEO_framerate,
        /// Maximum frame rate (Fraction)
        max_framerate           = c.SPA_FORMAT_VIDEO_maxFramerate,
        /// Number of views (Int)
        views                   = c.SPA_FORMAT_VIDEO_views,
        /// (Id enum InterlaceMode)
        interlace_mode          = c.SPA_FORMAT_VIDEO_interlaceMode,
        /// (Rectangle)
        pixel_aspect_ratio      = c.SPA_FORMAT_VIDEO_pixelAspectRatio,
        /// (Id enum MultiviewMode)
        multiview_mode          = c.SPA_FORMAT_VIDEO_multiviewMode,
        /// (Id enum MultiviewFlags)
        multiview_flags         = c.SPA_FORMAT_VIDEO_multiviewFlags,
        /// (Id enum ChromaSite)
        chroma_site             = c.SPA_FORMAT_VIDEO_chromaSite,
        /// (Id enum ColorRange)
        color_range             = c.SPA_FORMAT_VIDEO_colorRange,
        /// (Id enum ColorMatrix)
        color_matrix            = c.SPA_FORMAT_VIDEO_colorMatrix,
        /// (Id enum TransferFunction)
        transfer_function       = c.SPA_FORMAT_VIDEO_transferFunction,
        /// (Id enum ColorPrimaries)
        color_primaries         = c.SPA_FORMAT_VIDEO_colorPrimaries,
        /// (Int)
        profile                 = c.SPA_FORMAT_VIDEO_profile,
        /// (Int)
        level                   = c.SPA_FORMAT_VIDEO_level,
        /// (Id enum H264StreamFormat)
        h264_stream_format      = c.SPA_FORMAT_VIDEO_H264_streamFormat,
        /// (Id enum H264Alignment)
        h264_alignment          = c.SPA_FORMAT_VIDEO_H264_alignment,
    };

    pub const Image = enum(u32) {
        pub const image         = c.SPA_FORMAT_START_Image;
    };

    pub const Binary = enum(u32) {
        pub const start         = c.SPA_FORMAT_START_Binary;
    };

    pub const Stream = enum(u32) {
        pub const start         = c.SPA_FORMAT_START_Stream;
    };

    pub const Application = enum(u32) {
        pub const start         = c.SPA_FORMAT_START_Application;
    };
};

pub const Control = enum(u32) {
    invalid                     = c.SPA_CONTROL_Invalid,
    properties                  = c.SPA_CONTROL_Properties,
    midi                        = c.SPA_CONTROL_Midi,
    osc                         = c.SPA_CONTROL_OSC,
    ump                         = c.SPA_CONTROL_UMP,
    pub const last              = c._SPA_CONTROL_LAST;
};

pub const Choice = enum(u32) {
    none                        = c.SPA_CHOICE_None,
    range                       = c.SPA_CHOICE_Range,
    step                        = c.SPA_CHOICE_Step,
    @"enum"                     = c.SPA_CHOICE_Enum,
    flags                       = c.SPA_CHOICE_Flags,
};
