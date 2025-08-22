// Copied segments of the PipeWire 1.0.0 tag headers

/* spa/utils/type.h */

enum {
	/* Basic types */
	SPA_TYPE_START = 0x00000,
	SPA_TYPE_None,
	SPA_TYPE_Bool,
	SPA_TYPE_Id,
	SPA_TYPE_Int,
	SPA_TYPE_Long,
	SPA_TYPE_Float,
	SPA_TYPE_Double,
	SPA_TYPE_String,
	SPA_TYPE_Bytes,
	SPA_TYPE_Rectangle,
	SPA_TYPE_Fraction,
	SPA_TYPE_Bitmap,
	SPA_TYPE_Array,
	SPA_TYPE_Struct,
	SPA_TYPE_Object,
	SPA_TYPE_Sequence,
	SPA_TYPE_Pointer,
	SPA_TYPE_Fd,
	SPA_TYPE_Choice,
	SPA_TYPE_Pod,
	_SPA_TYPE_LAST,				/**< not part of ABI */

	/* Pointers */
	SPA_TYPE_POINTER_START = 0x10000,
	SPA_TYPE_POINTER_Buffer,
	SPA_TYPE_POINTER_Meta,
	SPA_TYPE_POINTER_Dict,
	_SPA_TYPE_POINTER_LAST,			/**< not part of ABI */

	/* Events */
	SPA_TYPE_EVENT_START = 0x20000,
	SPA_TYPE_EVENT_Device,
	SPA_TYPE_EVENT_Node,
	_SPA_TYPE_EVENT_LAST,			/**< not part of ABI */

	/* Commands */
	SPA_TYPE_COMMAND_START = 0x30000,
	SPA_TYPE_COMMAND_Device,
	SPA_TYPE_COMMAND_Node,
	_SPA_TYPE_COMMAND_LAST,			/**< not part of ABI */

	/* Objects */
	SPA_TYPE_OBJECT_START = 0x40000,
	SPA_TYPE_OBJECT_PropInfo,
	SPA_TYPE_OBJECT_Props,
	SPA_TYPE_OBJECT_Format,
	SPA_TYPE_OBJECT_ParamBuffers,
	SPA_TYPE_OBJECT_ParamMeta,
	SPA_TYPE_OBJECT_ParamIO,
	SPA_TYPE_OBJECT_ParamProfile,
	SPA_TYPE_OBJECT_ParamPortConfig,
	SPA_TYPE_OBJECT_ParamRoute,
	SPA_TYPE_OBJECT_Profiler,
	SPA_TYPE_OBJECT_ParamLatency,
	SPA_TYPE_OBJECT_ParamProcessLatency,
	SPA_TYPE_OBJECT_ParamTag,
	_SPA_TYPE_OBJECT_LAST,			/**< not part of ABI */

	/* vendor extensions */
	SPA_TYPE_VENDOR_PipeWire	= 0x02000000,

	SPA_TYPE_VENDOR_Other		= 0x7f000000,
};

/* spa/param/param.h */

/** different parameter types that can be queried */
enum spa_param_type {
	SPA_PARAM_Invalid,		/**< invalid */
	SPA_PARAM_PropInfo,		/**< property information as SPA_TYPE_OBJECT_PropInfo */
	SPA_PARAM_Props,		/**< properties as SPA_TYPE_OBJECT_Props */
	SPA_PARAM_EnumFormat,		/**< available formats as SPA_TYPE_OBJECT_Format */
	SPA_PARAM_Format,		/**< configured format as SPA_TYPE_OBJECT_Format */
	SPA_PARAM_Buffers,		/**< buffer configurations as SPA_TYPE_OBJECT_ParamBuffers*/
	SPA_PARAM_Meta,			/**< allowed metadata for buffers as SPA_TYPE_OBJECT_ParamMeta*/
	SPA_PARAM_IO,			/**< configurable IO areas as SPA_TYPE_OBJECT_ParamIO */
	SPA_PARAM_EnumProfile,		/**< profile enumeration as SPA_TYPE_OBJECT_ParamProfile */
	SPA_PARAM_Profile,		/**< profile configuration as SPA_TYPE_OBJECT_ParamProfile */
	SPA_PARAM_EnumPortConfig,	/**< port configuration enumeration as SPA_TYPE_OBJECT_ParamPortConfig */
	SPA_PARAM_PortConfig,		/**< port configuration as SPA_TYPE_OBJECT_ParamPortConfig */
	SPA_PARAM_EnumRoute,		/**< routing enumeration as SPA_TYPE_OBJECT_ParamRoute */
	SPA_PARAM_Route,		/**< routing configuration as SPA_TYPE_OBJECT_ParamRoute */
	SPA_PARAM_Control,		/**< Control parameter, a SPA_TYPE_Sequence */
	SPA_PARAM_Latency,		/**< latency reporting, a SPA_TYPE_OBJECT_ParamLatency */
	SPA_PARAM_ProcessLatency,	/**< processing latency, a SPA_TYPE_OBJECT_ParamProcessLatency */
	SPA_PARAM_Tag,			/**< tag reporting, a SPA_TYPE_OBJECT_ParamTag. Since 0.3.79 */
};

