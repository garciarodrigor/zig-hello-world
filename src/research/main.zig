const std = @import("std");

test "all" {
    _ = @import("interface.zig");
    _ = @import("private-struct.zig");
    _ = @import("interfaces/main.zig");
}
