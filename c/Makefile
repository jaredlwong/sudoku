bin:
	mkdir bin

sudoku: bin
	# https://stackoverflow.com/questions/3099813/how-to-enforce-c89-style-variable-declarations-in-gcc
	# Be super extra pedantic about c89 style
	gcc -O3 -std=c89 -Wpedantic -Wall -Wextra \
		-Wstrict-prototypes \
		-Wold-style-definition \
		-Wmissing-prototypes \
		-Wmissing-declarations \
		-Wdeclaration-after-statement \
		-o bin/sudoku sudoku.c
	./bin/sudoku

sudoku_optimized: bin
	gcc -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o bin/sudoku_optimized sudoku_optimized.c
	./bin/sudoku_optimized

sudoku_fast: bin
	gcc -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o bin/sudoku_fast sudoku_fast.c
	./bin/sudoku_fast

sudoku_parallel: bin
	gcc -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o bin/sudoku_parallel sudoku_parallel.c
	./bin/sudoku_parallel
