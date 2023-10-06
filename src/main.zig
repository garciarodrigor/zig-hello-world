const std = @import("std");
const models = @import("models/main.zig");
const apis = @import("apis/main.zig");

const Talker = struct {
    pub fn talk(s: anytype) void {
        s.talk();
    }
};

const Animal = struct {
    const Self = @This();

    name: []const u8,

    pub fn init(name: []const u8) Self {
        return Self{
            .name = name,
        };
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.name;
    }

    pub fn talk(self: *const Self) void {
        std.debug.print("I'm an Animal\n", .{self.super.getName()});
    }
};

const Cat = struct {
    const Self = @This();

    super: Animal,

    pub fn init(name: []const u8) Self {
        return Self{
            .super = Animal.init(name),
        };
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.super.getName();
    }

    pub fn talk(self: *const Self) void {
        std.debug.print("I'm {s} the Cat\n", .{self.getName()});
    }
};

const Human = struct {
    const Self = @This();

    super: Animal,

    pub fn init(name: []const u8) Self {
        return Self{
            .super = Animal.init(name),
        };
    }

    pub fn talk(self: *const Self) void {
        std.debug.print("Hi, I'm {s} and I'm a Human\n", .{self.super.name});
    }
};

pub fn main() anyerror!void {
    var p1 = models.geo.Point.init(100, 100);
    var p2 = models.geo.Point.init(200, 200);

    var r = models.geo.Rectangle.init(p1, p2);
    var c = models.geo.Circle.init(p1, 100);

    var h = Human.init("Rodrigo");
    var cat = Cat.init("Rocky");

    const col = .{ h, cat };

    inline for (col) |value| {
        Talker.talk(value);
    }

    var shapes: [2]apis.geo.Shape = undefined;
    shapes[0] = apis.geo.Shape.init(&c);
    shapes[1] = apis.geo.Shape.init(&r);

    std.log.info("{any} area={d} {any} area={d}\n", .{ shapes[1], shapes[1].getArea(), r, r.getArea() });
}

test "main" {
    _ = @import("models/main.zig");
}
