const std = @import("std");

pub const Point = @import("point.zig").Point;
pub const Circle = @import("circle.zig").Circle;
pub const Rectangle = @import("rectangle.zig").Rectangle;
pub const Shape = @import("shape.zig").Shape;
pub const ShapeV2 = @import("shape.zig").ShapeV2;
pub const ShapeV3 = @import("shape.zig").ShapeV3;

test "models/geo" {
    std.testing.refAllDecls(@This());
}
