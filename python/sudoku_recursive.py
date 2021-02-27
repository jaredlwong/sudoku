"""This solution is a simple recursive dfs with grids being mutated in place"""

from __future__ import annotations

from typing import FrozenSet
from typing import Iterator
from typing import List
from typing import NewType
from typing import Tuple

import time
import sys

import numpy as np


class SudokuParser(object):
    @staticmethod
    def read_from_file(fn):
        pass

    @staticmethod
    def parse_str(s):
        grid = [[int(c) for c in row] for row in s.split('\n') if row]
        return Sudoku(grid)


class Sudoku(object):

    def __init__(self, grid):
        self._grid = grid

    def get(self, row: int, col: int) -> int:
        return self._grid[row][col]

    def set(self, row: int, col: int, v: int):
        self._grid[row][col] = v

    def row(self, r: int) -> Iterator[int]:
        """Return row (0-indexed)"""
        return (self.get(r, c) for c in range(9))

    def col(self, c: int) -> Iterator[int]:
        """Return col (0-indexed)"""
        return (self.get(r, c) for r in range(9))

    def rows(self) -> Iterator[Iterator[int]]:
        """Return each row for each yield"""
        for r in range(9):
            yield self.row(r)

    def cols(self) -> Iterator[Iterator[int]]:
        """Return each col for each yield"""
        for c in range(9):
            yield self.col(c)

    def box(self, b: int) -> Iterator[int]:
        r_box = b // 3
        c_box = b % 3
        block = []
        for r in range(r_box * 3, r_box * 3 + 3):
            for c in range(c_box * 3, c_box * 3 + 3):
                yield self.get(r, c)

    def boxes(self) -> Iterator[Iterator[int]]:
        for b in range(9):
            yield self.box(b)


class SudokuSolver(object):

    @staticmethod
    def grp_okay(grp: Iterator[int]) -> bool:
        grp_minus_zeros = [x for x in grp if x != 0]
        return len(grp_minus_zeros) == len(set(grp_minus_zeros))

    @staticmethod
    def sudoku_possible(sudoku: Sudoku) -> bool:
        if not all(SudokuSolver.grp_okay(row) for row in sudoku.rows()):
            return False
        if not all(SudokuSolver.grp_okay(col) for col in sudoku.cols()):
            return False
        if not all(SudokuSolver.grp_okay(box) for box in sudoku.boxes()):
            return False
        return True

    @staticmethod
    def sudoku_complete(sudoku: Sudoku) -> bool:
        return all(c != 0 for row in sudoku.rows() for c in row)

    @staticmethod
    def next_open(sudoku: Sudoku) -> Optional[Tuple[int, int]]:
        for i in range(9):
            for j in range(9):
                if sudoku.get(i, j) == 0:
                    return i, j
        return None

    @staticmethod
    def sudoku_solve(sudoku: Sudoku):
        if not SudokuSolver.sudoku_possible(sudoku):
            return None
        if SudokuSolver.sudoku_complete(sudoku):
            return sudoku
        r, c = SudokuSolver.next_open(sudoku)
        for k in range(1, 10):
            sudoku.set(r, c, k)
            result = SudokuSolver.sudoku_solve(sudoku)
            if result:
                return result
            sudoku.set(r, c, 0)
        return None


# sudoku_puzzle = '''
# 070050010
# 000028600
# 200000000
# 000006000
# 530000007
# 080090040
# 600000081
# 005300000
# 000009370
# '''

sudoku_puzzle = '''
801340000
430800107
000060003
208050009
009000700
600070804
300010000
105006042
000024308
'''

if __name__ == '__main__':
    sudoku: Sudoku = SudokuParser.parse_str(sudoku_puzzle)
    solved: Sudoku = SudokuSolver.sudoku_solve(sudoku)
    for row in solved._grid:
        print(row)
