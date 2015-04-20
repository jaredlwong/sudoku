#include "string.h"
#include "stdio.h"
#include "stdlib.h"

typedef int board_t[9][9];

typedef struct list {
	board_t *board;
	struct list *next;
} list_t;

/*board_t sudoku = {
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
*/

board_t sudoku = {
	{0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,3,0,8,5},
	{0,0,1,0,2,0,0,0,0},
	{0,0,0,5,0,7,0,0,0},
	{0,0,4,0,0,0,1,0,0},
	{0,9,0,0,0,0,0,0,0},
	{5,0,0,0,0,0,0,7,3},
	{0,0,2,0,1,0,0,0,0},
	{0,0,0,0,4,0,0,0,9}
};

void print_board(board_t *board) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			printf("%d", (*board)[i][j]);
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

int sudoku_complete(board_t *board) {
	int i, j;
	for (i = 0; i < 9; ++i) {
		for (j = 0; j < 9; ++j) {
			if ((*board)[i][j] == 0) {
				return 0;
			}
		}
	}
	return 1;
}

void sudoku_next_empty(board_t *board, int *r, int *c) {
	for (*r = 0; *r < 9; ++*r) {
		for (*c = 0; *c < 9; ++*c) {
			if ((*board)[*r][*c] == 0) {
				return;
			}
		}
	}
}

void sudoku_gen_next_boards(board_t *board, list_t **head, list_t **tail) {
	int i, r, c;
	list_t *list = 0;
	list_t *head_list = 0;
	sudoku_next_empty(board, &r, &c);
	for (i = 1; i <= 9; ++i) {
		board_t *new_board;
		list_t *n;

		new_board = malloc(sizeof(board_t));
		memcpy(new_board, board, sizeof(board_t));
		(*new_board)[r][c] = i;

		n = malloc(sizeof(list_t));
		n->board = new_board;
		n->next = 0;

		if (head_list == 0) {
			head_list = n;
		}
		if (list != 0) {
			list->next = n;
		}
		list = n;
	}
	*head = head_list;
	*tail = list;
}

board_t *solve_sudoku(board_t *board) {
	list_t *queue = malloc(sizeof(list_t));
	queue->board = board;
	queue->next = 0;

	for (; queue != 0; ) {
		board_t *cur_board;
		list_t *cur_node;
		list_t *head, *tail;

		cur_board = queue->board;
		cur_node = queue;
		queue = cur_node->next;

		/* if not possible, move on */
		if (!sudoku_possible(cur_board)) {
			continue;
		}

		/* if possible and complete, free everything and return */
		if (sudoku_complete(cur_board)) {
			for (;queue != 0;) {
				list_t *old = queue;
				queue = old->next;
				free(old->board);
				free(old);
			}
			return cur_board;
		}

		/* attach new boards at beginning of queue */
		sudoku_gen_next_boards(cur_board, &head, &tail);
		tail->next = queue;
		queue = head;

		free(cur_node);
		/* don't free board passed in as arg */
		if (cur_board != board) {
			free(cur_board);
		}
	}
	return 0;
}

int main(void)
{
	board_t *board, *soln;

	/* need it to be malloced so freeing is easier */
	board = malloc(sizeof(board_t));
	memcpy(board, &sudoku, sizeof(board_t));

	soln = solve_sudoku(board);
	print_board(soln);

	free(board);
	free(soln);
	return 0;
}
