const std = @import("std");

pub const BaseCommand = @import("base.zig");
pub const SingleCommand = @import("single.zig");
// pub const MultiCommand = @import("multi.zig");
pub const ErrorCommand = @import("error.zig");
pub const CallCounterCommand = @import("callcounter.zig");
// pub const LBRRCommand = @import("lbrr.zig");

test "all" {
    std.testing.refAllDecls(@This());
}
