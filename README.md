Sudoku Solver
=============

Sudoku solver in various languages.

All of them follow the same general plan:
- gather rows, columns, and squares
- check if a row/column/square is valid
- check if a sudoku is completely filled in
- find the next empty space
- generate new copies of the sudoku puzzle with the next empty space filled in
  with 1 to 9
- add the next sudoku steps to our queue

Scheme
------
http://srfi.schemers.org/final-srfis.html


docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/scipy-notebook
