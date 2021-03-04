from __future__ import annotations

from typing import List
from typing import Set
from typing import Optional


class Cell(object):
    def __init__(self, r, c, candidates: Set[int]=None):
        self.r = r
        self.c = c
        self.b = r // 3 * 3 + c // 3
        self.candidates = candidates or {1, 2, 3, 4, 5, 6, 7, 8, 9}

    @property
    def row_name(self) -> str:
        return 'ABCDEFGHI'[self.r]

    @property
    def column_name(self) -> str:
        return '123456789'[self.c]

    @property
    def block_name(self) -> str:
        return '123456789'[self.b]

    @property
    def cell_name(self) -> str:
        return self.row_name + self.column_name

    def solved(self) -> bool:
        return len(self.candidates) == 1

    def value(self) -> Optional[int]:
        return list(self.candidates)[0] if self.solved() else None

    def value_str(self) -> str:
        v = self.value()
        return str(v) if v else '.'

    def candidate_str(self, candidate) -> str:
        return str(candidate) if candidate in self.candidates else ' '

    def candidates_str(self) -> str:
        return '{' + ', '.join([str(c) for c in sorted(self.candidates)]) + '}'

    def exclude(self, other_candidates: Set[int]) -> bool:
        n = len(self.candidates)
        self.candidates -= other_candidates
        return len(self.candidates) < n

    def include_only(self, other_candidates: Set[int]) -> bool:
        n = len(self.candidates)
        self.candidates &= other_candidates
        return len(self.candidates) < n

    def __hash__(self):
        return hash((self.r, self.c))

    def __eq__(self, other):
        return isinstance(other, Cell) and (self.r, cel.c) == (other.r, other.c)


class Sudoku(object):

    def __init__(self, grid: List[List[Cell]]):
        self.grid = grid

    @staticmethod
    def init_from_matrix(sudoku_matrix: List[List[int]]) -> Sudoku:
        """Each value in the matrix is between 0 and 9. 0 means empty.
        Convert this to a matrix with Candidates for values instead of integers.
        """
        grid = [[Cell(r, c) for c in range(9)] for r in range(9)]
        for r in range(9):
            for c in range(9):
                x = sudoku_matrix[r][c]
                if x != 0:
                    grid[r][c].include_only({x})
        return Sudoku(grid)

    def row(self, r: int) -> List[Cell]:
        return self.grid[r]

    def row_without(self, r: int, c: int) -> List[Cell]:
        """get the row r without column c"""
        return [self.grid[r][ca] for ca in range(9) if ca != c]

    def column(self, c: int) -> List[Cell]:
        return [self.grid[r][c] for r in range(9)]

    def column_without(self, r: int, c: int) -> List[Cell]:
        """get the column c without row r"""
        return [self.grid[ra][c] for ra in range(9) if ra != r]

    def block(self, b: int) -> List[Cell]:
        block_row, block_col = divmod(b, 3)
        return [self.grid[r][c]
                for r in range(block_row * 3, block_row * 3 + 3)
                for c in range(block_col * 3, block_col * 3 + 3)]

    def block_without(self, r: int, c: int) -> List[Cell]:
        block_row = r // 3 * 3
        block_col = c // 3 * 3
        return [self.grid[ra][ca]
                for ra in range(block_row, block_row + 3)
                for ca in range(block_col, block_col + 3)
                if not (ra == r and ca == c)]

    def seen_from(self, r: int, c: int) -> Set[Cell]:
        row = self.row_without(r, c)
        col = self.column_without(r, c)
        block = self.block_without(r, c)
        return set(row + col + block)

    def terse_str(self):
        return '''    1 2 3   4 5 6   7 8 9
  +-------+-------+-------+
A | %s %s %s | %s %s %s | %s %s %s |
B | %s %s %s | %s %s %s | %s %s %s |
C | %s %s %s | %s %s %s | %s %s %s |
  +-------+-------+-------+
D | %s %s %s | %s %s %s | %s %s %s |
E | %s %s %s | %s %s %s | %s %s %s |
F | %s %s %s | %s %s %s | %s %s %s |
  +-------+-------+-------+
G | %s %s %s | %s %s %s | %s %s %s |
H | %s %s %s | %s %s %s | %s %s %s |
J | %s %s %s | %s %s %s | %s %s %s |
  +-------+-------+-------+''' % tuple(c.value_str() for row in self.grid for c in row)

    def verbose_str(self):
        all_cells = []
        for r in range(9):
            for candidate_r in range(3):
                for c in range(9):
                    for candidate_c in range(3):
                        # have to add 1 since it's zero indexed [0, 9) -> [1, 9]
                        candidate = candidate_r * 3 + candidate_c + 1
                        all_cells.append(self.grid[r][c].candidate_str(candidate))
        return ('''     1   2   3     4   5   6     7   8   9
  +-------------+-------------+-------------+
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
A | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
B | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
C | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  +-------------+-------------+-------------+
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
D | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
E | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
F | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  +-------------+-------------+-------------+
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
G | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
H | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  |             |             |             |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
J | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s | %s%s%s %s%s%s %s%s%s |
  +-------------+-------------+-------------+''' % tuple(all_cells))
