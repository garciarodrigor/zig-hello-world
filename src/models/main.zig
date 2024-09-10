const std = @import("std");

pub const calc = @import("calc/main.zig");
pub const commands = @import("commands/main.zig");
pub const geo = @import("geo/main.zig");
pub const gateway = @import("gateway/main.zig");
pub const list = @import("list.zig");

test "all" {
    std.testing.refAllDecls(@This());
}
