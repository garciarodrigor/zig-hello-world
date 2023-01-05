const std = @import("std");

pub const commands = @import("commands/main.zig");

test "apis" {
    std.testing.refAllDecls(@This());
}