enum spa_param_bitorder {
	SPA_PARAM_BITORDER_unknown,	/**< unknown bitorder */
	SPA_PARAM_BITORDER_msb,		/**< most significant bit */
	SPA_PARAM_BITORDER_lsb,		/**< least significant bit */
};

enum spa_param_availability {
	SPA_PARAM_AVAILABILITY_unknown,	/**< unknown availability */
	SPA_PARAM_AVAILABILITY_no,	/**< not available */
	SPA_PARAM_AVAILABILITY_yes,	/**< available */
};

/* spa/param/buffers.h */

/** properties for SPA_TYPE_OBJECT_ParamBuffers */
enum spa_param_buffers {
	SPA_PARAM_BUFFERS_START,
	SPA_PARAM_BUFFERS_buffers,	/**< number of buffers (Int) */
	SPA_PARAM_BUFFERS_blocks,	/**< number of data blocks per buffer (Int) */
	SPA_PARAM_BUFFERS_size,		/**< size of a data block memory (Int)*/
	SPA_PARAM_BUFFERS_stride,	/**< stride of data block memory (Int) */
	SPA_PARAM_BUFFERS_align,	/**< alignment of data block memory (Int) */
	SPA_PARAM_BUFFERS_dataType,	/**< possible memory types (Int, mask of enum spa_data_type) */
};

/** properties for SPA_TYPE_OBJECT_ParamMeta */
enum spa_param_meta {
	SPA_PARAM_META_START,
	SPA_PARAM_META_type,	/**< the metadata, one of enum spa_meta_type (Id enum spa_meta_type) */
	SPA_PARAM_META_size,	/**< the expected maximum size the meta (Int) */
};

/* spa/param/profile.h */

/** properties for SPA_TYPE_OBJECT_ParamIO */
enum spa_param_io {
	SPA_PARAM_IO_START,
	SPA_PARAM_IO_id,	/**< type ID, uniquely identifies the io area (Id enum spa_io_type) */
	SPA_PARAM_IO_size,	/**< size of the io area (Int) */
};
/** properties for SPA_TYPE_OBJECT_ParamProfile */
enum spa_param_profile {
	SPA_PARAM_PROFILE_START,
	SPA_PARAM_PROFILE_index,	/**< profile index (Int) */
	SPA_PARAM_PROFILE_name,		/**< profile name (String) */
	SPA_PARAM_PROFILE_description,	/**< profile description (String) */
	SPA_PARAM_PROFILE_priority,	/**< profile priority (Int) */
	SPA_PARAM_PROFILE_available,	/**< availability of the profile
					  *  (Id enum spa_param_availability) */
	SPA_PARAM_PROFILE_info,		/**< info (Struct(
					  *		  Int : n_items,
					  *		  (String : key,
					  *		   String : value)*)) */
	SPA_PARAM_PROFILE_classes,	/**< node classes provided by this profile
					  *  (Struct(
					  *	   Int : number of items following
					  *        Struct(
					  *           String : class name (eg. "Audio/Source"),
					  *           Int : number of nodes
					  *           String : property (eg. "card.profile.devices"),
					  *           Array of Int: device indexes
					  *         )*)) */
	SPA_PARAM_PROFILE_save,		/**< If profile should be saved (Bool) */
};

/* spa/param/port-config.h */

enum spa_param_port_config_mode {
	SPA_PARAM_PORT_CONFIG_MODE_none,	/**< no configuration */
	SPA_PARAM_PORT_CONFIG_MODE_passthrough,	/**< passthrough configuration */
	SPA_PARAM_PORT_CONFIG_MODE_convert,	/**< convert configuration */
	SPA_PARAM_PORT_CONFIG_MODE_dsp,		/**< dsp configuration, depending on the external
						  *  format. For audio, ports will be configured for
						  *  the given number of channels with F32 format. */
};

/** properties for SPA_TYPE_OBJECT_ParamPortConfig */
enum spa_param_port_config {
	SPA_PARAM_PORT_CONFIG_START,
	SPA_PARAM_PORT_CONFIG_direction,	/**< (Id enum spa_direction) direction */
	SPA_PARAM_PORT_CONFIG_mode,		/**< (Id enum spa_param_port_config_mode) mode */
	SPA_PARAM_PORT_CONFIG_monitor,		/**< (Bool) enable monitor output ports on input ports */
	SPA_PARAM_PORT_CONFIG_control,		/**< (Bool) enable control ports */
	SPA_PARAM_PORT_CONFIG_format,		/**< (Object) format filter */
};

/* spa/param/route.h */

