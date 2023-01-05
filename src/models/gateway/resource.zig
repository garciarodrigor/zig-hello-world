const std = @import("std");
const testing = std.testing;

// type Resource interface {
// 	GetKind() String
// 	GetName() String
// 	GetNamespace() String
// 	GetLabels() LabelsMap
// 	GetLabel(name String) Label

// 	Match(resource Resource) Boolean
// }

// type ResourceVisitor interface {
// 	VisitResource(resource Resource)
// }

pub const Resource = struct {
    const Self = @This();

    kind: []const u8,
    name: []const u8,
    namespace: []const u8,

    pub fn init(kind: []const u8, name: []const u8, namespace: []const u8) Self {
        return Self{
            .kind = kind,
            .name = name,
            .namespace = namespace,
        };
    }

    pub fn getKind(self: *const Self) []const u8 {
        return self.kind;
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.name;
    }

    pub fn getNamespace(self: *const Self) []const u8 {
        return self.namespace;
    }

    pub fn accept(self: *const Self, visitor: anytype) anyerror!void {
        try visitor.visitResource(self);
    }
};

test "models/gateway/Resource.init" {
    const obj = Resource.init("Test", "some-name", "some-namespace");

    try testing.expectEqual(@as([]const u8, "Test"), obj.getKind());
    try testing.expectEqual(@as([]const u8, "some-name"), obj.getName());
    try testing.expectEqual(@as([]const u8, "some-namespace"), obj.getNamespace());
}

test "models/gateway/Resource.accept" {
    const TestVisitor = struct {
        const Self = @This();
        fn init() Self {
            return Self{};
        }

        fn visitResource(_: *const Self, r: *const Resource) !void {
            try testing.expectEqual(@as([]const u8, "Test"), r.getKind());
            try testing.expectEqual(@as([]const u8, "some-name"), r.getName());
            try testing.expectEqual(@as([]const u8, "some-namespace"), r.getNamespace());
        }
    };

    const obj = Resource.init("Test", "some-name", "some-namespace");

    try obj.accept(TestVisitor.init());
}
