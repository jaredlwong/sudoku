import time

sudoku_puzzle = [
[8,0,1, 3,4,0,0,0,0],
[4,3,0, 8,0,0,1,0,7],
[0,0,0, 0,6,0,0,0,3],
[2,0,8,0,5,0,0,0,9],
[0,0,9,0,0,0,7,0,0],
[6,0,0,0,7,0,8,0,4],
[3,0,0,0,1,0,0,0,0],
[1,0,5,0,0,6,0,4,2],
[0,0,0,0,2,4,3,0,8]]

def row_col_to_sqr(row, col):
    return (row/3)*3+(col/3)

def sudoku_constants(sudoku):
    constants = []
    for i, row in enumerate(sudoku):
        for j, e in enumerate(row):
            if e == 0:
                constants.append((i,j))
    return constants

def sudoku_rowsx(sudoku, rows):
    for i in range(9):
        for j in range(9):
            if sudoku[i][j] > 0:
                rows[i][sudoku[i][j]-1] = True

def sudoku_colsx(sudoku, cols):
    for i in range(9):
        for j in range(9):
            if sudoku[j][i] > 0:
                cols[i][sudoku[j][i]-1] = True

def sudoku_sqrsx(sudoku, sqrs):
    for i in range(3):
        for j in range(3):
            for k in range(i*3,i*3+3):
                for l in range(j*3,j*3+3):
                    if sudoku[k][l] > 0:
                        sqrs[row_col_to_sqr(k,l)][sudoku[k][l]-1] = True

def print_sudoku(sudoku):
    print ''.join('.' if e == 0 else str(e) for row in sudoku for e in row)

def sudoku_solve(sudoku):
    constants = sudoku_constants(sudoku)
    rows = [[False]*9 for _ in range(9)]
    cols = [[False]*9 for _ in range(9)]
    sqrs = [[False]*9 for _ in range(9)]
    sudoku_rowsx(sudoku, rows)
    sudoku_colsx(sudoku, cols)
    sudoku_sqrsx(sudoku, sqrs)
    curconst = 0
    while True:
        if sudoku[constants[-1][0]][constants[-1][1]] != 0:
            return sudoku
        i, j = constants[curconst]
        sudoku[i][j] = 1
        while (rows[i][sudoku[i][j]-1] or
               cols[j][sudoku[i][j]-1] or
               sqrs[row_col_to_sqr(i,j)][sudoku[i][j]-1]):
            if sudoku[i][j] == 9:
                sudoku[i][j] = 0
                curconst -= 1
                i, j = constants[curconst]
                while sudoku[i][j] == 9:
                    rows[i][sudoku[i][j]-1] = False
                    cols[j][sudoku[i][j]-1] = False
                    sqrs[row_col_to_sqr(i,j)][sudoku[i][j]-1] = False
                    sudoku[i][j] = 0
                    curconst -= 1
                    i, j = constants[curconst]
                rows[i][sudoku[i][j]-1] = False
                cols[j][sudoku[i][j]-1] = False
                sqrs[row_col_to_sqr(i,j)][sudoku[i][j]-1] = False
            sudoku[i][j] += 1
        rows[i][sudoku[i][j]-1] = True
        cols[j][sudoku[i][j]-1] = True
        sqrs[row_col_to_sqr(i,j)][sudoku[i][j]-1] = True
        curconst += 1
    return None

def parse_sudoku(s):
    return [[0 if s[i*9+j] == '.' else int(s[i*9+j]) for j in range(9)] for i in range(9)]


if __name__ == '__main__':
    #print sudoku_puzzle
    #print sudoku_rows(sudoku_puzzle)
    #print sudoku_rowsx(sudoku_puzzle)
    #print sudoku_cols(sudoku_puzzle)
    #print sudoku_colsx(sudoku_puzzle)
    #print sudoku_sqrsx(sudoku_puzzle)
    sudoku_puzzle = parse_sudoku('.....6....59.....82....8....45........3........6..3.54...325..6..................')
    start = time.clock()
    print sudoku_solve(sudoku_puzzle)
    t = time.clock()-start
    print t
