import sys

def transpose(mat):
    return [list(x) for x in zip(*mat)]

def sudoku_rows(sudoku):
    return sudoku

def sudoku_cols(sudoku):
    return transpose(sudoku)

def sudoku_sqrs(sudoku):
    sqrs = {(x, y): [] for x in range(3) for y in range(3)}
    for i, row in enumerate(sudoku):
        for j, v in enumerate(row):
            sqrs[(i/3, j/3)].append(v)
    return sqrs.values()

def grp_okay(grp):
    grp_minus_zeros = [x for x in grp if x != 0]
    return len(grp_minus_zeros) == len(set(grp_minus_zeros))

def sudoku_possible(sudoku):
    grps = []
    grps.extend(sudoku_rows(sudoku))
    grps.extend(sudoku_cols(sudoku))
    grps.extend(sudoku_sqrs(sudoku))
    return all(grp_okay(grp) for grp in grps)

def sudoku_complete(sudoku):
    for row in sudoku:
        for v in row:
            if v == 0:
                return False
    return True

def sudoku_next_empty(sudoku):
    for i in range(len(sudoku)):
        for j in range(len(sudoku[i])):
            if sudoku[i][j] == 0:
                return (i, j)
    return None

def sudoku_gen_next(sudoku):
    i, j = sudoku_next_empty(sudoku)
    next_sudokus = []
    for k in range(1, 10):
        def execute(sudoku):
            sudoku[i][j] = k
        def undo(sudoku):
            sudoku[i][j] = 0
        next_sudokus.append((execute, undo))
    return next_sudokus

def sudoku_solve(sudoku):
    if not sudoku_possible(sudoku):
        return None
    if sudoku_complete(sudoku):
        return True
    sudoku_gen_next(sudoku)
    for execute, undo in sudoku_gen_next(sudoku):
        execute(sudoku)
        if sudoku_solve(sudoku):
            return True
        undo(sudoku)
    return None

def sudoku_to_str(sudoku):
    rep = ''
    for i, row in enumerate(sudoku):
        for j, val in enumerate(row):
            rep += str(val)
        rep += '\n'
    return rep[:-1]

def sudoku_file_to_rep(file_name):
    sudoku = []
    with open(file_name) as fn:
        for row in fn.readlines():
            row = row.rstrip('\n')
            sudoku.append(map(int, row))
    return sudoku

if __name__ == '__main__':
    sudoku_file = sys.argv[1]
    sudoku = sudoku_file_to_rep(sudoku_file)
    print sudoku_sqr_keys 
    #print sudoku_to_str(sudoku_solve(sudoku))
