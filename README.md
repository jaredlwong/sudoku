Sudoku Solver
=============

Rosetta stone using sudoku solver as the example

All are launched via docker-compose and run within a docker container

Trying to learn how to do both of these things in many different language paradigms
- set up each language in ubuntu
- how to code a sudoku solver

All of them follow the same general plan:
- gather rows, columns, and squares
- check if a row/column/square is valid
- check if a sudoku is completely filled in
- find the next empty space
- generate new copies of the sudoku puzzle with the next empty space filled in
  with 1 to 9
- add the next sudoku steps to our queue
