const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");

const Self = @This();

name: []const u8,

pub fn init(name: []const u8) Self {
    return Self{
        .name = name,
    };
}

pub fn command(self: *const Self) apis.commands.Command {
    return apis.commands.Command.init(self);
}

// Implement Command Interface
pub fn getName(self: *const Self) []const u8 {
    return self.name;
}

pub fn execute(_: *const Self) anyerror!void {
    return apis.commands.CommandError.Uninplemented;
}

test "models/commands/BaseCommand.init" {
    const obj = Self.init("test-name");

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "models/commands/BaseCommand.execute" {
    const obj = Self.init("test-name");

    try testing.expectError(apis.commands.CommandError.Uninplemented, obj.execute());
}
