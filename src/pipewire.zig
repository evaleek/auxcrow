const std = @import("std");
const translation = @import("pipewire_translation");

pub const version = std.SemanticVersion{
    .major = translation.PW_MAJOR,
    .minor = translation.PW_MINOR,
    .patch = translation.PW_MICRO,
};

pub const api_version: [:0]const u8 = translation.api_version;
