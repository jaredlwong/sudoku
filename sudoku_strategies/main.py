from grid import Grid
from typing import List


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

grid = Grid.init_from_matrix(sudoku_string_to_matrix(sudoku_puzzle))

print([c for c in grid.box(9)])


