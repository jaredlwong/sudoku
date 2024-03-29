#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/*
 * this is a fast sudoku solver. it is my reference implementation for other
 * fast solvers. the main improvement is doing some complicated scheme to keep
 * track of the valid states.
 */

typedef unsigned char uint8_t;

#define GET(ARRAY, I, J) ((ARRAY)[(I)*9+(J)])
#define SET(ARRAY, I, J, V) ((ARRAY)[(I)*9+(J)] = (V))
#define INDEX2I(INDEX) ((INDEX)/9)
#define INDEX2J(INDEX) ((INDEX)%9)
#define IJ2INDEX(I, J) (((I)/3)*3+((J)/3))

void parse_sudoku(char *str_rep, unsigned char* sudoku) {
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

void sudoku_to_string(uint8_t *sudoku, char *str_rep) {
	int i;
	for (i = 0; i < 81; ++i) {
		if (sudoku[i] == 0) {
			str_rep[i] = '.';
		} else {
			str_rep[i] = sudoku[i] + '0';
		}
	}
	str_rep[81] = '\0';
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

#define MAX_LINE_LENGTH 1024 // Maximum length of a line in the input file

int main(int argc, char *argv[]) {
    // Check if a filename was provided as an argument
    if (argc != 2) {
        printf("Error: missing filename\n");
        return 1;
    }

    // Open the file for reading
    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error: unable to open file '%s'\n", argv[1]);
        return 1;
    }

  	// Allocate memory for the string array
	char** lines = malloc(sizeof(char *) * 1);

    // Read the file line by line
    char line[MAX_LINE_LENGTH];
    int num_lines = 0;
    while (fgets(line, MAX_LINE_LENGTH, file)) {
        // Remove the newline character from the end of the line
        int len = strlen(line);
        if (len > 0 && line[len - 1] == '\n') {
            line[len - 1] = '\0';
        }

    	// Allocate memory for the line and copy it to the string array
    	lines[num_lines] = (char *) malloc(len + 1);
    	strcpy(lines[num_lines], line);
    	num_lines++;

    	// Reallocate memory for the string array
    	lines = realloc(lines, (num_lines + 1) * sizeof(char *));
    }

    // Close the file
    fclose(file);

    // Print the array of strings
    for (int i = 0; i < num_lines; i += 2) {
		char *input = lines[i];
		char *expected = lines[i+1];

		clock_t start = clock();
		uint8_t sudoku[81] = {0};
		char output[82] = {0};
		parse_sudoku(input, sudoku);
		sudoku_solve(sudoku);
		sudoku_to_string(sudoku, output);
		clock_t end = clock();
		double elapsed_time = 1000 * (end - start) / (double) CLOCKS_PER_SEC;
		if (strcmp(expected, output) == 0) {
			printf("Solved sudoku %s in %f ms\n", input, elapsed_time);
		} else {
			printf("Failed to solve sudoku %s. Expected %s, got %s\n", input, expected, output);
		}
	}

	return 0;
}