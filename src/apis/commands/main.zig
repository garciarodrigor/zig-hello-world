const std = @import("std");

pub const Command = struct {
    const Self = @This();

    object: *const anyopaque = undefined,
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
                return @alignCast(@ptrCast(self.object));
            }
        };

        return .{
            .object = object,
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

        pub fn init(name: []const u8) Self {
            return Self{
                .name = name,
            };
        }

        pub fn execute(_: *const Self) anyerror!void {
            return;
        }

        pub fn getName(self: *const Self) []const u8 {
            return self.name;
        }
    };

    const o = TestCommand.init("test");
    const c = Command.init(&o);

    try testing.expectEqual(o.getName(), c.getName());
}
