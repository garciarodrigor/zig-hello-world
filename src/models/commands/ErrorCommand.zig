const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");
const BaseCommand = @import("BaseCommand.zig");

const Self = @This();

super: BaseCommand,
err: anyerror,

pub fn init(name: []const u8, err: anyerror) Self {
    return Self{
        .super = BaseCommand.init(name),
        .err = err,
    };
}

pub fn getName(self: *const Self) []const u8 {
    return self.super.getName();
}

pub fn execute(self: *const Self) anyerror!void {
    return self.err;
}

pub fn command(self: *const Self) apis.commands.Command {
    return apis.commands.Command.init(self);
}

test "init" {
    const obj = Self.init("test-name", apis.commands.CommandError.Uninplemented);

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "execute" {
    const Error = error{
        Unknown,
    };

    const obj = Self.init("test-name", Error.Unknown);

    try testing.expectError(Error.Unknown, obj.execute());
}
