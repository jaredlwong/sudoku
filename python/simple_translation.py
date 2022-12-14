import sys
import time
from functools import reduce
from itertools import product

from typing import List

################################################################################
# imperative

def string_to_puzzle(input: str) -> List[int]:
    return map(lambda c: int(c) if c != '.' else 0, input)

def puzzle_to_string(puzzle: List[int]) -> str:
    return map(lambda e: str(e) if e != 0 else '.', puzzle)

def is_valid_row(row: List[int]) -> bool:
    checkset: List[int] = [0] * 10
    for e in row:
        checkset[e] += 1
    return all(e <= 1 for e in checkset[1:])

def is_valid(grid: List[int]) -> bool:
    for r in range(9):
        row = [grid[r*9+c] for c in range(9)]
        if not is_valid_row(row):
            return False
    for c in range(9):
        col = [grid[r*9+c] for r in range(9)]
        if not is_valid_row(col):
            return False
    for i in range(9):
        box_row = i // 3
        box_col = i % 3
        box = [
            grid[r*9+c]
            for r in range(box_row * 3, box_row * 3 + 3)
            for c in range(box_col * 3, box_col * 3 + 3)
        ]
        if not is_valid_row(box):
            return False

def next_open(grid: List[int]):
    for i in range(81):
        if grid[i] == 0:
            return i
    return None

def solve(grid: List[int]):
    if not is_valid(grid):
        return None
    p = next_open(grid)
    if p < 0:
        return grid
    for v in range(1, 10):
        grid[p] = v
        result = solve(grid)
        if result:
            return result
        grid[p] = 0
    return None

################################################################################
# functional

def string_to_puzzle(input: str) -> List[int]:
    return map(lambda c: int(c) if c != '.' else 0, input)

def puzzle_to_string(puzzle: List[int]) -> str:
    return map(lambda e: str(e) if e != 0 else '.', puzzle)

def is_valid_row(row: List[int]) -> bool:
    def add_to_checkset(checkset, x):
        checkset[x] += 1
        return checkset
    checkset = reduce(add_to_checkset, row, [0]*10)
    return all(map(lambda x: x <= 1, checkset[1:]))

def is_valid(grid: List[int]) -> bool:
    rows = map(lambda r: map(lambda c: grid[r*9+c], range(9)), range(9))
    cols = map(lambda c: map(lambda r: grid[r*9+c], range(9)), range(9))
    boxs = map(lambda i: map(lambda r, c: grid[r*9+c],
                             product(range((i // 3) * 3, (i // 3) * 3 + 3),
                                     range((i % 3) * 3, (i % 3) * 3 + 3))), range(9))
    return all(map(is_valid_row, rows)) and all(map(is_valid_row, cols)) and all(map(is_valid_row, boxs))

def next_open(grid: List[int]):
    xxx = map(lambda x: x == 0, grid)
    yyy = enumerate(xxx)
    zzz = filter(lambda i, x: x, yyy)
    return next(zzz, -1)[0]
    # return next(filter(lambda i: grid[i] == 0, range(81)), -1)

def solve(grid: List[int]):
    p = next_open(grid)
    valid = is_valid(grid)
    def try_value(v):
        grid[p] = v
        return v if solve(grid) else 0
    if not valid:
        return False
    if p < 0:
        return True
    grid[p] = next(filter(lambda v: v != 0, map(try_value, range(1, 10))), 0)
    return grid[p] != 0

################################################################################

def string_to_puzzle(input: str) -> List[List[int]]:
    return [
        [int(input[i*9+j]) if input[i*9+j] != '.' else 0 for j in range(9)]
        for i in range(9)
    ]

def string_to_puzzle(input: str) -> List[List[int]]:
    nums = [int(c) if c != '.' else 0 for c in input]
    return [[nums[i*9+j] for j in range(9)] for i in range(9)]

def puzzle_to_string(grid: List[List[int]]) -> str:
    return ''.join(''.join(str(e) for e in row) for row in grid)

def is_valid_row(row: str) -> bool:
    checkset: List[int] = [0] * 10
    for e in row:
        checkset[int(e)] += 1
    return all(e <= 1 for e in checkset[1:])

def is_valid_row(row: List[int]) -> bool:
    return all(map(lambda x: x <= 1, reduce(lambda acc, x: acc[x-1] += 1, row, [0] * 9)))

def is_valid(grid: str) -> bool:
    for r in range(9):
        row = [grid[r][c] for c in range(9)]
        if not is_valid_row(row):
            return False
    for c in range(9):
        col = [grid[r][c] for r in range(9)]
        if not is_valid_row(col):
            return False
    for i in range(9):
        box_row = i // 3
        box_col = i % 3
        box = [
            grid[r][c]
            for r in range(box_row * 3, box_row * 3 + 3)
            for c in range(box_col * 3, box_col * 3 + 3)
        ]
        if not is_valid_row(box):
            return False


def is_valid(grid: List[List[int]]) -> bool:
    # check rows
    if any(not is_valid_row(grid[r]) for r in range(9)):
        return False

    # check cols
    transposed = list(zip(*grid))
    if any(not is_valid_row(transposed[c]) for c in range(9)):
        return False

    # check boxes
    box_rows_cols: List[tuple(int, int)] = [(x // 3, x % 3) for x in range(9)]
    boxes = [
        [grid[r][c] for r in range(box_row * 3, box_row * 3 + 3) for c in range(box_col * 3, box_col * 3 + 3)]
        for box_row, box_col in box_rows_cols
    ]
    if any(not is_valid_row(boxes)):
        return False
    # for x in range(9):
    #     box_row: int = x // 3
    #     box_col: int = x % 3
    #     box: List[int] = [
    #         grid[r][c]
    #         for r in range(box_row * 3, box_row * 3 + 3)
    #         for c in range(box_col * 3, box_col * 3 + 3)
    #     ]
    #     if not is_valid_row(box):
    #         return False

    return True

import itertools
def check_boxes(grid: List[List[int]]) -> bool:
    indices = [list(itertools.product(range((x // 3) * 3, (x // 3) * 3 + 3), range((x % 3) * 3, (x % 3) * 3 + 3))) for x in range(9)]
    boxes = [[grid[r][c] for r, c in index] for index in indices]
    return all(is_valid_row(boxes))

import itertools
def next_open(grid):
    indices = itertools.product(range(9), range(9))
    opened = filter(lambda x: grid[x[0]][x[1]] == 0, indices)
    return next(opened, None)
    # return next(((r, c) for r, c in itertools.product(range(9), range(9)) if grid[r][c] == 0), None)

def next_open(grid: List[List[int]]):
    for r in range(9):
        for c in range(9):
            if grid[r][c] == 0:
                return (r, c)
    return None

def next_open(grid: str) -> int:
    for r in range(9):
        for c in range(9):
            if grid[r*9+c] == 0:
                return r*9+c
    return None

def solve(grid: str):
    if not is_valid(grid):
        return None
    p = next_open(grid)
    if p < 0:
        return grid
    for v in range(1, 10):
        result = solve(grid[:p] + str(v) + grid[p+1:])
        if result:
            return result
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
    