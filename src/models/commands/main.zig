const std = @import("std");

pub const BaseCommand = @import("base.zig").BaseCommand;
pub const SingleCommand = @import("single.zig").SingleCommand;
pub const MultiCommand = @import("multi.zig").MultiCommand;
pub const ErrorCommand = @import("error.zig").ErrorCommand;
pub const CallCounterCommand = @import("callcounter.zig").CallCounterCommand;
pub const LBRRCommand = @import("lbrr.zig").LBRRCommand;

test "models/commands" {
    std.testing.refAllDecls(@This());
}