/** properties for SPA_TYPE_OBJECT_ParamRoute */
enum spa_param_route {
	SPA_PARAM_ROUTE_START,
	SPA_PARAM_ROUTE_index,			/**< index of the routing destination (Int) */
	SPA_PARAM_ROUTE_direction,		/**< direction, input/output (Id enum spa_direction) */
	SPA_PARAM_ROUTE_device,			/**< device id (Int) */
	SPA_PARAM_ROUTE_name,			/**< name of the routing destination (String) */
	SPA_PARAM_ROUTE_description,		/**< description of the destination (String) */
	SPA_PARAM_ROUTE_priority,		/**< priority of the destination (Int) */
	SPA_PARAM_ROUTE_available,		/**< availability of the destination
						  *  (Id enum spa_param_availability) */
	SPA_PARAM_ROUTE_info,			/**< info (Struct(
						  *		  Int : n_items,
						  *		  (String : key,
						  *		   String : value)*)) */
	SPA_PARAM_ROUTE_profiles,		/**< associated profile indexes (Array of Int) */
	SPA_PARAM_ROUTE_props,			/**< properties SPA_TYPE_OBJECT_Props */
	SPA_PARAM_ROUTE_devices,		/**< associated device indexes (Array of Int) */
	SPA_PARAM_ROUTE_profile,		/**< profile id (Int) */
	SPA_PARAM_ROUTE_save,			/**< If route should be saved (Bool) */
};

/* spa/param/latency.h */

/** properties for SPA_TYPE_OBJECT_ParamLatency */
enum spa_param_latency {
	SPA_PARAM_LATENCY_START,
	SPA_PARAM_LATENCY_direction,		/**< direction, input/output (Id enum spa_direction) */
	SPA_PARAM_LATENCY_minQuantum,	/**< min latency relative to quantum (Float) */
	SPA_PARAM_LATENCY_maxQuantum,		/**< max latency relative to quantum (Float) */
	SPA_PARAM_LATENCY_minRate,		/**< min latency (Int) relative to rate */
	SPA_PARAM_LATENCY_maxRate,		/**< max latency (Int) relative to rate */
	SPA_PARAM_LATENCY_minNs,		/**< min latency (Long) in nanoseconds */
	SPA_PARAM_LATENCY_maxNs,		/**< max latency (Long) in nanoseconds */
};

/** properties for SPA_TYPE_OBJECT_ParamProcessLatency */
enum spa_param_process_latency {
	SPA_PARAM_PROCESS_LATENCY_START,
	SPA_PARAM_PROCESS_LATENCY_quantum,	/**< latency relative to quantum (Float) */
	SPA_PARAM_PROCESS_LATENCY_rate,		/**< latency (Int) relative to rate */
	SPA_PARAM_PROCESS_LATENCY_ns,		/**< latency (Long) in nanoseconds */
};

/* spa/param/props.h */

/** properties of SPA_TYPE_OBJECT_PropInfo */
enum spa_prop_info {
	SPA_PROP_INFO_START,
	SPA_PROP_INFO_id,		/**< associated id of the property */
	SPA_PROP_INFO_name,		/**< name of the property */
	SPA_PROP_INFO_type,		/**< type and range/enums of property */
	SPA_PROP_INFO_labels,		/**< labels of property if any, this is a
					  *  struct with pairs of values, the first one
					  *  is of the type of the property, the second
					  *  one is a string with a user readable label
					  *  for the value. */
	SPA_PROP_INFO_container,	/**< type of container if any (Id) */
	SPA_PROP_INFO_params,		/**< is part of params property (Bool) */
	SPA_PROP_INFO_description,	/**< User readable description */
};

/** predefined properties for SPA_TYPE_OBJECT_Props */
enum spa_prop {
	SPA_PROP_START,

	SPA_PROP_unknown,		/**< an unknown property */

	SPA_PROP_START_Device	= 0x100,	/**< device related properties */
	SPA_PROP_device,
	SPA_PROP_deviceName,
	SPA_PROP_deviceFd,
	SPA_PROP_card,
	SPA_PROP_cardName,

	SPA_PROP_minLatency,
	SPA_PROP_maxLatency,
	SPA_PROP_periods,
	SPA_PROP_periodSize,
	SPA_PROP_periodEvent,
	SPA_PROP_live,
	SPA_PROP_rate,
	SPA_PROP_quality,
	SPA_PROP_bluetoothAudioCodec,
	SPA_PROP_bluetoothOffloadActive,

