sudoku = [
    [8, 0, 1, 3, 4, 0, 0, 0, 0],
    [4, 3, 0, 8, 0, 0, 1, 0, 7],
    [0, 0, 0, 0, 6, 0, 0, 0, 3],
    [2, 0, 8, 0, 5, 0, 0, 0, 9],
    [0, 0, 9, 0, 0, 0, 7, 0, 0],
    [6, 0, 0, 0, 7, 0, 8, 0, 4],
    [3, 0, 0, 0, 1, 0, 0, 0, 0],
    [1, 0, 5, 0, 0, 6, 0, 4, 2],
    [0, 0, 0, 0, 2, 4, 3, 0, 8]
]

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
        sudoku_copy = map(list, sudoku)
        sudoku_copy[i][j] = k
        next_sudokus.append(sudoku_copy)
    return next_sudokus

def sudoku_solve(sudoku):
    queue = [sudoku]
    while len(queue) > 0:
        sudoku = queue.pop()
        if not sudoku_possible(sudoku):
            continue
        if sudoku_complete(sudoku):
            return sudoku
        queue.extend(sudoku_gen_next(sudoku))
    return None

def sudoku_to_str(sudoku):
    rep = ''
    for i, row in enumerate(sudoku):
        for j, val in enumerate(row):
            rep += str(val)
            if j == 2 or j == 5:
                rep += "|"
            elif j < 8:
                rep += " "
        rep += '\n'
        if i == 2 or i == 5:
            rep += '-' * 17 + '\n'
    return rep[:-1]

print sudoku_to_str(sudoku_solve(sudoku))
