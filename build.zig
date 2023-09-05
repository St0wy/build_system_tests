const std = @import("std");
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const stowyPhysicsEngine = b.addSharedLibrary(.{
        .name = "stowy_physics_engine",
        .target = target,
        .optimize = optimize,
    });
    stowyPhysicsEngine.linkLibCpp();
    stowyPhysicsEngine.force_pic = true;
    stowyPhysicsEngine.addCSourceFiles(&.{"stowy_physics_engine/src/math/Vector2.cpp"}, &.{ "-std=c++20", "-DSTWEXPORT" });
    stowyPhysicsEngine.addIncludePath(.{ .path = "stowy_physics_engine/src/" });

    const testbed = b.addExecutable(.{
        .name = "testbed",
        .target = target,
        .optimize = optimize,
    });
    testbed.linkLibCpp();
    testbed.linkLibrary(stowyPhysicsEngine);
    testbed.addIncludePath(.{ .path = "stowy_physics_engine/src/" });
    testbed.addIncludePath(.{ .path = "testbed/src" });
    testbed.addCSourceFiles(&.{"testbed/src/main.cpp"}, &.{"-std=c++20"});
    testbed.linkSystemLibrary("c++");

    // LTO is enabled by default, but doesnt work on windows...
    testbed.want_lto = false;

    b.installArtifact(testbed);

    const run_cmd = b.addRunArtifact(testbed);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
