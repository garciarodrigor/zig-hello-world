const std = @import("std");

const Point = @import("Point.zig");
const Rectangle = @import("Rectangle.zig");
const Circle = @import("Circle.zig");

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

    object: *const anyopaque = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        getArea: *const fn (self: *const Self) f32,
    };

    pub fn getArea(self: *const Self) f32 {
        return self.vtable.getArea(self);
    }

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        const gen = struct {
            fn getArea(self: *const Self) f32 {
                return from(self).getArea();
            }

            fn from(self: *const Self) T {
                return @alignCast(@ptrCast(self.object));
            }
        };

        return Self{
            .object = object,
            .vtable = &.{
                .getArea = gen.getArea,
            },
        };
    }
};

pub const ShapeV3 = struct {
    const Self = @This();

    ptr: *const anyopaque,
    getAreaFn: *const fn (self: *const Self) f32,

    pub fn init(pointer: anytype) Self {
        const T = @TypeOf(pointer);

        const gen = struct {
            fn getArea(self: *const Self) f32 {
                return from(self).getArea();
            }

            inline fn from(self: *const Self) T {
                return @alignCast(@ptrCast(self.ptr));
            }
        };

        return .{
            .ptr = pointer,
            .getAreaFn = gen.getArea,
        };
    }

    pub fn getArea(self: *const Self) f32 {
        return self.getAreaFn(self);
    }
};

test "Shape" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const s = Shape(Rectangle).init(r);

    try testing.expectEqual(s.getArea(), r.getArea());
}

test "ShapeV2" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const sr = ShapeV2.init(&r);

    const c = Circle.init(p1, 10.0);
    const sc = ShapeV2.init(&c);

    try testing.expectEqual(sr.getArea(), r.getArea());
    try testing.expectEqual(sc.getArea(), c.getArea());
}

test "ShapeV3" {
    const testing = std.testing;

    const p1 = Point.init(100, 100);
    const p2 = Point.init(200, 200);
    const r = Rectangle.init(p1, p2);
    const s = ShapeV3.init(&r);

    try testing.expectEqual(s.getArea(), r.getArea());
}
