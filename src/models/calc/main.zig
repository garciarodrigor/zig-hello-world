const std = @import("std");

pub const Value = @import("Value.zig");
pub const Plus = @import("Plus.zig");
pub const Minus = @import("Minus.zig");
pub const Multiply = @import("Multiply.zig");

test "models/calc" {
    std.testing.refAllDecls(@This());
}
