const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const file_contents = try std.fs.cwd().readFileAlloc(allocator, "example.txt", 1024 * 1024);
    defer allocator.free(file_contents);
    var it = std.mem.splitSequence(u8, file_contents, "\n");
    var arr1 = std.ArrayList(std.ArrayList(isize)).init(allocator);
    defer {
        for (arr1.items) |*def| {
            def.deinit();
        }
        arr1.deinit();
    }
    var c: usize = 0;
    while (it.next()) |x| : (c += 1) {
        var it2 = std.mem.splitSequence(u8, x, " ");
        while (it2.next()) |x2| {
            if (x2.len > 0) {
                try arr1.append(std.ArrayList(isize).init(allocator));
                try arr1.items[c].append(try std.fmt.parseInt(isize, x2, 10));
            }
        }
    }
    var k: usize = 0;
    for (arr1.items) |*def| {
        var z: usize = 0;
        var y: usize = 0;
        var prev: ?isize = null;
        for (def.items) |x| {
            if (prev != null) {
                if (((x - prev.?) < 4) and ((x - prev.?) >= 1)) {
                    z += 1;
                }
                if (((prev.? - x) < 4) and ((prev.? - x) >= 1)) {
                    y += 1;
                }
            }
            prev = x;
        }
        if ((def.items.len - z == 1) or def.items.len - y == 1) {
            k += 1;
        }
    }
    print("{}\n", .{k});
}
