const std = @import("std");
const apis = @import("../../apis/main.zig");

const Self = @This();

pub fn init() Self {
    const self = Self{};

    return self;
}

//Implement Operator interface
pub fn operator(self: *const Self) apis.calc.Operator {
    return apis.calc.Operator.init(self);
}

pub fn eval(_: *const Self) f32 {
    return 3.141516;
}

test "init" {
    const testing = std.testing;
    const o = Self.init();

    try testing.expectEqual(@as(anyerror!f32, 3.141516), o.eval());
}
