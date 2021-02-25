from typing import FrozenSet
from typing import List
from typing import Tuple
from typing import NewType


Cell = NewType('Cell', FrozenSet[int])
Row = NewType('Row', Tuple[Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell, Cell])
Grid = NewType('Grid', Tuple[Row, Row, Row, Row, Row, Row, Row, Row, Row])


def initialize_grid(sudoku_matrix: List[List[int]]) -> Grid:
    """Each value in the matrix is between 0 and 9. 0 means empty.
    Convert this to a matrix with Candidates for values instead of integers.
    """
    grid = Grid(tuple(tuple(frozenset({1, 2, 3, 4, 5, 6, 7, 8, 9}) for _ in range(9)) for _ in range(9)))
    for r in range(9):
        for c in range(9):
            x = sudoku_matrix[r][c]
            if x != 0:
                grid = replace_at_index(grid, r+1, c+1, frozenset({x}))
    return grid


def replace_at_index(grid: Grid, row: int, col: int, cell: Cell) -> Grid:
    mutable = list(list(row) for row in grid)
    mutable[row-1][col-1] = cell
    return Grid(tuple(tuple(row) for row in mutable))



sudoku_puzzle = '''
070050010
000028600
200000000
000006000
530000007
080090040
600000081
005300000
000009370
'''

def sudoku_string_to_matrix(sudoku_grid: str) -> List[List[int]]:
    return [[int(c) for c in line] for line in sudoku_puzzle.split('\n') if line]

print(initialize_grid(sudoku_string_to_matrix(sudoku_puzzle)))
