haskell:
	ghc -o sudoku sudoku.hs
	./sudoku

sceme:
	mit-scheme --batch-mode < sudoku.scm

c:
	gcc-4.8 -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku.c
	./sudoku

python:
	python sudoku.py
