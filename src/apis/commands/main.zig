pub const Command = struct {
    const Self = @This();

    ptr: usize = undefined,
    executeFn: *const fn (ptr: usize) anyerror!void,
    getNameFn: *const fn (ptr: usize) []const u8,

    pub fn init(pointer: anytype) Self {
        const T = @TypeOf(pointer);

        const gen = struct {
            fn execute(self: usize) anyerror!void {
                return @intToPtr(T, self).execute();
            }

            fn getName(self: usize) []const u8 {
                return @intToPtr(T, self).getName();
            }
        };

        return .{
            .ptr = @ptrToInt(pointer),
            .executeFn = gen.execute,
            .getNameFn = gen.getName,
        };
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.getNameFn(self.ptr);
    }

    pub fn execute(self: *const Self) anyerror!void {
        return self.executeFn(self.ptr);
    }
};

pub const CommandArray = []const Command;

pub const CommandError = error{
    Uninplemented,
};
