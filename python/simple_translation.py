import sys
import time

from typing import List

def string_to_puzzle(input: str) -> List[List[int]]:
    return [
        [int(input[i*9+j]) if input[i*9+j] != '.' else 0 for j in range(9)]
        for i in range(9)
    ]

def puzzle_to_string(grid: List[List[int]]) -> str:
    return ''.join(''.join(str(e) for e in row) for row in grid)

def is_valid_row(row: List[int]) -> bool:
    checkset: List[int] = [0] * 10
    for e in row:
        checkset[e] += 1
    return all(e <= 1 for e in checkset[1:])

def is_valid(grid: List[List[int]]) -> bool:
    # check rows
    for r in range(9):
        if not is_valid_row(grid[r]):
            return False

    # check cols
    transposed = list(zip(*grid))
    for c in range(9):
        if not is_valid_row(transposed[c]):
            return False

    # check boxes
    for x in range(9):
        box_row: int = x // 3
        box_col: int = x % 3
        box: List[int] = [
            grid[r][c]
            for r in range(box_row * 3, box_row * 3 + 3)
            for c in range(box_col * 3, box_col * 3 + 3)
        ]
        if not is_valid_row(box):
            return False

    return True

# def next_open(grid: List[List[int]]):
def next_open(grid):
    for r in range(9):
        for c in range(9):
            if grid[r][c] == 0:
                return (r, c)
    return None

# def solve(grid):
def solve(grid: List[List[int]]):
    if not is_valid(grid):
        return False
    p = next_open(grid)
    # if complete
    if not p:
        return True
    row, col = p
    for v in range(1, 10):
        grid[row][col] = v
        result = solve(grid)
        if result:
            return True
        grid[row][col] = 0
    return False

def solve(grid):
    if not is_valid(grid):
        return None
    p = next_open(grid)
    if not p:
        return grid
    row, col = p
    for v in range(1, 10):
        grid[row][col] = v
        result = solve(grid)
        if result:
            return result
        grid[row][col] = 0
    return None

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Please provide the name of an input file as an argument.")
        exit(1)

    filename = sys.argv[1]

    with open(filename) as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]
        for i in range(0, len(lines), 2):
            input = lines[i]
            expected = lines[i+1]
            s = string_to_puzzle(input)
            start = time.time()
            solve(s)
            end = time.time()
            if puzzle_to_string(s) == expected:
                print("Solved sudoku %s in %d ms" % (input, (end-start)*1000))
            else:
                print("Failed to solve sudoku %s. Expected %s, got %s" % (input, expected, s))
                exit(1)

                
def test(input: List[str]):
    for i in range(0, len(lines), 2):
        input = lines[i]
        expected = lines[i+1]
        s = string_to_puzzle(input)
        start = time.time()
        solve(s)
        end = time.time()
        if puzzle_to_string(s) == expected:
            print("Solved sudoku %s in %d ms" % (input, (end-start)*1000))
        else:
            print("Failed to solve sudoku %s. Expected %s, got %s" % (input, expected, s))
            exit(1)
    