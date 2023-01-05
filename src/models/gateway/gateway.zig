const std = @import("std");
const testing = std.testing;

const Resource = @import("resource.zig").Resource;
const extension = @import("extension.zig");

// type Gateway interface {
// 	Resource
// 	AddExtension(e Extension) Gateway
// 	GetExtensions() ExtensionArray
// 	GetExtension(q Resource) (Extension, Boolean)

// 	AddAPIInstance(api APIInstance) Gateway
// 	GetAPIInstances() APIInstanceArray
// 	GetAPIInstance(q Resource) (APIInstance, Boolean)

// 	AddService(service Service) Gateway
// 	GetServices() ServiceArray
// 	GetService(q Resource) (Service, Boolean)

// 	AddSecret(s Secret) Gateway
// 	GetSecrets() SecretArray
// 	GetSecret(q Resource) (Secret, Boolean)

// 	AddConfiguration(configuration.ConfigurationChange)
// 	GetConfiguration() configuration.Configuration

// 	Accept(visitor GatewayVisitor)
// }
pub const Gateway = struct {
    const Self = @This();

    extensions: extension.ExtensionArray,
    resource: Resource,

    pub fn init(name: []const u8, namespace: []const u8, extensions: extension.ExtensionArray) Self {
        return Self{
            .resource = Resource.init("Gateway", name, namespace),
            .extensions = extensions,
        };
    }

    pub fn getKind(self: *const Self) []const u8 {
        return self.resource.getKind();
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.resource.getName();
    }

    pub fn getNamespace(self: *const Self) []const u8 {
        return self.resource.getNamespace();
    }

    pub fn getExtentions(self: *const Self) extension.ExtensionArray {
        self.extensions;
    }

    pub fn accept(self: *const Self, visitor: anytype) !void {
        try visitor.visitGateway(self);

        for (self.extensions) |item| {
            try item.accept(visitor);
        }
    }
};

test "models/gateway/Gateway.accept" {
    const TestVisitor = struct {
        const Self = @This();
        fn init() Self {
            return Self{};
        }

        fn visitGateway(_: *const Self, g: *const Gateway) !void {
            try testing.expectEqual(@as([]const u8, "Gateway"), g.getKind());
            try testing.expectEqual(@as([]const u8, "some-name"), g.getName());
            try testing.expectEqual(@as([]const u8, "some-namespace"), g.getNamespace());
        }

        pub fn visitExtension(_: *const Self, r: *const extension.Extension) !void {
            try testing.expectEqual(@as([]const u8, "Extension"), r.getKind());
            try testing.expectEqual(@as([]const u8, "some-ext"), r.getName());
            try testing.expectEqual(@as([]const u8, "some-namespace"), r.getNamespace());
        }
    };

    const obj = Gateway.init("some-name", "some-namespace", &.{
        extension.Extension.init("some-ext", "some-namespace", &.{}),
    });

    try obj.accept(&TestVisitor.init());
}
