const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");
const BaseCommand = @import("base.zig");

const Self = @This();

super: BaseCommand,
cmds: apis.commands.CommandArray,
counter: u32,

pub fn init(name: []const u8, cmds: apis.commands.CommandArray) Self {
    return Self{
        .super = BaseCommand.init(name),
        .cmds = cmds,
        .counter = 0,
    };
}

pub fn getName(self: *const Self) []const u8 {
    return self.super.getName();
}

pub fn execute(self: *Self) anyerror!void {
    self.counter += 1;
    try self.cmds[self.counter % self.cmds.len].execute();
}

pub fn command(self: *Self) apis.commands.Command {
    return apis.commands.Command.init(self);
}

test "LBRRCommand.init" {
    var obj = Self.init("test-name", &.{});

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "LBRRCommand.execute" {
    const SingleCommand = @import("single.zig");
    const CallCounterCommand = @import("callcounter.zig");

    const c = SingleCommand.init("test");
    var c1 = CallCounterCommand.init(c.command());
    var c2 = CallCounterCommand.init(c.command());
    // const cmds = [_]apis.commands.Command{ c1.command(), c2.command() };

    var obj = Self.init("test-name", &.{ c1.command(), c2.command() });

    var i: u8 = 20;

    while (i > 0) {
        try obj.execute();
        i -= 1;
    }

    try testing.expectEqual(@as(u32, 10), c1.getTotalCalls());
    try testing.expectEqual(@as(u32, 10), c2.getTotalCalls());
}
