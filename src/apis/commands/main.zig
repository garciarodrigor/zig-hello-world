const std = @import("std");

pub const Command = struct {
    const Self = @This();

    object: *anyopaque = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        execute: *const fn (self: *const Self) anyerror!void,
        getName: *const fn (self: *const Self) []const u8,
    };

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        const gen = struct {
            fn execute(self: *const Self) anyerror!void {
                return from(self).execute();
            }

            fn getName(self: *const Self) []const u8 {
                return from(self).getName();
            }

            fn from(self: *const Self) T {
                return @ptrCast(@alignCast(self.object));
            }
        };

        return .{
            .object = @constCast(object),
            .vtable = &.{
                .execute = gen.execute,
                .getName = gen.getName,
            },
        };
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.vtable.getName(self);
    }

    pub fn execute(self: *const Self) anyerror!void {
        return self.vtable.execute(self);
    }
};

pub const CommandArray = []const Command;

pub const CommandError = error{
    Uninplemented,
};

test "Command" {
    const testing = std.testing;

    const TestCommand = struct {
        const Self = @This();

        name: []const u8,
        counter: u32,

        pub fn init(name: []const u8) Self {
            return Self{
                .name = name,
                .counter = 0,
            };
        }

        pub fn execute(self: *Self) anyerror!void {
            self.counter += 1;
            return;
        }

        pub fn getName(self: *const Self) []const u8 {
            return self.name;
        }

        pub fn getCounter(self: *const Self) u32 {
            return self.counter;
        }
    };

    var o = TestCommand.init("test");
    const c = Command.init(&o);

    try c.execute();
    try o.execute();

    try testing.expectEqual(o.getName(), c.getName());
    try testing.expectEqual(2, o.getCounter());
}
