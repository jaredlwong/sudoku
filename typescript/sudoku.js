"use strict";
exports.__esModule = true;
var fs = require("fs");
function string_to_puzzle(input) {
    return input.split('').map(function (c) { return c === '.' ? 0 : parseInt(c, 10); });
}
function puzzle_to_string(puzzle) {
    return puzzle.map(function (e) { return e === 0 ? '.' : e.toString(); }).join('');
}
function is_valid_row(row) {
    var checkset = new Array(10).fill(0);
    for (var _i = 0, row_1 = row; _i < row_1.length; _i++) {
        var e = row_1[_i];
        checkset[e] += 1;
    }
    return checkset.slice(1).every(function (e) { return e <= 1; });
}
function is_valid(grid) {
    for (var r = 0; r < 9; r++) {
        var row = grid.slice(r * 9, r * 9 + 9);
        if (!is_valid_row(row)) {
            return false;
        }
    }
    for (var c = 0; c < 9; c++) {
        var col = [];
        for (var r = 0; r < 9; r++) {
            col.push(grid[r * 9 + c]);
        }
        if (!is_valid_row(col)) {
            return false;
        }
    }
    for (var i = 0; i < 9; i++) {
        var box_row = Math.floor(i / 3);
        var box_col = i % 3;
        var box = [];
        for (var r = box_row * 3; r < box_row * 3 + 3; r++) {
            for (var c = box_col * 3; c < box_col * 3 + 3; c++) {
                box.push(grid[r * 9 + c]);
            }
        }
        if (!is_valid_row(box)) {
            return false;
        }
    }
    return true;
}
function next_open(grid) {
    for (var i = 0; i < 81; i++) {
        if (grid[i] === 0) {
            return i;
        }
    }
    return -1;
}
function solve(grid) {
    if (!is_valid(grid)) {
        return;
    }
    var p = next_open(grid);
    if (p < 0) {
        return grid;
    }
    for (var v = 1; v <= 9; v++) {
        grid[p] = v;
        var result = solve(grid);
        if (result) {
            return result;
        }
        grid[p] = 0;
    }
    return;
}
function main() {
    if (process.argv.length < 2) {
        console.log("Please provide the name of an input file as an argument.");
        process.exit(1);
    }
    // Get the filename from the first command line argument
    var filename = process.argv[2];
    // Read the file line by line
    var lines = fs.readFileSync(filename, 'utf8')
        .split('\n')
        .map(function (e) { return e.trim(); })
        .filter(function (e) { return e.length > 0; });
    // Print each line
    for (var i = 0; i < lines.length; i += 2) {
        var input = lines[i];
        var expected = lines[i + 1];
        var start = performance.now();
        var puzzle = string_to_puzzle(input);
        solve(puzzle);
        var output = puzzle_to_string(puzzle);
        var end = performance.now();
        var duration = end - start;
        if (expected === output) {
            console.log("Solved sudoku ".concat(input, " in ").concat(duration, " ms"));
        }
        else {
            console.log("Failed to solve sudoku ".concat(input, ". Expected ").concat(expected, ", got ").concat(output, "s"));
        }
    }
}
if (require.main === module) {
    main();
}
