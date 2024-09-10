const std = @import("std");

pub const Point = @import("Point.zig");
pub const Circle = @import("Circle.zig");
pub const Rectangle = @import("rectangle.zig");
pub const Shape = @import("shape.zig").Shape;
// pub const ShapeV2 = @import("shape.zig").ShapeV2;
// pub const ShapeV3 = @import("shape.zig").ShapeV3;

test "all" {
    std.testing.refAllDecls(@This());
}
