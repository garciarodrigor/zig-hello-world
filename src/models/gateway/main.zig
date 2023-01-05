const std = @import("std");

pub const Resource = @import("resource.zig").Resource;
pub const Extension = @import("extension.zig").Extension;
pub const Gateway = @import("gateway.zig").Gateway;

test "models/gateway" {
    std.testing.refAllDecls(@This());
}
