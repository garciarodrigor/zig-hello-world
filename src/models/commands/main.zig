const std = @import("std");

pub const BaseCommand = @import("BaseCommand.zig");
pub const SingleCommand = @import("SingleCommand.zig");
// pub const MultiCommand = @import("multi.zig");
pub const ErrorCommand = @import("ErrorCommand.zig");
pub const CallCounterCommand = @import("CallCounterCommand.zig");
// pub const LBRRCommand = @import("lbrr.zig");

test "all" {
    std.testing.refAllDecls(@This());
}
