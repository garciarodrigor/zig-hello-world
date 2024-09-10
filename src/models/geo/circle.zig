const std = @import("std");
const Point = @import("Point.zig");

const PI: f32 = 3.1415;

const Self = @This();

center: Point,
radio: f32,

pub fn init(center: Point, radio: f32) Self {
    const self = Self{
        .center = center,
        .radio = radio,
    };

    return self;
}

pub fn getCenter(self: *const Self) *const Point {
    return &self.center;
}

pub fn getRadio(self: *const Self) f32 {
    return self.radio;
}

//Implement Shape interface
pub fn getArea(self: *const Self) f32 {
    return PI * 2.0 * self.radio;
}

test "init" {
    const testing = std.testing;
    const p = Point.init(100, 100);
    const c = Self.init(p, 10);

    try testing.expectEqual(c.getRadio(), 10);
    try testing.expectEqual(c.getCenter().getX(), p.getX());
    try testing.expectEqual(@as(anyerror!f32, 6.28300018e+01), c.getArea());
}
