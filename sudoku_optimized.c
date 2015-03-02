#include "string.h"
#include "stdio.h"

typedef unsigned char board_t[81];

#define BOARD_GET(BOARD, R, C) ((BOARD)[(R)*9+(C)])
#define BOARD_SET(BOARD, R, C, V) ((BOARD)[(R)*9+(C)] = (V))

board_t sudoku = {
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

void print_board(board_t *board) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			printf("%d", BOARD_GET((*board), i, j));
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

int sudoku_possible(board_t *board) {
	int g, i, j, k, l, sum;

	/* 27 rows/cols/sqrs X 0-9 possible values */
	unsigned char seen[27][10] = {{0}};
	g = 0;

	for (i = 0; i < 9; ++i, ++g) {
		for (j = 0; j < 9; ++j) {
			++seen[g][BOARD_GET((*board), i, j)];
		}
	}

	for (i = 0; i < 9; ++i, ++g) {
		for (j = 0; j < 9; ++j) {
			++seen[g][BOARD_GET((*board), j, i)];
		}
	}

	for (i = 0; i < 3; ++i) {
		for (j = 0; j < 3; ++j, ++g) {
			for (k = i*3; k < i*3+3; ++k) {
				for (l = j*3; l < j*3+3; ++l) {
					++seen[g][BOARD_GET((*board), k, l)];
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

int sudoku_complete(board_t *board) {
	int i, j, sum;
	sum = 0;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			sum += (BOARD_GET((*board), i, j) == 0);
		}
	}
	return sum == 0;
}

void sudoku_next_empty(board_t *board, int *r, int *c) {
	for (*r = 0; *r < 9; ++*r) {
		for (*c = 0; *c < 9; ++*c) {
			if (BOARD_GET((*board), *r, *c) == 0) {
				return;
			}
		}
	}
}

board_t *solve_sudoku(board_t *board) {
	int i, r, c;

	/* if not possible, return 0 */
	if (!sudoku_possible(board)) {
		return 0;
	}

	/* if possible and complete, return */
	if (sudoku_complete(board)) {
		return board;
	}

	/* sudoku_gen_next_boards(cur_board, &head, &tail); */
	sudoku_next_empty(board, &r, &c);
	for (i = 1; i <= 9; ++i) {
		board_t new_board, *soln_board;
		memcpy(new_board, board, sizeof(board_t));
		BOARD_SET(new_board, r, c, i);
		soln_board = solve_sudoku(&new_board);
		if (soln_board != 0) {
			return soln_board;
		}
	}

	return 0;
}

int main(void)
{
	board_t *soln = solve_sudoku(&sudoku);
	print_board(soln);

	return 0;
}
