const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");
const BaseCommand = @import("BaseCommand.zig");

const Self = @This();

super: BaseCommand,
cmds: apis.commands.CommandArray,

pub fn init(name: []const u8, cmds: apis.commands.CommandArray) Self {
    return Self{
        .super = BaseCommand.init(name),
        .cmds = cmds,
    };
}

pub fn getName(self: *const Self) []const u8 {
    return self.super.getName();
}

pub fn execute(self: *const Self) anyerror!void {
    for (self.cmds) |cmd| {
        try cmd.execute();
    }
}

pub fn command(self: *const Self) apis.commands.Command {
    return apis.commands.Command.init(self);
}

test "init" {
    const obj = Self.init("test-name", &.{});

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "execute" {
    const ErrorCommand = @import("ErrorCommand.zig");

    const TestError = error{
        ChildError,
    };

    const bc = ErrorCommand.init("test-child", TestError.ChildError);

    const obj = Self.init("test-name", &.{bc.command()});

    try testing.expectError(TestError.ChildError, obj.execute());
}
