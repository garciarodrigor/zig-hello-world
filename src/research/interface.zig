const std = @import("std");

pub const Identificable = struct {
    const Self = @This();

    object: *anyopaque = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        getId: *const fn (self: *const Self) u32,
    };

    pub fn getId(self: *const Self) u32 {
        return self.vtable.getId(self);
    }

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        const vtable = struct {
            fn getId(self: *const Self) u32 {
                return from(self).getId();
            }
            inline fn from(self: *const Self) T {
                return @alignCast(@ptrCast(self.object));
            }
        };

        return Self{
            .object = @constCast(object),
            .vtable = &.{
                .getId = vtable.getId,
            },
        };
    }
};

const Human = struct {
    const Self = @This();

    id: u32,

    pub fn init(id: u32) Self {
        return .{
            .id = id,
        };
    }

    pub fn identificable(self: *const Self) Identificable {
        return Identificable.init(self);
    }

    pub fn getId(self: *const Self) u32 {
        return self.id;
    }
};

test "Human.init" {
    const testing = std.testing;

    var h = Human.init(100);
    var t = h.identificable();

    try testing.expectEqual(h.getId(), 100);
    try testing.expectEqual(h.getId(), t.getId());
}
