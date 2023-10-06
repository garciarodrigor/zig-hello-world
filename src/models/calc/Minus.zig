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
    return self.in1.eval() - self.in2.eval();
}

test "models/calc/Minus.init" {
    const testing = std.testing;
    const Value = @import("Value.zig");

    const x = Value.init(10).operator();
    const y = Value.init(5).operator();

    const o = Self.init(x, y);
    try testing.expectEqual(@as(anyerror!f32, 5), o.eval());
}
