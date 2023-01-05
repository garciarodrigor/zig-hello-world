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
