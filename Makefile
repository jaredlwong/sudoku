c:
	gcc-4.8 -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku.c
	./sudoku

c-optimized:
	gcc-4.8 -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku_optimized.c
	./sudoku

go:
	go run sudoku.go

haskell:
	ghc -o sudoku sudoku.hs
	./sudoku

java:
	javac -Xlint:unchecked Sudoku.java
	java Sudoku

scheme:
	mit-scheme --batch-mode < sudoku.scm

python:
	python sudoku.py
