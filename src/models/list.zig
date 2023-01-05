const std = @import("std");

pub fn List(comptime T: type) type {
    return struct {
        const Self = @This();

        items: []T,

        pub fn init(items: []T) Self {
            return Self{
                .items = items,
            };
        }

        pub fn length(self: Self) usize {
            return self.items.len;
        }

        pub fn get(self: Self, idx: usize) T {
            return self.items[idx];
        }
    };
}

test "models/List.length" {
    const testing = std.testing;

    var items = [_]i32{ 1, 2, 3, 4 };
    var obj = List(i32).init(items[0..]);

    try testing.expectEqual(@as(usize, 4), obj.length());
    try testing.expectEqual(@as(i32, 3), obj.get(2));
}
