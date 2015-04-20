typedef unsigned char uint8_t;

#define GET(ARRAY, I, J) ((ARRAY)[(I)*9+(J)])
#define SET(ARRAY, I, J, V) ((ARRAY)[(I)*9+(J)] = (V))
#define INDEX2I(INDEX) ((INDEX)/9)
#define INDEX2J(INDEX) ((INDEX)%9)
#define IJ2INDEX(I, J) (((I)/3)*3+((J)/3))

/* return number of constants in array */
int sudoku_constants(uint8_t *board, uint8_t *constants) {
	int i, c = 0;
	for (i = 0; i < 81; ++i) {
		if (board[i] != 0) {
			constants[c++] = i;
		}
	}
	return c;
}

void sudoku_rows(uint8_t *sudoku, uint8_t *rows) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			if (GET(sudoku, i, j) > 0) {
				SET(rows, i, GET(sudoku, i, j)-1, 1);
			}
		}
	}
}

void sudoku_cols(uint8_t *sudoku, uint8_t *cols) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			if (GET(sudoku, j, i) > 0) {
				SET(cols, i, GET(sudoku, j, i)-1, 1);
			}
		}
	}
}

void sudoku_sqrs(uint8_t *sudoku, uint8_t *sqrs) {
	int i, j, k, l;
	for (i = 0; i < 3; ++i) {
		for (j = 0; j < 3; ++j) {
			for (k = i*3; k < i*3+3; ++k) {
				for (l = j*3; l < j*3+3; ++l) {
					if (GET(sudoku, k, l) > 0) {
						SET(sqrs, IJ2INDEX(k, l), GET(sudoku, k, l)-1, 1);
					}
				}
			}
		}
	}
}

int sudoku_solve(uint8_t *sudoku) {
	uint8_t constants[81] = {0};
	uint8_t rows[81] = {0};
	uint8_t cols[81] = {0};
	uint8_t sqrs[81] = {0};
	int cur_const = 0;
	int num_consts;
	int i, j;

	num_const = sudoku_constants(sudoku, constants);
	sudoku_rows(sudoku, rows);
	sudoku_cols(sudoku, cols);
	sudoku_sqrs(sudoku, sqrs);

	for (;;) {
		if (sudoku[constants[num_const-1]] != 0) {
			return 1;
		}
		i = INDEX2I(constants[cur_const]);
		j = INDEX2J(constants[cur_const]);
		GET(sudoku, i, j) = 1;
		while (GET(rows, i, GET(sudoku, i, j)-1) ||
		       GET(cols, j, GET(sudoku, i, j)-1) ||
		       GET(sqrs, IJ2INDEX(i, j), GET(sudoku, i, j)-1)) {
			if (GET(sudoku, i, j) == 9) {

			}
			SET(sudoku, i, j, GET(sudoku, i, j)+1;
		}
	}
    while True:
        if sudoku[constants[-1][0]][constants[-1][1]] != 0:
            return sudoku
        i, j = constants[curconst]
        sudoku[i][j] = 1
        while (rows[i][sudoku[i][j]-1] or
               cols[j][sudoku[i][j]-1] or
               sqrs[IJ2INDEX(i,j)][sudoku[i][j]-1]):
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
    return 0;
}

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
