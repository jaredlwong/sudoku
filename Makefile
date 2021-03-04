rust-compose:
	docker-compose up --detach --build sudoku-rust

rust-exec:
	docker-compose exec sudoku-rust /bin/bash

go-compose:
	docker-compose up --detach --build sudoku-go

go-exec:
	docker-compose exec sudoku-go /bin/bash

node-compose:
	docker-compose up --detach --build sudoku-node

node-exec:
	docker-compose exec sudoku-node /bin/bash

haskell-compose:
	docker-compose up --detach --build sudoku-haskell

haskell-exec:
	docker-compose exec sudoku-haskell /bin/bash

elixir-compose:
	docker-compose up --detach --build sudoku-elixir

elixir-exec:
	docker-compose exec sudoku-elixir /bin/bash

c-compose:
	docker-compose up --detach --build sudoku-c

c-exec:
	docker-compose exec sudoku-c /bin/bash

python-compose:
	docker-compose up --detach --build sudoku-python

python-exec:
	docker-compose exec sudoku-python /bin/bash

stop:
	docker-compose stop
