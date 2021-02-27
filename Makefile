cpp:
	g++-4.8 -std=gnu++11 sudoku.cpp -o sudoku
	./sudoku

xxx:
	/usr/local/jgplsrc/j/bin/jconsole < hj.j

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

rust-compose:
	docker-compose up --detach --build sudoku-rust

rust-exec:
	docker-compose exec sudoku-rust /bin/bash

c-compose:
	docker-compose up --detach --build sudoku-c

c-exec:
	docker-compose exec sudoku-c /bin/bash

go-compose:
	docker-compose up --detach --build sudoku-go

go-exec:
	docker-compose exec sudoku-go /bin/bash

node-compose:
	docker-compose up --detach --build sudoku-node

node-exec:
	docker-compose exec sudoku-node /bin/bash
