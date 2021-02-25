#include "stdio.h"

typedef unsigned char uint8_t;

#define GET(ARRAY, I, J) ((ARRAY)[(I)*9+(J)])
#define SET(ARRAY, I, J, V) ((ARRAY)[(I)*9+(J)] = (V))
#define INDEX2I(INDEX) ((INDEX)/9)
#define INDEX2J(INDEX) ((INDEX)%9)
#define IJ2INDEX(I, J) (((I)/3)*3+((J)/3))

void parse_sudoku(char *str_rep, uint8_t *sudoku) {
	int i;
	for (i = 0; i < 81; ++i) {
		if (str_rep[i] == '.') {
			sudoku[i] = 0;
		} else {
			sudoku[i] = str_rep[i] - '0';
		}
	}
}

void print_sudoku(uint8_t *sudoku) {
	int i;
	for (i = 0; i < 81; ++i) {
		if (sudoku[i] == 0) {
			printf(".");
		} else {
			printf("%d", sudoku[i]);
		}
	}
	printf("\n");
}

/* return number of constants in array */
int sudoku_constants(uint8_t *board, uint8_t *constants) {
	int i, c = 0;
	for (i = 0; i < 81; ++i) {
		if (board[i] == 0) {
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

	num_consts = sudoku_constants(sudoku, constants);
	sudoku_rows(sudoku, rows);
	sudoku_cols(sudoku, cols);
	sudoku_sqrs(sudoku, sqrs);

	for (;;) {
		if (sudoku[constants[num_consts-1]] != 0) {
			return 1;
		}
		i = INDEX2I(constants[cur_const]);
		j = INDEX2J(constants[cur_const]);
		SET(sudoku, i, j, 1);
		while (GET(rows, i, GET(sudoku, i, j)-1) ||
		       GET(cols, j, GET(sudoku, i, j)-1) ||
		       GET(sqrs, IJ2INDEX(i, j), GET(sudoku, i, j)-1)) {
			if (GET(sudoku, i, j) == 9) {
				SET(sudoku, i, j, 0);
				cur_const--;
				i = INDEX2I(constants[cur_const]);
				j = INDEX2J(constants[cur_const]);
				while (GET(sudoku, i, j) == 9) {
					SET(rows, i, GET(sudoku, i, j)-1, 0);
					SET(cols, j, GET(sudoku, i, j)-1, 0);
					SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 0);
					SET(sudoku, i, j, 0);
					cur_const--;
					i = INDEX2I(constants[cur_const]);
					j = INDEX2J(constants[cur_const]);
				}
				SET(rows, i, GET(sudoku, i, j)-1, 0);
				SET(cols, j, GET(sudoku, i, j)-1, 0);
				SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 0);
			}
			SET(sudoku, i, j, GET(sudoku, i, j)+1);
		}
		SET(rows, i, GET(sudoku, i, j)-1, 1);
		SET(cols, j, GET(sudoku, i, j)-1, 1);
		SET(sqrs, IJ2INDEX(i,j), GET(sudoku, i, j)-1, 1);
		cur_const++;
	}
	return 0;
}

int main(int argc, char **argv) {
	/* char strrep[81] = ".....6....59.....82....8....45........3........6..3.54...325..6..................";*/
	char *strrep = argv[1];
	uint8_t sudoku[81] = {0};
	parse_sudoku(strrep, sudoku);
	sudoku_solve(sudoku);
	print_sudoku(sudoku);
	return 0;
}

/*
    sudoku_puzzle = parse_sudoku()
    start = time.clock()
    print sudoku_solve(sudoku_puzzle)
    t = time.clock()-start
    print t
    */
