"""This solution is a simple bfs with grids being copied using np.array"""

from __future__ import annotations

from typing import FrozenSet
from typing import Iterator
from typing import List
from typing import NewType
from typing import Optional
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
        np_grid = np.zeros(81)
        for i in range(9):
            for j in range(9):
                np_grid[i*9+j] = grid[i][j]
        return Sudoku(np_grid)


class Sudoku(object):

    indexes = (1, 2, 3, 4, 5, 6, 7, 8, 9)

    def __init__(self, grid):
        self._grid = grid

    def get(self, row: int, col: int) -> int:
        return self._grid[(row-1)*9+(col-1)]

    def copy_and_set(self, row: int, col: int, v: int) -> Sudoku:
        new_grid = self._grid.copy()
        new_grid[(row-1)*9+(col-1)] = v
        return Sudoku(new_grid)

    def row(self, r: int) -> Iterator[int]:
        """Return row (1-indexed)"""
        return (self.get(r, c) for c in Sudoku.indexes)

    def col(self, c: int) -> Iterator[int]:
        """Return row (1-indexed)"""
        return (self.get(r, c) for r in Sudoku.indexes)

    def rows(self) -> Iterator[Iterator[int]]:
        """Return each row for each yield"""
        for r in Sudoku.indexes:
            yield self.row(r)

    def cols(self) -> Iterator[Iterator[int]]:
        """Return each col for each yield"""
        for c in Sudoku.indexes:
            yield self.col(c)

    def box(self, b: int) -> Iterator[int]:
        r_box = (b - 1) // 3
        c_box = (b - 1) % 3
        for r in range(r_box * 3, r_box * 3 + 3):
            for c in range(c_box * 3, c_box * 3 + 3):
                yield self.get(r+1, c+1)

    def boxes(self) -> Iterator[Iterator[int]]:
        for b in Sudoku.indexes:
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
    def sudoku_gen_next(sudoku: Sudoku) -> List[Sudoku]:
        position = SudokuSolver.next_open(sudoku)
        if not position:
            return []
        r, c = position
        return [sudoku.copy_and_set(r, c, k) for k in range(1, 10)]

    @staticmethod
    def next_open(sudoku: Sudoku) -> Optional[Tuple[int, int]]:
        for i in range(1, 10):
            for j in range(1, 10):
                if sudoku.get(i, j) == 0:
                    return i, j
        return None

    @staticmethod
    def sudoku_solve(sudoku: Sudoku) -> Optional[Sudoku]:
        queue = SudokuSolver.sudoku_gen_next(sudoku)
        while len(queue) > 0:
            s = queue.pop()
            if not SudokuSolver.sudoku_possible(s):
                continue
            if SudokuSolver.sudoku_complete(s):
                return s
            queue.extend(SudokuSolver.sudoku_gen_next(s))
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
    solved: Optional[Sudoku] = SudokuSolver.sudoku_solve(sudoku)
    if solved:
        print(solved._grid)
    else:
        print(sudoku._grid)
