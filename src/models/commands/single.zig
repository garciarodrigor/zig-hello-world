const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");
const BaseCommand = @import("base.zig");

const Self = @This();

super: BaseCommand,

pub fn init(name: []const u8) Self {
    return Self{
        .super = BaseCommand.init(name),
    };
}

pub fn getName(self: *const Self) []const u8 {
    return self.super.getName();
}

pub fn execute(self: *const Self) anyerror!void {
    std.log.info("Executing {s}\n", .{self.getName()});
}

pub fn command(self: *const Self) apis.commands.Command {
    return apis.commands.Command.init(self);
}

test "models/commands/SingleCommand.init" {
    const obj = Self.init("test-name");

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "models/commands/SingleCommand.execute" {
    const obj = Self.init("test-name");

    try obj.execute();
}
