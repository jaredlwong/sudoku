const std = @import("std");

pub fn parse_sudoku(str_rep: []const u8, sudoku: []u8) void {
    for (str_rep) |i, c| {
        if (c == '.') {
            sudoku[i] = 0;
        } else {
            sudoku[i] = @truncate(u8, c - '0');
        }
    }
}

pub fn main() anyerror!void {
    // Parse the filename argument
    var args = std.process.args();
    if (!args.skip()) return;
    var filename: []const u8 = args.next() orelse @panic("Please specify a filename\n");

    // Open the file
    var f = try std.fs.cwd().openFile(filename, .{});
    defer f.close();

    var buf_reader = std.io.bufferedReader(f.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var sudoku: [81]u8 = undefined;
        parse_sudoku(line, &sudoku);
        std.log.info("Lines: {s}", .{sudoku});
    }
}
