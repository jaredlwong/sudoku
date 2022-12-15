.DEFAULT_GOAL = run

run:
	ghc-9.2 sudoku_simple.hs
	./sudoku_simple ../inputs/only_hard.txt

build:
	ghc -o sudoku sudoku.hs

build_better:
	ghc -o sudoku_better sudoku-better.hs

run_better:
	./sudoku_better
