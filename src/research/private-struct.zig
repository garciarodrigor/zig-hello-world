const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

// Hides the data structure from importing files
const point = struct {
    allocator: Allocator,
    x: i32,
    y: i32,
};

pub const Point = opaque {
    const Self = *align(@alignOf(point)) @This();

    fn self(p: Self) *point {
        return @ptrCast(*point, p);
    }

    pub fn init(allocator: Allocator, x: i32, y: i32) !Self {
        var s: *point = try allocator.create(point);

        s.allocator = allocator;
        s.x = x;
        s.y = y;

        return @ptrCast(Self, s);
    }

    pub fn deinit(p: Self) void {
        p.self().allocator.destroy(@ptrCast(*point, p));
    }

    pub fn setX(p: Self, x: i32) void {
        p.self().x = x;
    }

    pub fn getX(p: Self) i32 {
        return p.self().x;
    }

    pub fn setY(p: Self, y: i32) void {
        p.self().y = y;
    }

    pub fn getY(p: Self) i32 {
        return p.self().y;
    }
};

test "Point" {
    const ally = testing.allocator;
    const p = try Point.init(ally, 2, 3);
    defer p.deinit();

    try testing.expectEqual(@as(i32, 2), p.getX());
    try testing.expectEqual(@as(i32, 3), p.getY());
}
