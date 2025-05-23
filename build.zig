const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "test_dll",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();
    lib.linkSystemLibrary("kernel32");
    lib.linkSystemLibrary("user32");

    b.installArtifact(lib);
}
