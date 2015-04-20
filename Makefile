cpp:
	g++-4.8 -std=gnu++11 sudoku.cpp -o sudoku
	./sudoku

xxx:
	/usr/local/jgplsrc/j/bin/jconsole < hj.j

c:
	gcc-4.8 -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku.c
	./sudoku

c-optimized:
	gcc-4.8 -funroll-loops -O3 -std=c89 -Wpedantic -Wall -Wextra -o sudoku sudoku_optimized.c

go:
	go run sudoku.go

haskell:
	ghc -o sudoku sudoku.hs
	./sudoku

j:
	/usr/local/jgplsrc/j/bin/jconsole < sudoku.j

java:
	javac -Xlint:unchecked Sudoku.java
	java Sudoku

scheme:
	mit-scheme --batch-mode < sudoku.scm

python:
	python sudoku.py tests/test1.txt
