const std = @import("std");

pub const Resource = @import("resource.zig").Resource;
pub const Extension = @import("extension.zig").Extension;
pub const Gateway = @import("gateway.zig").Gateway;
pub const LoggerVisitor = @import("logger_visitor.zig");

test "models/gateway" {
    std.testing.refAllDecls(@This());
}
