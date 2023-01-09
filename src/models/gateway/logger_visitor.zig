const std = @import("std");

const Resource = @import("resource.zig").Resource;
const Gateway = @import("gateway.zig").Gateway;
const Extension = @import("extension.zig").Extension;

const Self = @This();

pub fn init() Self {
    return Self{};
}

pub fn visitResource(_: *const Self, r: anytype) !void {
    std.log.info("{s}/{s}/{s}", .{ r.getKind(), r.getNamespace(), r.getNamespace() });
}

pub fn visitGateway(self: *const Self, g: *const Gateway) !void {
    self.visitResource(g);
}

pub fn visitExtension(self: *const Self, r: *const Extension) !void {
    self.visitResource(r);
}

test "models/gateway/LoggerVisitor.init" {
    const r = Resource.init("Test", "some-name", "some-namespace");
    const obj = Self.init();

    try r.accept(obj);
}
