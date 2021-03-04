from sudoku import *


def solve_remove_solved_neighbors(sudoku: Sudoku, r: int, c: int, verbose: bool) -> bool:
    """Remove any neighbors that can be seen which are already solved. Return if the cell was changed"""
    cell: Cell = sudoku.grid[r][c]
    if cell.solved():
        return False
    seen_values: Set[int] = set(filter(None, (c.value() for c in sudoku.seen_from(r, c))))
    changed = cell.exclude(seen_values)
    if verbose and changed:
        print(' * Cell %s can only be %s' % (cell.cell_name, cell.candidates_str()))
    return changed


def solve_naked_singles(sudoku: Sudoku, verbose: bool) -> bool:
    """Exclude the values of seen solved cells as candidates for unsolved cells. Return if any changes occurred"""
    # need to use list so that it actually doesn't lazy execute
    return any([solve_remove_solved_neighbors(sudoku, r, c, verbose)
                for r in range(9)
                for c in range(9)])


s = '406000500010706040009000601000200060105060807670008000000600080508000906060003000'
sudoku = Sudoku.init_from_matrix([[int(s[r*9+c]) for c in range(9)]for r in range(9)])
print(sudoku.terse_str())
print(sudoku.verbose_str())
print(solve_naked_singles(sudoku, True))
print(sudoku.verbose_str())
