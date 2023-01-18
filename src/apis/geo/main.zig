const std = @import("std");

pub const Shape = struct {
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

        const vtable = struct {
            fn getArea(self: *const Self) f32 {
                return @intToPtr(T, self.object).getArea();
            }
        };

        return Self{
            .object = @ptrToInt(object),
            .vtable = &.{
                .getArea = vtable.getArea,
            },
        };
    }
};

test "apis/geo/Shape" {
    const testing = std.testing;

    const TestShape = struct {
        const Self = @This();

        pub fn init() Self {
            return Self{};
        }

        pub fn getArea(_: *const Self) f32 {
            return 999;
        }

        pub fn shape(self: *const Self) Shape {
            return Shape.init(self);
        }
    };

    const o = TestShape.init();

    try testing.expectEqual(@as(f32, 999), o.shape().getArea());
    try testing.expectEqual(o.getArea(), o.shape().getArea());
}