	SPA_PROP_START_Audio	= 0x10000,	/**< audio related properties */
	SPA_PROP_waveType,
	SPA_PROP_frequency,
	SPA_PROP_volume,			/**< a volume (Float), 0.0 silence, 1.0 no attenutation */
	SPA_PROP_mute,				/**< mute (Bool) */
	SPA_PROP_patternType,
	SPA_PROP_ditherType,
	SPA_PROP_truncate,
	SPA_PROP_channelVolumes,		/**< a volume array, one (linear) volume per channel
						  * (Array of Float). 0.0 is silence, 1.0 is
						  *  without attenuation. This is the effective
						  *  volume that is applied. It can result
						  *  in a hardware volume and software volume
						  *  (see softVolumes) */
	SPA_PROP_volumeBase,			/**< a volume base (Float) */
	SPA_PROP_volumeStep,			/**< a volume step (Float) */
	SPA_PROP_channelMap,			/**< a channelmap array
						  * (Array (Id enum spa_audio_channel)) */
	SPA_PROP_monitorMute,			/**< mute (Bool) */
	SPA_PROP_monitorVolumes,		/**< a volume array, one (linear) volume per
						  *  channel (Array of Float) */
	SPA_PROP_latencyOffsetNsec,		/**< delay adjustment */
	SPA_PROP_softMute,			/**< mute (Bool) applied in software */
	SPA_PROP_softVolumes,			/**< a volume array, one (linear) volume per channel
						  * (Array of Float). 0.0 is silence, 1.0 is without
						  * attenuation. This is the volume applied in
						  * software, there might be a part applied in
						  * hardware. */

	SPA_PROP_iec958Codecs,			/**< enabled IEC958 (S/PDIF) codecs,
						  *  (Array (Id enum spa_audio_iec958_codec) */
	SPA_PROP_volumeRampSamples,		/**< Samples to ramp the volume over */
	SPA_PROP_volumeRampStepSamples,		/**< Step or incremental Samples to ramp
						  *  the volume over */
	SPA_PROP_volumeRampTime,		/**< Time in millisec to ramp the volume over */
	SPA_PROP_volumeRampStepTime,		/**< Step or incremental Time in nano seconds
						  *  to ramp the */
	SPA_PROP_volumeRampScale,		/**< the scale or graph to used to ramp the
						  *  volume */

	SPA_PROP_START_Video	= 0x20000,	/**< video related properties */
	SPA_PROP_brightness,
	SPA_PROP_contrast,
	SPA_PROP_saturation,
	SPA_PROP_hue,
	SPA_PROP_gamma,
	SPA_PROP_exposure,
	SPA_PROP_gain,
	SPA_PROP_sharpness,

	SPA_PROP_START_Other	= 0x80000,	/**< other properties */
	SPA_PROP_params,			/**< simple control params
						  *    (Struct(
						  *	  (String : key,
						  *	   Pod    : value)*)) */


	SPA_PROP_START_CUSTOM	= 0x1000000,
};

/* spa/param/param.h */

/** properties for SPA_TYPE_OBJECT_ParamTag */
enum spa_param_tag {
	SPA_PARAM_TAG_START,
	SPA_PARAM_TAG_direction,		/**< direction, input/output (Id enum spa_direction) */
	SPA_PARAM_TAG_info,			/**< Struct(
						  *      Int: n_items
						  *      (String: key
						  *       String: value)*
						  *  ) */
};

/* spa/param/audio/raw.h */

#define SPA_AUDIO_MAX_CHANNELS	64u

enum spa_audio_format {
	SPA_AUDIO_FORMAT_UNKNOWN,
	SPA_AUDIO_FORMAT_ENCODED,

	/* interleaved formats */
	SPA_AUDIO_FORMAT_START_Interleaved	= 0x100,
	SPA_AUDIO_FORMAT_S8,
	SPA_AUDIO_FORMAT_U8,
	SPA_AUDIO_FORMAT_S16_LE,
	SPA_AUDIO_FORMAT_S16_BE,
	SPA_AUDIO_FORMAT_U16_LE,
	SPA_AUDIO_FORMAT_U16_BE,
	SPA_AUDIO_FORMAT_S24_32_LE,
	SPA_AUDIO_FORMAT_S24_32_BE,
	SPA_AUDIO_FORMAT_U24_32_LE,
	SPA_AUDIO_FORMAT_U24_32_BE,
	SPA_AUDIO_FORMAT_S32_LE,
	SPA_AUDIO_FORMAT_S32_BE,
	SPA_AUDIO_FORMAT_U32_LE,
	SPA_AUDIO_FORMAT_U32_BE,
	SPA_AUDIO_FORMAT_S24_LE,
	SPA_AUDIO_FORMAT_S24_BE,
	SPA_AUDIO_FORMAT_U24_LE,
	SPA_AUDIO_FORMAT_U24_BE,
	SPA_AUDIO_FORMAT_S20_LE,
	SPA_AUDIO_FORMAT_S20_BE,
	SPA_AUDIO_FORMAT_U20_LE,
	SPA_AUDIO_FORMAT_U20_BE,
	SPA_AUDIO_FORMAT_S18_LE,
	SPA_AUDIO_FORMAT_S18_BE,
	SPA_AUDIO_FORMAT_U18_LE,
	SPA_AUDIO_FORMAT_U18_BE,
	SPA_AUDIO_FORMAT_F32_LE,
	SPA_AUDIO_FORMAT_F32_BE,
	SPA_AUDIO_FORMAT_F64_LE,
	SPA_AUDIO_FORMAT_F64_BE,

