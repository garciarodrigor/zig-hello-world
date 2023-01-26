const std = @import("std");

pub const commands = @import("commands/main.zig");
pub const geo = @import("geo/main.zig");
pub const calc = @import("calc/main.zig");

test "apis" {
    std.testing.refAllDecls(@This());
}
