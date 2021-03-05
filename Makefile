rust-compose:
	docker-compose up --detach --build rust

rust-exec:
	docker-compose exec rust /bin/bash

go-compose:
	docker-compose up --detach --build go

go-exec:
	docker-compose exec go /bin/bash

node-compose:
	docker-compose up --detach --build node

node-exec:
	docker-compose exec node /bin/bash

haskell-compose:
	docker-compose up --detach --build haskell

haskell-exec:
	docker-compose exec haskell /bin/bash

elixir-compose:
	docker-compose up --detach --build elixir

elixir-exec:
	docker-compose exec elixir /bin/bash

c-compose:
	docker-compose up --detach --build c

c-exec:
	docker-compose exec c /bin/bash

python-compose:
	docker-compose up --detach --build python

python-exec:
	docker-compose exec python /bin/bash

ocaml-compose:
	docker-compose up --detach --build ocaml

ocaml-exec:
	docker-compose exec ocaml /bin/bash

stop:
	docker-compose stop