	SPA_AUDIO_FORMAT_ULAW,
	SPA_AUDIO_FORMAT_ALAW,

	/* planar formats */
	SPA_AUDIO_FORMAT_START_Planar		= 0x200,
	SPA_AUDIO_FORMAT_U8P,
	SPA_AUDIO_FORMAT_S16P,
	SPA_AUDIO_FORMAT_S24_32P,
	SPA_AUDIO_FORMAT_S32P,
	SPA_AUDIO_FORMAT_S24P,
	SPA_AUDIO_FORMAT_F32P,
	SPA_AUDIO_FORMAT_F64P,
	SPA_AUDIO_FORMAT_S8P,

	/* other formats start here */
	SPA_AUDIO_FORMAT_START_Other		= 0x400,
};

enum spa_audio_channel {
	SPA_AUDIO_CHANNEL_UNKNOWN,	/**< unspecified */
	SPA_AUDIO_CHANNEL_NA,		/**< N/A, silent */

	SPA_AUDIO_CHANNEL_MONO,         /**< mono stream */

	SPA_AUDIO_CHANNEL_FL,           /**< front left */
	SPA_AUDIO_CHANNEL_FR,           /**< front right */
	SPA_AUDIO_CHANNEL_FC,           /**< front center */
	SPA_AUDIO_CHANNEL_LFE,          /**< LFE */
	SPA_AUDIO_CHANNEL_SL,           /**< side left */
	SPA_AUDIO_CHANNEL_SR,           /**< side right */
	SPA_AUDIO_CHANNEL_FLC,          /**< front left center */
	SPA_AUDIO_CHANNEL_FRC,          /**< front right center */
	SPA_AUDIO_CHANNEL_RC,           /**< rear center */
	SPA_AUDIO_CHANNEL_RL,           /**< rear left */
	SPA_AUDIO_CHANNEL_RR,           /**< rear right */
	SPA_AUDIO_CHANNEL_TC,           /**< top center */
	SPA_AUDIO_CHANNEL_TFL,          /**< top front left */
	SPA_AUDIO_CHANNEL_TFC,          /**< top front center */
	SPA_AUDIO_CHANNEL_TFR,          /**< top front right */
	SPA_AUDIO_CHANNEL_TRL,          /**< top rear left */
	SPA_AUDIO_CHANNEL_TRC,          /**< top rear center */
	SPA_AUDIO_CHANNEL_TRR,          /**< top rear right */
	SPA_AUDIO_CHANNEL_RLC,          /**< rear left center */
	SPA_AUDIO_CHANNEL_RRC,          /**< rear right center */
	SPA_AUDIO_CHANNEL_FLW,          /**< front left wide */
	SPA_AUDIO_CHANNEL_FRW,          /**< front right wide */
	SPA_AUDIO_CHANNEL_LFE2,		/**< LFE 2 */
	SPA_AUDIO_CHANNEL_FLH,          /**< front left high */
	SPA_AUDIO_CHANNEL_FCH,          /**< front center high */
	SPA_AUDIO_CHANNEL_FRH,          /**< front right high */
	SPA_AUDIO_CHANNEL_TFLC,         /**< top front left center */
	SPA_AUDIO_CHANNEL_TFRC,         /**< top front right center */
	SPA_AUDIO_CHANNEL_TSL,          /**< top side left */
	SPA_AUDIO_CHANNEL_TSR,          /**< top side right */
	SPA_AUDIO_CHANNEL_LLFE,         /**< left LFE */
	SPA_AUDIO_CHANNEL_RLFE,         /**< right LFE */
	SPA_AUDIO_CHANNEL_BC,           /**< bottom center */
	SPA_AUDIO_CHANNEL_BLC,          /**< bottom left center */
	SPA_AUDIO_CHANNEL_BRC,          /**< bottom right center */

