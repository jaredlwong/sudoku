/*
 * https://en.wikipedia.org/wiki/ANSI_C
 * https://en.wikipedia.org/wiki/C_(programming_language)#K&R_C
 *
 * This whole file is super extra with ansi-c sytle coding. All options to gcc are enabled, see the Makefile.
 * Use simple recursion with updating a board in place, tends to be the fastest implementation.
 */

#include "string.h"
#include "stdio.h"
#include "stdlib.h"

typedef int board_t[9][9];

/* -Wstrict-prototypes enforced be super extra */
void print_board(board_t *);
int sudoku_is_valid(board_t *);
void sudoku_next_empty(board_t *, int *, int *);
int solve_sudoku(board_t *);


void print_board(board_t *board) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			printf("%d", (*board)[i][j]);
		}
	}
	printf("\n");
}

int sudoku_is_valid(board_t *board) {
	int i, j, k, l;
	/* 0-9 possible */
	int seen[10];

	/* check rows */
	for (i = 0; i < 9; ++i) {
		memset(seen, 0, sizeof(seen));
		for (j = 0; j < 9; ++j) {
			if ((*board)[i][j] > 0 && ++seen[(*board)[i][j]] > 1) {
				return 0;
			}
		}
	}

	/* check cols */
	for (i = 0; i < 9; ++i) {
		memset(seen, 0, sizeof(seen));
		for (j = 0; j < 9; ++j) {
			if ((*board)[j][i] > 0 && ++seen[(*board)[j][i]] > 1) {
				return 0;
			}
		}
	}

	/* check sqrs */
	for (i = 0; i < 3; ++i) {
		for (j = 0; j < 3; ++j) {
			memset(seen, 0, sizeof(seen));
			for (k = i * 3; k < i * 3 + 3; ++k) {
				for (l = j * 3; l < j * 3 + 3; ++l) {
					if ((*board)[k][l] > 0 && ++seen[(*board)[k][l]] > 1) {
						return 0;
					}
				}
			}
		}
	}

	return 1;
}

/* need to use pointers to return (r, c) since there are no "tuples" in c */
void sudoku_next_empty(board_t *board, int *r, int *c) {
	for (*r = 0; *r < 9; ++*r) {
		for (*c = 0; *c < 9; ++*c) {
			if ((*board)[*r][*c] == 0) {
				return;
			}
		}
	}
	/* remember to return -1, -1 if the board is complete */
	*r = -1;
	*c = -1;
}

int solve_sudoku(board_t *board) {
	/* r = row, c = col, v = value, result is intermediate */
	int r, c, v, result;

	/* in proper ansi-c we declare variables separate from assignment */
	r = -1;
	c = -1;

	if (!sudoku_is_valid(board)) {
		return 0;
	}
	sudoku_next_empty(board, &r, &c);
	/* if complete */
	if (r < 0 && c < 0) {
		return 1;
	}
	for (v = 1; v <= 9; ++v) {
		(*board)[r][c] = v;
		result = solve_sudoku(board);
		if (result) {
			return 1;
		}
		(*board)[r][c] = 0;
	}
	return 0;
}

int main(void)
{
	board_t sudoku = {
		{8, 0, 1, 3, 4, 0, 0, 0, 0},
		{4, 3, 0, 8, 0, 0, 1, 0, 7},
		{0, 0, 0, 0, 6, 0, 0, 0, 3},
		{2, 0, 8, 0, 5, 0, 0, 0, 9},
		{0, 0, 9, 0, 0, 0, 7, 0, 0},
		{6, 0, 0, 0, 7, 0, 8, 0, 4},
		{3, 0, 0, 0, 1, 0, 0, 0, 0},
		{1, 0, 5, 0, 0, 6, 0, 4, 2},
		{0, 0, 0, 0, 2, 4, 3, 0, 8}
	};

/* this board is impossible */
/* board_t sudoku = { */
/* 	{0,0,0,0,0,0,0,0,0}, */
/* 	{0,0,0,0,0,3,0,8,5}, */
/* 	{0,0,1,0,2,0,0,0,0}, */
/* 	{0,0,0,5,0,7,0,0,0}, */
/* 	{0,0,4,0,0,0,1,0,0}, */
/* 	{0,9,0,0,0,0,0,0,0}, */
/* 	{5,0,0,0,0,0,0,7,3}, */
/* 	{0,0,2,0,1,0,0,0,0}, */
/* 	{0,0,0,0,4,0,0,0,9} */
/* }; */

	board_t *board;

	/* need it to be malloced so freeing is easier */
	board = malloc(sizeof(board_t));
	memcpy(board, &sudoku, sizeof(board_t));
	print_board(board);

	solve_sudoku(board);
	print_board(board);

	free(board);
	return 0;
}
