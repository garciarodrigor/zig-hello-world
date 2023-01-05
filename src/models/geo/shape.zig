const std = @import("std");

const Point = @import("point.zig").Point;
const Rectangle = @import("rectangle.zig").Rectangle;
const Circle = @import("circle.zig").Circle;

// Usage: Shape(Circle).init(obj)
pub fn Shape(comptime T: type) type {
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

pub const ShapeV2 = struct {
    const Self = @This();

    object: usize = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        getArea: *const fn (self: *const Self) f32,
    };

    pub fn getArea(self: *const Self) f32 {
        return self.vtable.getArea(self);
    }

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        return Self{
            .object = @ptrToInt(object),
            .vtable = &.{
                .getArea = struct {
                    fn getArea(self: *const Self) f32 {
                        return @intToPtr(T, self.object).getArea();
                    }
                }.getArea,
            },
        };
    }
};

pub const ShapeV3 = struct {
    const Self = @This();

    ptr: usize = undefined,
    getAreaFn: *const fn (ptr: usize) f32,

    pub fn init(pointer: anytype) Self {
        const T = @TypeOf(pointer);

        const gen = struct {
            fn getArea(ptr: usize) f32 {
                return @intToPtr(T, ptr).getArea();
            }
        };

        return .{
            .ptr = @ptrToInt(pointer),
            .getAreaFn = gen.getArea,
        };
    }

    pub fn getArea(r: Self) f32 {
        return r.getAreaFn(r.ptr);
    }
};

test "models/geo/Shape" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const s = Shape(Rectangle).init(r);

    try testing.expectEqual(s.getArea(), r.getArea());
}

test "models/geo/ShapeV2" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const s = ShapeV2.init(&r);

    try testing.expectEqual(s.getArea(), r.getArea());
}

test "models/geo/ShapeV3" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const s = ShapeV3.init(&r);

    try testing.expectEqual(s.getArea(), r.getArea());
}