	SPA_AUDIO_CHANNEL_START_Aux	= 0x1000,	/**< aux channels */
	SPA_AUDIO_CHANNEL_AUX0 = SPA_AUDIO_CHANNEL_START_Aux,
	SPA_AUDIO_CHANNEL_AUX1,
	SPA_AUDIO_CHANNEL_AUX2,
	SPA_AUDIO_CHANNEL_AUX3,
	SPA_AUDIO_CHANNEL_AUX4,
	SPA_AUDIO_CHANNEL_AUX5,
	SPA_AUDIO_CHANNEL_AUX6,
	SPA_AUDIO_CHANNEL_AUX7,
	SPA_AUDIO_CHANNEL_AUX8,
	SPA_AUDIO_CHANNEL_AUX9,
	SPA_AUDIO_CHANNEL_AUX10,
	SPA_AUDIO_CHANNEL_AUX11,
	SPA_AUDIO_CHANNEL_AUX12,
	SPA_AUDIO_CHANNEL_AUX13,
	SPA_AUDIO_CHANNEL_AUX14,
	SPA_AUDIO_CHANNEL_AUX15,
	SPA_AUDIO_CHANNEL_AUX16,
	SPA_AUDIO_CHANNEL_AUX17,
	SPA_AUDIO_CHANNEL_AUX18,
	SPA_AUDIO_CHANNEL_AUX19,
	SPA_AUDIO_CHANNEL_AUX20,
	SPA_AUDIO_CHANNEL_AUX21,
	SPA_AUDIO_CHANNEL_AUX22,
	SPA_AUDIO_CHANNEL_AUX23,
	SPA_AUDIO_CHANNEL_AUX24,
	SPA_AUDIO_CHANNEL_AUX25,
	SPA_AUDIO_CHANNEL_AUX26,
	SPA_AUDIO_CHANNEL_AUX27,
	SPA_AUDIO_CHANNEL_AUX28,
	SPA_AUDIO_CHANNEL_AUX29,
	SPA_AUDIO_CHANNEL_AUX30,
	SPA_AUDIO_CHANNEL_AUX31,
	SPA_AUDIO_CHANNEL_AUX32,
	SPA_AUDIO_CHANNEL_AUX33,
	SPA_AUDIO_CHANNEL_AUX34,
	SPA_AUDIO_CHANNEL_AUX35,
	SPA_AUDIO_CHANNEL_AUX36,
	SPA_AUDIO_CHANNEL_AUX37,
	SPA_AUDIO_CHANNEL_AUX38,
	SPA_AUDIO_CHANNEL_AUX39,
	SPA_AUDIO_CHANNEL_AUX40,
	SPA_AUDIO_CHANNEL_AUX41,
	SPA_AUDIO_CHANNEL_AUX42,
	SPA_AUDIO_CHANNEL_AUX43,
	SPA_AUDIO_CHANNEL_AUX44,
	SPA_AUDIO_CHANNEL_AUX45,
	SPA_AUDIO_CHANNEL_AUX46,
	SPA_AUDIO_CHANNEL_AUX47,
	SPA_AUDIO_CHANNEL_AUX48,
	SPA_AUDIO_CHANNEL_AUX49,
	SPA_AUDIO_CHANNEL_AUX50,
	SPA_AUDIO_CHANNEL_AUX51,
	SPA_AUDIO_CHANNEL_AUX52,
	SPA_AUDIO_CHANNEL_AUX53,
	SPA_AUDIO_CHANNEL_AUX54,
	SPA_AUDIO_CHANNEL_AUX55,
	SPA_AUDIO_CHANNEL_AUX56,
	SPA_AUDIO_CHANNEL_AUX57,
	SPA_AUDIO_CHANNEL_AUX58,
	SPA_AUDIO_CHANNEL_AUX59,
	SPA_AUDIO_CHANNEL_AUX60,
	SPA_AUDIO_CHANNEL_AUX61,
	SPA_AUDIO_CHANNEL_AUX62,
	SPA_AUDIO_CHANNEL_AUX63,

	SPA_AUDIO_CHANNEL_LAST_Aux	= 0x1fff,	/**< aux channels */

	SPA_AUDIO_CHANNEL_START_Custom	= 0x10000,
};

enum spa_audio_volume_ramp_scale {
	SPA_AUDIO_VOLUME_RAMP_INVALID,
	SPA_AUDIO_VOLUME_RAMP_LINEAR,
	SPA_AUDIO_VOLUME_RAMP_CUBIC,
};

/* spa/param/format.h */

/** media type for SPA_TYPE_OBJECT_Format */
enum spa_media_type {
	SPA_MEDIA_TYPE_unknown,
	SPA_MEDIA_TYPE_audio,
	SPA_MEDIA_TYPE_video,
	SPA_MEDIA_TYPE_image,
	SPA_MEDIA_TYPE_binary,
	SPA_MEDIA_TYPE_stream,
	SPA_MEDIA_TYPE_application,
};

/** media subtype for SPA_TYPE_OBJECT_Format */
enum spa_media_subtype {
	SPA_MEDIA_SUBTYPE_unknown,
	SPA_MEDIA_SUBTYPE_raw,
	SPA_MEDIA_SUBTYPE_dsp,
	SPA_MEDIA_SUBTYPE_iec958,	/** S/PDIF */
	SPA_MEDIA_SUBTYPE_dsd,

