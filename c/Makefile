.DEFAULT_GOAL = sudoku

sudoku:
	gcc -funroll-loops -O3 -std=c99 -Wall -Wextra -o ./sudoku_0 sudoku_0.c
	./sudoku_0 ../inputs/only_hard.txt

sudoku_1:
	# https://stackoverflow.com/questions/3099813/how-to-enforce-c89-style-variable-declarations-in-gcc
	# Be super extra pedantic about c89 style
	gcc -O3 -std=c89 -Wpedantic -Wall -Wextra \
		-Wstrict-prototypes \
		-Wold-style-definition \
		-Wmissing-prototypes \
		-Wmissing-declarations \
		-Wdeclaration-after-statement \
		-o sudoku_1 sudoku_1.c
	time ./sudoku_1

sudoku_optimized:
	gcc -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o bin/sudoku_optimized sudoku_optimized.c
	./bin/sudoku_optimized

sudoku_parallel:
	gcc -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o bin/sudoku_parallel sudoku_parallel.c
	./bin/sudoku_parallel
