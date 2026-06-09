const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) {
        std.debug.print("Usage: {s} <arg1> <arg2> ...\n", .{args[0]});
        return;
    }

    const words = args[1..];
    var list = std.ArrayList([]const u8).empty;
    defer list.deinit(allocator);

    for (words) |word| {
        try list.append(allocator, word);
    }

    std.mem.sort([]const u8, list.items, {}, struct {
        fn lessThan(_: void, a: []const u8, b: []const u8) bool {
            return std.mem.lessThan(u8, a, b);
        }
    }.lessThan);

    std.debug.print("sorted (reverse):\n", .{});
    var i = list.items.len;
    while (i > 0) {
        i -= 1;
        std.debug.print("{s}\n", .{list.items[i]});
    }
}
