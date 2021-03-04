#!/usr/bin/env python3

from collections import namedtuple
from typing import FrozenSet
from typing import Set
from typing import List
from typing import Tuple
from typing import NewType

# import numpy as np




puzzle_html = '''
<style>
.sudoku {{ border-collapse: collapse; font-family: Calibri, sans-serif; }}
.sudoku colgroup, tbody {{ border: solid medium; }}
.sudoku td {{ border: solid thin; height: 1.4em; width: 1.4em; text-align: center; padding: 0; }}
</style>

<table class="sudoku">
  <colgroup><col><col><col>
  <colgroup><col><col><col>
  <colgroup><col><col><col>
  <tbody>
   <tr> <td> {x11} <td> {x12} <td> {x13} <td> {x14} <td> {x15} <td> {x16} <td> {x17} <td> {x18} <td> {x19}
   <tr> <td> {x21} <td> {x22} <td> {x23} <td> {x24} <td> {x25} <td> {x26} <td> {x27} <td> {x28} <td> {x29}
   <tr> <td> {x31} <td> {x32} <td> {x33} <td> {x34} <td> {x35} <td> {x36} <td> {x37} <td> {x38} <td> {x39}
  <tbody>
   <tr> <td> {x41} <td> {x42} <td> {x43} <td> {x44} <td> {x45} <td> {x46} <td> {x47} <td> {x48} <td> {x49}
   <tr> <td> {x51} <td> {x52} <td> {x53} <td> {x54} <td> {x55} <td> {x56} <td> {x57} <td> {x58} <td> {x59}
   <tr> <td> {x61} <td> {x62} <td> {x63} <td> {x64} <td> {x65} <td> {x66} <td> {x67} <td> {x68} <td> {x69}
  <tbody>
   <tr> <td> {x71} <td> {x72} <td> {x73} <td> {x74} <td> {x75} <td> {x76} <td> {x77} <td> {x78} <td> {x79}
   <tr> <td> {x81} <td> {x82} <td> {x83} <td> {x84} <td> {x85} <td> {x86} <td> {x87} <td> {x88} <td> {x89}
   <tr> <td> {x91} <td> {x92} <td> {x93} <td> {x94} <td> {x95} <td> {x96} <td> {x97} <td> {x98} <td> {x99}
</table>
'''

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

rep = [[int(c) for c in line] for line in sudoku_puzzle.split('\n') if line]

# d = dict()
# for r in range(9):
#     for c in range(9):
#         d['x' + str(r+1) + str(c+1)] = rep[r][c] if rep[r][c] != 0 else ''
# test = puzzle_html.format(**d)


def sudoku_string_to_matrix(sudoku_grid: str) -> List[List[int]]:
    return [[int(c) for c in line] for line in sudoku_puzzle.split('\n') if line]


CellIndex = namedtuple('CellIndex', ['r', 'c'])




class Sudoku(object):

    def __init__(self, sudoku_matrix: List[List[int]]):
        """0 should be used in place of a space"""
        self.verify(sudoku_matrix)
        self.grid = self.initialize_grid(sudoku_matrix)

    def verify(self, sudoku_matrix: List[List[int]]):
        """Ensure there are 9 rows and 9 columns and each value is between 0 and 9. 0 means empty"""
        assert(len(sudoku_matrix) == 9)
        for row in sudoku_matrix:
            assert(len(row) == 9)
            assert(all(0 <= x and x <= 9 for x in row))

    def initialize_grid(self, sudoku_matrix: List[List[int]]) -> List[List[FrozenSet[int]]]:
        """Each value in the matrix is between 0 and 9. 0 means empty.
        Convert this to a matrix with Candidates for values instead of integers.
        """
        grid = [[frozenset({1, 2, 3, 4, 5, 6, 7, 8, 9}) for _ in range(9)] for _ in range(9)]
        for r in range(9):
            for c in range(9):
                x = sudoku_matrix[r][c]
                if x != 0:
                    grid[r][c] = frozenset({x})
        return grid

    def cell_to_str(self, candidates: FrozenSet[int]) -> str:
        cell_format_str = ("{c1} {c2} {c3}\n"
                           "{c4} {c5} {c6}\n"
                           "{c7} {c8} {c9}")
        format_args = {'c{}'.format(i): str(i) if i in candidates else ' ' for i in range(1, 10)}
        return cell_format_str.format(**format_args)

    def horizontal_join(self, sep: str, strings: List[str]) -> str:
        """Join multiline strings horizontally repeating the separator between them"""
        rows = []
        for row_parts in zip(*[s.split('\n') for s in strings]):
            rows.append(sep.join(row_parts))
        return '\n'.join(rows)

    def repeat_to_length(self, s: str, wanted: int) -> str:
        return (s * (wanted//len(s) + 1))[:wanted]

    def multiline_string_width_height(self, s: str) -> Tuple[int, int]:
        rows = s.split('\n')
        return (max(len(r) for r in rows), len(rows))

    def vertical_join(self, sep: str, rows: List[str]) -> str:
        """Join multiline strings vertically repeating the separator between them"""
        rows_with_sep = []
        for i in range(len(rows) - 1):
            rows_with_sep.append(rows[i])
            width, _ = self.multiline_string_width_height(rows[i])
            rows_with_sep.append(self.repeat_to_length(sep, width))
        if len(rows) > 1:
            rows_with_sep.append(rows[-1])
        return '\n'.join(rows_with_sep)

    def block_to_str(self, block_num: int) -> str:
        """block_num between 1 and 9. 1 is top left block, 9 is bottom right block."""
        row_block = (block_num - 1) // 3
        col_block = (block_num - 1) % 3
        block = []
        for r in range(row_block * 3, row_block * 3 + 3):
            row = []
            for c in range(col_block * 3, col_block * 3 + 3):
                cell_str = self.cell_to_str(self.grid[r][c])
                row.append(cell_str)
            block.append(self.horizontal_join(' | ', row))
        return self.vertical_join('-', block)

    def grid_to_str(self):
        block_layout = [[i + j*3 for i in range(1, 4)] for j in range(3)]
        grid_str = []
        for row in block_layout:
            block_row = []
            for block_num in row:
                block_row.append(self.block_to_str(block_num))
            grid_str.append(self.horizontal_join(' █ ', block_row))
        return self.vertical_join('■', grid_str)

    def find_solved_cells(self) -> FrozenSet[Tuple[int, int]]:
        return frozenset((r + 1, c + 1) for r in range(9) for c in range(9) if len(self.grid[r][c]) == 1)

    def s1_col_elimination(self, r: int, c: int):
        solved_nums: Set[int] = set()
        for i in range(1, 10):
            if i == c:
                pass
            if len(self.grid[r][i]) == 1:
                solved_nums |= self.grid[r][i]
        print(self.grid[r][c] - solved_nums)



s = Sudoku(rep)
print(s.grid_to_str())
print(s.find_solved_cells())
