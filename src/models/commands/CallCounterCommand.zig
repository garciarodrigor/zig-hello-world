const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");

const Self = @This();

super: apis.commands.Command,
okCounter: u32,
errCounter: u32,

pub fn init(cmd: apis.commands.Command) Self {
    return Self{
        .super = cmd,
        .okCounter = 0,
        .errCounter = 0,
    };
}

pub fn getOkCalls(self: *const Self) u32 {
    return self.okCounter;
}

pub fn getErrCalls(self: *const Self) u32 {
    return self.errCounter;
}

pub fn getTotalCalls(self: *const Self) u32 {
    return self.getOkCalls() + self.getErrCalls();
}

// Implement Command Interface
pub fn getName(self: *const Self) []const u8 {
    return self.super.getName();
}

// Note: change from "*const Self" to "*Self" because we mute it
pub fn execute(self: *Self) anyerror!void {
    defer self.okCounter += 1;
    errdefer self.errCounter += 1;

    return self.super.execute();
}

test "init" {
    const SingleCommand = @import("SingleCommand.zig");
    const Command = apis.commands.Command;

    const obj = Self.init(Command.init(&SingleCommand.init("test-name")));

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "execute" {
    const SingleCommand = @import("SingleCommand.zig");
    const Command = apis.commands.Command;

    var obj = Self.init(Command.init(&SingleCommand.init("test-name")));

    try obj.execute();
    try obj.execute();

    try testing.expectEqual(@as(u32, 2), obj.getOkCalls());
    try testing.expectEqual(@as(u32, 0), obj.getErrCalls());
    try testing.expectEqual(@as(u32, 2), obj.getTotalCalls());
}
