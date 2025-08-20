const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const pipewire = b.dependency("pipewire", .{});
    const translate_pipewire = b.addTranslateC(.{
        .root_source_file = pipewire.path("src/pipewire/pipewire.h"),
        .target = target,
        .optimize = optimize,
    });
    const config_pipewire_version = b.addConfigHeader(.{
        .style = .{ .autoconf_at = pipewire.path("src/pipewire/version.h.in") },
        .include_path = "pipewire/version.h",
    }, .{
         // TODO these are defined in pipewire's meson.build and should be read from there
        .PIPEWIRE_VERSION_MAJOR = "1",
        .PIPEWIRE_VERSION_MINOR = "0",
        .PIPEWIRE_VERSION_MICRO = "0",
        .PIPEWIRE_API_VERSION = "0.3",
    });
    translate_pipewire.addConfigHeader(config_pipewire_version);
    translate_pipewire.addIncludePath(pipewire.path("src"));
    translate_pipewire.addIncludePath(pipewire.path("spa/include"));

    const lib_mod = b.addModule("auxcrow", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_mod.addAnonymousImport("pipewire_translation", .{
        .root_source_file = translate_pipewire.getOutput(),
    });

    const lib = b.addLibrary(.{
        .name = "auxcrow",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{ .root_module = lib_mod });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
