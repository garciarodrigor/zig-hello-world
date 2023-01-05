const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

// Hides the data structure from importing files
const point = struct {
    x: i32,
    y: i32,
};

pub const Point = opaque {
    const Self = *align(@alignOf(point)) @This();

    fn to(self: Self) *point {
        return @ptrCast(*point, self);
    }

    pub fn init(allocator: Allocator, x: i32, y: i32) !Self {
        var s: *point = try allocator.create(point);
        s.x = x;
        s.y = y;
        return @ptrCast(Self, s);
    }
    pub fn deinit(self: Self, allocator: Allocator) void {
        allocator.destroy(@ptrCast(*point, self));
    }
    pub fn getX(self: Self) i32 {
        return self.to().x;
    }
    pub fn getY(self: Self) i32 {
        return self.to().y;
    }
};

test "Point" {
    const ally = testing.allocator;
    const p = try Point.init(ally, 2, 3);
    defer p.deinit(ally);

    try testing.expectEqual(@as(i32, 2), p.getX());
    try testing.expectEqual(@as(i32, 3), p.getY());
}
