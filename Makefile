c-optimized:
	gcc-4.8 -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku_optimized.c
#	gcc-4.8 -g -S -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku_optimized.c

haskell:
	ghc -o sudoku sudoku.hs

scheme:
	mit-scheme --batch-mode < sudoku.scm

c:
	gcc-4.8 -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku.c
	./sudoku

python:
	python sudoku.py
