const std = @import("std");
const cf = @import("cf");

const allocator = std.heap.page_allocator;

const CliError = error{
    MissingArguments,
};

pub fn main() !void {
    const cli = Cli.parse_args(allocator) catch |e| switch (e) {
        CliError.MissingArguments => return,
        else => return e,
    };

    var rand = std.crypto.random;

    const i = rand.intRangeLessThan(usize, 0, cli.choices.items.len);

    std.debug.print("{s}\n", .{cli.choices.items[i]});
}

pub const Cli = struct {
    choices: std.ArrayList([:0]const u8),

    pub fn parse_args(gpa: std.mem.Allocator) !Cli {
        var args = std.process.args();

        var result = Cli{
            .choices = std.ArrayList([:0]const u8).init(gpa),
        };
        errdefer result.deinit();

        const bin = args.next().?;

        while (args.next()) |arg| {
            try result.choices.append(arg);
        }

        if (result.choices.items.len == 0) {
            std.debug.print("Usage: {s} <args>\n\n", .{bin});
            std.debug.print("Args are separated by ' '\n", .{});
            return CliError.MissingArguments;
        }

        return result;
    }

    pub fn deinit(self: *Cli) void {
        self.choices.deinit();
    }
};
