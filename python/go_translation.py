import sys
import time
from typing import List


class Sudoku(object):
    def __init__(self, input: str):
        self.grid: List[List[int]] = []
        for i in range(9):
            self.grid.append([])
            for j in range(9):
                val = input[i*9+j]
                self.grid[i].append(int(val) if val != '.' else 0)

    def __str__(self) -> str:
        return ''.join(''.join(str(e) for e in row) for row in self.grid)

    def is_valid(self) -> bool:
        # check rows
        for r in range(9):
            checkset = [0] * 10
            for c in range(9):
                checkset[self.grid[r][c]] += 1
                if self.grid[r][c] > 0 and checkset[self.grid[r][c]] > 1:
                    return False

        # check cols
        for c in range(9):
            checkset = [0] * 10
            for r in range(9):
                checkset[self.grid[r][c]] += 1
                if self.grid[r][c] > 0 and checkset[self.grid[r][c]] > 1:
                    return False

        # check boxes
        for x in range(9):
            checkset = [0] * 10
            box_row = x // 3
            box_col = x % 3
            for r in range(box_row * 3, box_row * 3 + 3):
                for c in range(box_col * 3, box_col * 3 + 3):
                    checkset[self.grid[r][c]] += 1
                    if self.grid[r][c] > 0 and checkset[self.grid[r][c]] > 1:
                        return False

        return True

    def next_open(self):
        for r in range(9):
            for c in range(9):
                if self.grid[r][c] == 0:
                    return (r, c)
        return None

    def solve(self):
        if not self.is_valid():
            return False
        p = self.next_open()
        # if complete
        if not p:
            return True
        row, col = p
        for v in range(1, 10):
            self.grid[row][col] = v
            result = self.solve()
            if result:
                return True
            self.grid[row][col] = 0
        return False


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
            s = Sudoku(input)
            start = time.time()
            s.solve()
            end = time.time()
            if str(s) == expected:
                print("Solved sudoku %s in %d ms" % (input, (end-start)*1000))
            else:
                print("Failed to solve sudoku %s. Expected %s, got %s" % (input, expected, s))
                exit(1)
