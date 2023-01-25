const std = @import("std");

const Self = @This();

x: i32,
y: i32,

pub fn init(x: i32, y: i32) Self {
    return Self{
        .x = x,
        .y = y,
    };
}

pub fn getX(self: *const Self) i32 {
    return self.x;
}

pub fn getY(self: *const Self) i32 {
    return self.y;
}

test "models/geo/Point.init" {
    const testing = std.testing;

    var p = Self.init(100, 200);

    try testing.expectEqual(@as(i32, 100), p.getX());
    try testing.expectEqual(@as(i32, 200), p.getY());
}
