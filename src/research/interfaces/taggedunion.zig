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

const Rectangle = struct {
    const Self = @This();

    p1: Point,
    p2: Point,

    pub fn init(p1: Point, p2: Point) Self {
        return Self{
            .p1 = p1,
            .p2 = p2,
        };
    }

    // Implement Shape interface
    pub fn getArea(self: *const Self) f32 {
        return @intToFloat(f32, (self.p2.getX() - self.p1.getX()) * (self.p2.getY() - self.p1.getY()));
    }
};

const Shape = union(enum) {
    const Self = @This();

    point: Point,
    circle: Circle,
    rectangle: Rectangle,

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        switch (T) {
            Point => return Self{ .point = object },
            Circle => return Self{ .circle = object },
            Rectangle => return Self{ .rectangle = object },
            else => @compileError("Unsuported type"),
        }
    }

    pub fn getArea(self: *const Self) f32 {
        switch (self.*) {
            inline else => |*case| return case.getArea(),
        }
    }
};

test "research/interfaces/taggedunion" {
    const testing = std.testing;
    const p = Point.init(100, 100);
    const c = Circle.init(p, 10);

    var shapes: [2]Shape = undefined;
    shapes[0] = Shape.init(p);
    shapes[1] = Shape.init(c);

    try testing.expectEqual(20, @sizeOf(Shape));
    try testing.expectEqual(@as(anyerror!f32, 0), shapes[0].getArea());
    try testing.expectEqual(@as(anyerror!f32, 6.28300018e+01), shapes[1].getArea());
}
