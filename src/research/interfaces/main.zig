const std = @import("std");

test "all" {
    _ = @import("ducktype.zig");
    _ = @import("generic.zig");
    _ = @import("taggedunion.zig");
    _ = @import("vtable.zig");
    _ = @import("fatpointer.zig");
}
