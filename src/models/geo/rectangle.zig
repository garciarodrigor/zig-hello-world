const std = @import("std");
const Point = @import("Point.zig");

const Self = @This();

p1: Point,
p2: Point,

pub fn init(p1: Point, p2: Point) Self {
    return Self{
        .p1 = p1,
        .p2 = p2,
    };
}

pub fn getP1(self: *const Self) *const Point {
    return &self.p1;
}

pub fn getP2(self: *const Self) *const Point {
    return &self.p2;
}

// Implement Shape interface
pub fn getArea(self: *const Self) f32 {
    return @floatFromInt((self.p2.getX() - self.p1.getX()) * (self.p2.getY() - self.p1.getY()));
}

// Rectangle Tests
test "init" {
    const testing = std.testing;

    const p1 = Point.init(100, 200);
    const p2 = Point.init(200, 300);
    const r = Self.init(p1, p2);

    try testing.expectEqual(r.getP1().getX(), 100);
    try testing.expectEqual(r.getArea(), 10000);
}
