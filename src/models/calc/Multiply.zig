const std = @import("std");

const apis = @import("../../apis/main.zig");

const Self = @This();

in1: apis.calc.Operator,
in2: apis.calc.Operator,

pub fn init(in1: apis.calc.Operator, in2: apis.calc.Operator) Self {
    const self = Self{
        .in1 = in1,
        .in2 = in2,
    };

    return self;
}

//Implement Operator interface
pub fn operator(self: *const Self) apis.calc.Operator {
    return apis.calc.Operator.init(self);
}

pub fn eval(self: *const Self) f32 {
    return self.in1.eval() * self.in2.eval();
}

test "init" {
    const testing = std.testing;
    const Value = @import("Value.zig");
    const Minus = @import("Minus.zig");

    const a = Value.init(10).operator();
    const b = Value.init(5).operator();
    const ab = Minus.init(a, b).operator();

    const o = Self.init(ab, b);
    try testing.expectEqual(@as(anyerror!f32, 25), o.eval());
}
