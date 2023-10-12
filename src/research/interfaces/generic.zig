const std = @import("std");

const Point = struct {
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

    // Implement Shape
    pub fn getArea(_: *const Self) f32 {
        return 0;
    }
};

const Circle = struct {
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

    //Implement Shape interface
    pub fn getArea(self: *const Self) f32 {
        return PI * 2.0 * self.radio;
    }
};

fn Shape(comptime T: type) type {
    return struct {
        const Self = @This();

        obj: T,

        pub fn init(obj: T) Self {
            return Self{ .obj = obj };
        }

        pub fn getArea(self: *const Self) f32 {
            return self.obj.getArea();
        }
    };
}

test "research/interfaces/generic" {
    const testing = std.testing;
    const p = Point.init(100, 100);
    const c = Circle.init(p, 10);
    const s = Shape(Circle);

    var shapes: [1]s = undefined;
    shapes[0] = s.init(c);

    try testing.expectEqual(12, @sizeOf(s));
    try testing.expectEqual(@as(anyerror!f32, 6.28300018e+01), shapes[0].getArea());
}
