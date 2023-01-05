const std = @import("std");
const testing = std.testing;

const apis = @import("../../apis/main.zig");
const BaseCommand = @import("base.zig").BaseCommand;
const ErrorCommand = @import("error.zig").ErrorCommand;

pub const MultiCommand = struct {
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
};

test "models/commands/MultiCommand.init" {
    const cmds: [0]apis.commands.Command = undefined;
    const obj = MultiCommand.init("test-name", &cmds);

    try testing.expectEqual(@as([]const u8, "test-name"), obj.getName());
}

test "models/commands/MultiCommand.execute" {
    const TestError = error{
        ChildError,
    };

    const bc = ErrorCommand.init("test-child", TestError.ChildError);
    const cmds = [_]apis.commands.Command{bc.command()};

    const obj = MultiCommand.init("test-name", &cmds);

    try testing.expectError(TestError.ChildError, obj.execute());
}
