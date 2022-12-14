const fs = require('fs');

function string_to_puzzle(input) {
    return input.split('').map((c) => c === '.' ? 0 : parseInt(c, 10));
}

function puzzle_to_string(puzzle) {
    return puzzle.map((e) => e === 0 ? '.' : e.toString()).join('');
}

function is_valid_row(row) {
    const checkset = new Array(10).fill(0);
    for (const e of row) {
        checkset[e] += 1;
    }
    return checkset.slice(1).every((e) => e <= 1);
}

function is_valid(grid) {
    for (let r = 0; r < 9; r++) {
        const row = grid.slice(r * 9, r * 9 + 9);
        if (!is_valid_row(row)) {
            return false;
        }
    }
    for (let c = 0; c < 9; c++) {
        const col = [];
        for (let r = 0; r < 9; r++) {
            col.push(grid[r * 9 + c]);
        }
        if (!is_valid_row(col)) {
            return false;
        }
    }
    for (let i = 0; i < 9; i++) {
        const box_row = Math.floor(i / 3);
        const box_col = i % 3;
        const box = [];
        for (let r = box_row * 3; r < box_row * 3 + 3; r++) {
            for (let c = box_col * 3; c < box_col * 3 + 3; c++) {
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
    for (let i = 0; i < 81; i++) {
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
    const p = next_open(grid);
    if (p < 0) {
        return grid;
    }
    for (let v = 1; v <= 9; v++) {
        grid[p] = v;
        const result = solve(grid);
        if (result) {
            return result;
        }
        grid[p] = 0;
    }
    return;
}

function main() {
    if (process.argv.length <= 2) {
        console.log("Please provide the name of an input file as an argument.");
        process.exit(1);
    }
    
    // Get the filename from the first command line argument
    const filename = process.argv[2];
    
    // Read the file line by line
    const lines = fs.readFileSync(filename, 'utf8')
        .split('\n')
        .map((e) => e.trim())
        .filter((e) => e.length > 0);
    
    // Print each line
    for (var i = 0; i < lines.length; i+=2) {
        const input = lines[i];
        const expected = lines[i+1];
    
        const start = performance.now();
        const puzzle = string_to_puzzle(input);
        solve(puzzle);
        const output = puzzle_to_string(puzzle);
        const end = performance.now();
        const duration = end - start;
    
        if (expected === output) {
    		console.log(`Solved sudoku ${input} in ${duration} ms`);
        } else {
    		console.log(`Failed to solve sudoku ${input}. Expected ${expected}, got ${output}s`)
        }
    }
}

if (require.main === module) {
    main();
}