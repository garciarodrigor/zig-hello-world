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

const Shape = struct {
    const Self = @This();

    object: *anyopaque = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        getArea: *const fn (self: *const Self) f32,
    };

    pub fn getArea(self: *const Self) f32 {
        return self.vtable.getArea(self);
    }

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        const vtable = struct {
            fn getArea(self: *const Self) f32 {
                return from(self).getArea();
            }

            fn from(self: *const Self) T {
                return @alignCast(@ptrCast(self.object));
            }
        };

        return Self{
            .object = @constCast(object),
            .vtable = &.{
                .getArea = vtable.getArea,
            },
        };
    }
};

test "ducktype" {
    const testing = std.testing;
    const p = Point.init(100, 100);
    const c = Circle.init(p, 10);

    var shapes: [2]Shape = undefined;
    shapes[0] = Shape.init(&p);
    shapes[1] = Shape.init(&c);

    try testing.expectEqual(8, @sizeOf(Point));
    try testing.expectEqual(12, @sizeOf(Circle));
    try testing.expectEqual(16, @sizeOf(Shape));
    try testing.expectEqual(@as(anyerror!f32, 0), shapes[0].getArea());
    try testing.expectEqual(@as(anyerror!f32, 6.28300018e+01), shapes[1].getArea());
}