	SPA_MEDIA_SUBTYPE_START_Audio	= 0x10000,
	SPA_MEDIA_SUBTYPE_mp3,
	SPA_MEDIA_SUBTYPE_aac,
	SPA_MEDIA_SUBTYPE_vorbis,
	SPA_MEDIA_SUBTYPE_wma,
	SPA_MEDIA_SUBTYPE_ra,
	SPA_MEDIA_SUBTYPE_sbc,
	SPA_MEDIA_SUBTYPE_adpcm,
	SPA_MEDIA_SUBTYPE_g723,
	SPA_MEDIA_SUBTYPE_g726,
	SPA_MEDIA_SUBTYPE_g729,
	SPA_MEDIA_SUBTYPE_amr,
	SPA_MEDIA_SUBTYPE_gsm,
	SPA_MEDIA_SUBTYPE_alac,		/** since 0.3.65 */
	SPA_MEDIA_SUBTYPE_flac,		/** since 0.3.65 */
	SPA_MEDIA_SUBTYPE_ape,		/** since 0.3.65 */
	SPA_MEDIA_SUBTYPE_opus,		/** since 0.3.68 */

	SPA_MEDIA_SUBTYPE_START_Video	= 0x20000,
	SPA_MEDIA_SUBTYPE_h264,
	SPA_MEDIA_SUBTYPE_mjpg,
	SPA_MEDIA_SUBTYPE_dv,
	SPA_MEDIA_SUBTYPE_mpegts,
	SPA_MEDIA_SUBTYPE_h263,
	SPA_MEDIA_SUBTYPE_mpeg1,
	SPA_MEDIA_SUBTYPE_mpeg2,
	SPA_MEDIA_SUBTYPE_mpeg4,
	SPA_MEDIA_SUBTYPE_xvid,
	SPA_MEDIA_SUBTYPE_vc1,
	SPA_MEDIA_SUBTYPE_vp8,
	SPA_MEDIA_SUBTYPE_vp9,
	SPA_MEDIA_SUBTYPE_bayer,

	SPA_MEDIA_SUBTYPE_START_Image	= 0x30000,
	SPA_MEDIA_SUBTYPE_jpeg,

	SPA_MEDIA_SUBTYPE_START_Binary	= 0x40000,

	SPA_MEDIA_SUBTYPE_START_Stream	= 0x50000,
	SPA_MEDIA_SUBTYPE_midi,

	SPA_MEDIA_SUBTYPE_START_Application	= 0x60000,
	SPA_MEDIA_SUBTYPE_control,		/**< control stream, data contains
						  *  spa_pod_sequence with control info. */
};

/** properties for audio SPA_TYPE_OBJECT_Format */
enum spa_format {
	SPA_FORMAT_START,

	SPA_FORMAT_mediaType,		/**< media type (Id enum spa_media_type) */
	SPA_FORMAT_mediaSubtype,	/**< media subtype (Id enum spa_media_subtype) */

	/* Audio format keys */
	SPA_FORMAT_START_Audio = 0x10000,
	SPA_FORMAT_AUDIO_format,		/**< audio format, (Id enum spa_audio_format) */
	SPA_FORMAT_AUDIO_flags,			/**< optional flags (Int) */
	SPA_FORMAT_AUDIO_rate,			/**< sample rate (Int) */
	SPA_FORMAT_AUDIO_channels,		/**< number of audio channels (Int) */
	SPA_FORMAT_AUDIO_position,		/**< channel positions (Id enum spa_audio_position) */

	SPA_FORMAT_AUDIO_iec958Codec,		/**< codec used (IEC958) (Id enum spa_audio_iec958_codec) */

	SPA_FORMAT_AUDIO_bitorder,		/**< bit order (Id enum spa_param_bitorder) */
	SPA_FORMAT_AUDIO_interleave,		/**< Interleave bytes (Int) */
	SPA_FORMAT_AUDIO_bitrate,		/**< bit rate (Int) */
	SPA_FORMAT_AUDIO_blockAlign,    	/**< audio data block alignment (Int) */

	SPA_FORMAT_AUDIO_AAC_streamFormat,	/**< AAC stream format, (Id enum spa_audio_aac_stream_format) */

	SPA_FORMAT_AUDIO_WMA_profile,		/**< WMA profile (Id enum spa_audio_wma_profile) */

	SPA_FORMAT_AUDIO_AMR_bandMode,		/**< AMR band mode (Id enum spa_audio_amr_band_mode) */


