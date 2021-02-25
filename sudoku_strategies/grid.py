from __future__ import annotations

from typing import FrozenSet
from typing import Iterator
from typing import List
from typing import NewType
from typing import Tuple


Cell = NewType('Cell', FrozenSet[int])


class Grid(object):

    indexes = (1, 2, 3, 4, 5, 6, 7, 8, 9)

    def __init__(self, grid: List[List[Cell]]):
        self.grid = grid

    @staticmethod
    def init_from_matrix(sudoku_matrix: List[List[int]]) -> Grid:
        """Each value in the matrix is between 0 and 9. 0 means empty.
        Convert this to a matrix with Candidates for values instead of integers.
        """
        grid = [[Cell(frozenset({1, 2, 3, 4, 5, 6, 7, 8, 9})) for _ in range(9)] for _ in range(9)]
        for r in range(9):
            for c in range(9):
                x = sudoku_matrix[r][c]
                if x != 0:
                    grid[r][c] = Cell(frozenset({x}))
        return Grid(grid)

    def get(self, row: int, col: int) -> Cell:
        return self.grid[row-1][col-1]

    def copy_and_set(self, row: int, col: int, cell: Cell) -> Grid:
        copy = [row[:] for row in self.grid]
        copy[row-1][col-1] = cell
        return Grid(copy)

    def row(self, r: int) -> Iterator[Cell]:
        """Return row (1-indexed)"""
        return (self.get(r, c) for c in Grid.indexes)

    def col(self, c: int) -> Iterator[Cell]:
        """Return row (1-indexed)"""
        return (self.get(r, c) for r in Grid.indexes)

    def rows(self) -> Iterator[Iterator[Cell]]:
        """Return each row for each yield"""
        for r in Grid.indexes:
            yield self.row(r)

    def cols(self) -> Iterator[Iterator[Cell]]:
        """Return each col for each yield"""
        for c in Grid.indexes:
            yield self.col(c)

    def box(self, b: int) -> Iterator[Cell]:
        r_box = (b - 1) // 3
        c_box = (b - 1) % 3
        block = []
        for r in range(r_box * 3, r_box * 3 + 3):
            for c in range(c_box * 3, c_box * 3 + 3):
                yield self.get(r+1, c+1)

    def boxes(self) -> Iterator[Iterator[Cell]]:
        for b in Grid.indexes:
            yield self.box(b)

