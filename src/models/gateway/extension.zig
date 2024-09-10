const std = @import("std");
const testing = std.testing;

const Resource = @import("resource.zig").Resource;

// type Extension interface {
// 	Resource
// 	GetExtends() ExtensionArray
// 	GetProperty(name string) PropertyType
// 	HasProperty(name string) Boolean
// 	InstanceOf(namespace, extensionName string) Boolean
// 	ValidateWithPolicy(policy Policy) Error
// 	Validate() Error
// 	ValidateTarget(target PolicyTargetable) Error
// 	Accept(visitor ExtensionVisitor)
// }
pub const Extension = struct {
    const Self = @This();

    extends: ExtensionArray,
    resource: Resource,

    pub fn init(name: []const u8, namespace: []const u8, extends: ExtensionArray) Self {
        return Self{
            .resource = Resource.init("Extension", name, namespace),
            .extends = extends,
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

    pub fn getExtends(self: *const Self) ExtensionArray {
        self.extends;
    }

    pub fn accept(self: *const Self, visitor: anytype) !void {
        try visitor.visitExtension(self);

        for (self.extends) |item| {
            try item.accept(visitor);
        }
    }
};

pub const ExtensionArray = []const Extension;

test "Extension.accept" {
    const TestVisitor = struct {
        const Self = @This();
        fn init() Self {
            return Self{};
        }

        fn visitExtension(_: *const Self, r: *const Extension) !void {
            try testing.expectEqual(@as([]const u8, "Extension"), r.getKind());
            try testing.expectEqual(@as([]const u8, "some-name"), r.getName());
            try testing.expectEqual(@as([]const u8, "some-namespace"), r.getNamespace());
        }
    };

    const obj = Extension.init("some-name", "some-namespace", &.{});

    try obj.accept(&TestVisitor.init());
}

test "Extension.accept/withExtends" {
    const TestVisitor = struct {
        const Self = @This();
        const calls = [_][]const u8{ "some-name", "ext1", "ext2" };

        idx: u8 = 0,

        fn init() Self {
            return Self{};
        }

        fn visitExtension(self: *Self, r: *const Extension) !void {
            try testing.expectEqual(@as([]const u8, "Extension"), r.getKind());
            try testing.expectEqual(@as([]const u8, "some-namespace"), r.getNamespace());
            try testing.expectEqual(@as([]const u8, calls[self.idx]), r.getName());
            self.idx += 1;
        }
    };

    const obj = Extension.init("some-name", "some-namespace", &.{
        Extension.init("ext1", "some-namespace", &.{}),
        Extension.init("ext2", "some-namespace", &.{}),
    });

    var visitor = TestVisitor.init();

    try obj.accept(&visitor);
}