	/* Video Format keys */
	SPA_FORMAT_START_Video = 0x20000,
	SPA_FORMAT_VIDEO_format,		/**< video format (Id enum spa_video_format) */
	SPA_FORMAT_VIDEO_modifier,		/**< format modifier (Long)
						  * use only with DMA-BUF and omit for other buffer types */
	SPA_FORMAT_VIDEO_size,			/**< size (Rectangle) */
	SPA_FORMAT_VIDEO_framerate,		/**< frame rate (Fraction) */
	SPA_FORMAT_VIDEO_maxFramerate,		/**< maximum frame rate (Fraction) */
	SPA_FORMAT_VIDEO_views,			/**< number of views (Int) */
	SPA_FORMAT_VIDEO_interlaceMode,		/**< (Id enum spa_video_interlace_mode) */
	SPA_FORMAT_VIDEO_pixelAspectRatio,	/**< (Rectangle) */
	SPA_FORMAT_VIDEO_multiviewMode,		/**< (Id enum spa_video_multiview_mode) */
	SPA_FORMAT_VIDEO_multiviewFlags,	/**< (Id enum spa_video_multiview_flags) */
	SPA_FORMAT_VIDEO_chromaSite,		/**< /Id enum spa_video_chroma_site) */
	SPA_FORMAT_VIDEO_colorRange,		/**< /Id enum spa_video_color_range) */
	SPA_FORMAT_VIDEO_colorMatrix,		/**< /Id enum spa_video_color_matrix) */
	SPA_FORMAT_VIDEO_transferFunction,	/**< /Id enum spa_video_transfer_function) */
	SPA_FORMAT_VIDEO_colorPrimaries,	/**< /Id enum spa_video_color_primaries) */
	SPA_FORMAT_VIDEO_profile,		/**< (Int) */
	SPA_FORMAT_VIDEO_level,			/**< (Int) */
	SPA_FORMAT_VIDEO_H264_streamFormat,	/**< (Id enum spa_h264_stream_format) */
	SPA_FORMAT_VIDEO_H264_alignment,	/**< (Id enum spa_h264_alignment) */

	/* Image Format keys */
	SPA_FORMAT_START_Image = 0x30000,
	/* Binary Format keys */
	SPA_FORMAT_START_Binary = 0x40000,
	/* Stream Format keys */
	SPA_FORMAT_START_Stream = 0x50000,
	/* Application Format keys */
	SPA_FORMAT_START_Application = 0x60000,
};

/* spa/control/control.h */

/** Different Control types */
enum spa_control_type {
	SPA_CONTROL_Invalid,
	SPA_CONTROL_Properties,		/**< data contains a SPA_TYPE_OBJECT_Props */
	SPA_CONTROL_Midi,		/**< data contains a spa_pod_bytes with raw midi data */
	SPA_CONTROL_OSC,		/**< data contains a spa_pod_bytes with an OSC packet */

	_SPA_CONTROL_LAST,		/**< not part of ABI */
};

/* spa/buffer/buffer.h */

enum spa_data_type {
	SPA_DATA_Invalid,
	SPA_DATA_MemPtr,		/**< pointer to memory, the data field in
					  *  struct spa_data is set. */
	SPA_DATA_MemFd,			/**< generic fd, mmap to get to memory */
	SPA_DATA_DmaBuf,		/**< fd to dmabuf memory */
	SPA_DATA_MemId,			/**< memory is identified with an id */

	_SPA_DATA_LAST,			/**< not part of ABI */
};

/* spa/buffer/meta.h */

enum spa_meta_type {
	SPA_META_Invalid,
	SPA_META_Header,		/**< struct spa_meta_header */
	SPA_META_VideoCrop,		/**< struct spa_meta_region with cropping data */
	SPA_META_VideoDamage,		/**< array of struct spa_meta_region with damage, where an invalid entry or end-of-array marks the end. */
	SPA_META_Bitmap,		/**< struct spa_meta_bitmap */
	SPA_META_Cursor,		/**< struct spa_meta_cursor */
	SPA_META_Control,		/**< metadata contains a spa_meta_control
					  *  associated with the data */
	SPA_META_Busy,			/**< don't write to buffer when count > 0 */
	SPA_META_VideoTransform,	/**< struct spa_meta_transform */

	_SPA_META_LAST,			/**< not part of ABI/API */
};

enum spa_meta_videotransform_value {
	SPA_META_TRANSFORMATION_None = 0,	/**< no transform */
	SPA_META_TRANSFORMATION_90,		/**< 90 degree counter-clockwise */
	SPA_META_TRANSFORMATION_180,		/**< 180 degree counter-clockwise */
	SPA_META_TRANSFORMATION_270,		/**< 270 degree counter-clockwise */
	SPA_META_TRANSFORMATION_Flipped,	/**< 180 degree flipped around the vertical axis. Equivalent
						  * to a reflexion through the vertical line splitting the
						  * bufffer in two equal sized parts */
	SPA_META_TRANSFORMATION_Flipped90,	/**< flip then rotate around 90 degree counter-clockwise */
	SPA_META_TRANSFORMATION_Flipped180,	/**< flip then rotate around 180 degree counter-clockwise */
	SPA_META_TRANSFORMATION_Flipped270,	/**< flip then rotate around 270 degree counter-clockwise */
};

/* spa/pod/pod.h */

enum spa_choice_type {
	SPA_CHOICE_None,		/**< no choice, first value is current */
	SPA_CHOICE_Range,		/**< range: default, min, max */
	SPA_CHOICE_Step,		/**< range with step: default, min, max, step */
	SPA_CHOICE_Enum,		/**< list: default, alternative,...  */
	SPA_CHOICE_Flags,		/**< flags: default, possible flags,... */
};
