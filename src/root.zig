//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
pub fn main() void {
    std.debug.print("Hello world\n", .{});
}
