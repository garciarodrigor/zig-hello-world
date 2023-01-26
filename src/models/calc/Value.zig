const std = @import("std");
const apis = @import("../../apis/main.zig");

const Self = @This();

value: f32,

pub fn init(value: f32) Self {
    const self = Self{
        .value = value,
    };

    return self;
}

//Implement Operator interface
pub fn operator(self: *const Self) apis.calc.Operator {
    return apis.calc.Operator.init(self);
}

pub fn eval(self: *const Self) f32 {
    return self.value;
}

test "models/calc/Value.init" {
    const testing = std.testing;
    const o = Self.init(10);
    try testing.expectEqual(@as(anyerror!f32, 10), o.eval());
}
