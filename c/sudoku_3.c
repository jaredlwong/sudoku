#include "string.h"
#include "stdio.h"

/*
 * i don't think i ever got anywhere with this version, it's supposed to be 'optimized'
 */

typedef unsigned char uint8_t;

#define BOARD_GET(BOARD, R, C) ((BOARD)[(R)*9+(C)])
#define BOARD_SET(BOARD, R, C, V) ((BOARD)[(R)*9+(C)] = (V))

/*
uint8_t sudoku = {
	8, 0, 1, 3, 4, 0, 0, 0, 0,
	4, 3, 0, 8, 0, 0, 1, 0, 7,
	0, 0, 0, 0, 6, 0, 0, 0, 3,
	2, 0, 8, 0, 5, 0, 0, 0, 9,
	0, 0, 9, 0, 0, 0, 7, 0, 0,
	6, 0, 0, 0, 7, 0, 8, 0, 4,
	3, 0, 0, 0, 1, 0, 0, 0, 0,
	1, 0, 5, 0, 0, 6, 0, 4, 2,
	0, 0, 0, 0, 2, 4, 3, 0, 8
};
*/

/*
uint8_t sudoku = {8,0,1,3,4,0,0,0,0,4,3,0,8,0,0,1,0,7,0,0,0,0,6,0,0,0,3,2,0,8,0,5,0,0,0,9,0,0,9,0,0,0,7,0,0,6,0,0,0,7,0,8,0,4,3,0,0,0,1,0,0,0,0,1,0,5,0,0,6,0,4,2,0,0,0,0,2,4,3,0,8};
*/


void print_board(uint8_t *board) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			printf("%d", BOARD_GET(board, i, j));
			if (j == 2 || j == 5) {
				printf(" | ");
			} else if (j < 8) {
				printf(" ");
			} else {
				printf("\n");
			}
		}
		if (i == 2 || i == 5) {
			printf("---------------------\n");
		}
	}
}

int sudoku_possible(uint8_t *board) {
	int g, i, j, k, l, sum;

	/* 27 rows/cols/sqrs X 0-9 possible values */
	unsigned char seen[27][10] = {{0}};
	g = 0;

	for (i = 0; i < 9; ++i, ++g) {
		for (j = 0; j < 9; ++j) {
			++seen[g][BOARD_GET(board, i, j)];
		}
	}

	for (i = 0; i < 9; ++i, ++g) {
		for (j = 0; j < 9; ++j) {
			++seen[g][BOARD_GET(board, j, i)];
		}
	}

	for (i = 0; i < 3; ++i) {
		for (j = 0; j < 3; ++j, ++g) {
			for (k = i*3; k < i*3+3; ++k) {
				for (l = j*3; l < j*3+3; ++l) {
					++seen[g][BOARD_GET(board, k, l)];
				}
			}
		}
	}

	sum = 0;
	for (i = 0; i < 27; ++i) {
		for (j = 1; j < 10; ++j) {
			sum += (seen[i][j] > 1);
		}
	}
	return sum == 0;
}

int sudoku_complete(uint8_t *board) {
	int i, j, sum;
	sum = 0;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			sum += (BOARD_GET(board, i, j) == 0);
		}
	}
	return sum == 0;
}

void sudoku_constants(uint8_t *board, int constants[81]) {
	int i;
	for (i = 0; i < 81; ++i) {
		constants[i] = (board[i] != 0);
	}
}

int sudoku_next_empty(uint8_t *board, int constants[81]) {
	int i;
	for (i = 0; i < 81; ++i) {
		if (!constants[i] && board[i] == 0) {
			return i;
		}
	}
	return -1;
}

int sudoku_previous_empty(uint8_t *board, int constants[81]) {
	int i;
	for (i = 80; i >= 0; --i) {
		if (!constants[i] && board[i] != 0) {
			return i;
		}
	}
	return -1;
}

int solve_sudoku(uint8_t *board) {
	int i;
	int constants[81];

	sudoku_constants(board, constants);

	for (;;) {
		if (sudoku_complete(board)) {
			return 1;
		}
		if (sudoku_possible(board)) {
			i = sudoku_next_empty(board, constants);
			board[i] = 1;
		} else {
			i = sudoku_previous_empty(board, constants);
			while (board[i] == 9) {
				board[i] = 0;
				i = sudoku_previous_empty(board, constants);
			}
			board[i]++;
		}
	}
	return 0;
}

int main(void)
{
	uint8_t sudoku[81] = {0,0,0,0,0,6,0,0,0,0,5,9,0,0,0,0,0,8,2,0,0,0,0,8,0,0,0,0,4,5,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,6,0,0,3,0,5,4,0,0,0,3,2,5,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	solve_sudoku(sudoku);
	print_board(sudoku);

	return 0;
}
