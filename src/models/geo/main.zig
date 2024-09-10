const std = @import("std");

pub const Point = @import("Point.zig");
pub const Circle = @import("Circle.zig");
pub const Rectangle = @import("Rectangle.zig");

test "all" {
    std.testing.refAllDecls(@This());
}
