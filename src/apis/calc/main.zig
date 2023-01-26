const std = @import("std");

pub const Operator = struct {
    const Self = @This();

    object: usize = undefined,
    vtable: *const VTable = undefined,

    const VTable = struct {
        eval: *const fn (self: *const Self) f32,
    };

    pub fn eval(self: *const Self) f32 {
        return self.vtable.eval(self);
    }

    pub fn init(object: anytype) Self {
        const T = @TypeOf(object);

        const vtable = struct {
            fn eval(self: *const Self) f32 {
                return @intToPtr(T, self.object).eval();
            }
        };

        return Self{
            .object = @ptrToInt(object),
            .vtable = &.{
                .eval = vtable.eval,
            },
        };
    }
};

test "apis/calc/Operator" {
    const testing = std.testing;

    const TestOperator = struct {
        const Self = @This();

        value: f32 = undefined,

        pub fn init(value: f32) Self {
            return Self{
                .value = value,
            };
        }

        pub fn eval(self: *const Self) f32 {
            return self.value;
        }

        pub fn operator(self: *const Self) Operator {
            return Operator.init(self);
        }
    };

    const o = TestOperator.init(3.14);

    try testing.expectEqual(@as(f32, 3.14), o.operator().eval());
    try testing.expectEqual(o.eval(), o.operator().eval());
}
