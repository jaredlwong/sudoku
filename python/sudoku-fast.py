import time

sudoku_puzzle = [
[8,0,1,3,4,0,0,0,0],
[4,3,0,8,0,0,1,0,7],
[0,0,0,0,6,0,0,0,3],
[2,0,8,0,5,0,0,0,9],
[0,0,9,0,0,0,7,0,0],
[6,0,0,0,7,0,8,0,4],
[3,0,0,0,1,0,0,0,0],
[1,0,5,0,0,6,0,4,2],
[0,0,0,0,2,4,3,0,8]]
sudoku_puzzle2 = [
[8,0,1,3,4,0,0,0,0],
[4,3,0,8,0,0,1,0,7],
[0,0,0,0,6,0,0,0,3],
[2,0,8,0,5,0,0,0,9],
[0,0,9,0,0,0,7,0,0],
[6,0,0,0,7,0,8,0,4],
[3,0,0,0,1,0,0,0,0],
[1,0,5,0,0,6,0,4,2],
[0,0,0,0,2,4,3,0,8]]

def transpose(mat):
    return [list(x) for x in zip(*mat)]

def sudoku_rows(sudoku):
    return sudoku

def sudoku_cols(sudoku):
    return transpose(sudoku)

#def sudoku_sqrs(sudoku):
#    sqrs = {(x, y): [] for x in range(3) for y in range(3)}
#    for i, row in enumerate(sudoku):
#        for j, v in enumerate(row):
#            sqrs[(i/3, j/3)].append(v)
#    return sqrs.values()

def sudoku_sqrs(sudoku):
    sqrs = [list() for _ in range(9)]
    for i in range(3):
        for j in range(3):
            for k in range(i*3,i*3+3):
                for l in range(j*3,j*3+3):
                    sqrs[row_col_to_sqr(k,l)].append(sudoku[k][l])
    return sqrs

def row_col_to_sqr(row, col):
    return (row/3)*3+(col/3)

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

def sudoku_constants(sudoku):
    constants = []
    for i, row in enumerate(sudoku):
        for j, e in enumerate(row):
            if e == 0:
                constants.append((i,j))
    return constants

def sudoku_next_empty(sudoku, constants):
    for i, j in constants:
        if sudoku[i][j] == 0:
            return (i, j)
    return None

def sudoku_previous_empty(sudoku, constants):
    for i, j in reversed(constants):
        if sudoku[i][j] != 0:
            return (i, j)
    return None


def sudoku_solve_slower(sudoku):
    constants = sudoku_constants(sudoku)
    while True:
        if sudoku_complete(sudoku):
            return sudoku
        if sudoku_possible(sudoku):
            i, j = sudoku_next_empty(sudoku, constants)
            sudoku[i][j] = 1
        else:
            i, j = sudoku_previous_empty(sudoku, constants)
            while sudoku[i][j] == 9:
                sudoku[i][j] = 0
                i, j = sudoku_previous_empty(sudoku, constants)
            sudoku[i][j] += 1
    return None

def sudoku_solve(sudoku):
    constants = sudoku_constants(sudoku)
    rows = [set(r) for r in sudoku_rows(sudoku)]
    cols = [set(c) for c in sudoku_cols(sudoku)]
    sqrs = [set(s) for s in sudoku_sqrs(sudoku)]
    while True:
        if sudoku[constants[-1][0]][constants[-1][1]] != 0:
            return sudoku
        i, j = sudoku_next_empty(sudoku, constants)
        sudoku[i][j] = 1
        while (sudoku[i][j] in rows[i] or
               sudoku[i][j] in cols[j] or
               sudoku[i][j] in sqrs[row_col_to_sqr(i,j)]):
            if sudoku[i][j] == 9:
                sudoku[i][j] = 0
                i, j = sudoku_previous_empty(sudoku, constants)
                while sudoku[i][j] == 9:
                    rows[i].discard(sudoku[i][j])
                    cols[j].discard(sudoku[i][j])
                    sqrs[row_col_to_sqr(i,j)].discard(sudoku[i][j])
                    sudoku[i][j] = 0
                    i, j = sudoku_previous_empty(sudoku, constants)
                rows[i].discard(sudoku[i][j])
                cols[j].discard(sudoku[i][j])
                sqrs[row_col_to_sqr(i,j)].discard(sudoku[i][j])
            sudoku[i][j] += 1
        rows[i].add(sudoku[i][j])
        cols[j].add(sudoku[i][j])
        sqrs[row_col_to_sqr(i,j)].add(sudoku[i][j])
    return None

sudoku_fmt = \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n"

def sudoku_to_str(sudoku):
    return sudoku_fmt.format(*[x if x != 0 else " " for r in sudoku for x in r])

def parse_sudoku(s):
    return [[0 if s[i*9+j] == '.' else int(s[i*9+j]) for j in range(9)] for i in range(9)]

if __name__ == '__main__':
    #start = time.clock()
    #print sudoku_solve(sudoku_puzzle)
    #t = time.clock()-start
    #print t
    #start = time.clock()
    #print sudoku_solve_slower(sudoku_puzzle2)
    #t = time.clock()-start
    #print t

    sudoku_puzzle = parse_sudoku('.....6....59.....82....8....45........3........6..3.54...325..6..................')
    start = time.clock()
    print sudoku_solve(sudoku_puzzle)
    t = time.clock()-start
    print t

    #s =  sudoku_next(sudoku_puzzle)
    #print sudoku_to_str(sudoku_puzzle)
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
#    print sudoku_to_str(sudoku_solve(sudoku))
