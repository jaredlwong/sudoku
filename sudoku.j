NB. 9x9 sudoku puzzle
S =: 9 9 $ 8 0 1 3 4 0 0 0 0 4 3 0 8 0 0 1 0 7 0 0 0 0 6 0 0 0 3 2 0 8 0 5 0 0 0 9 0 0 9 0 0 0 7 0 0 6 0 0 0 7 0 8 0 4 3 0 0 0 1 0 0 0 0 1 0 5 0 0 6 0 4 2 0 0 0 0 2 4 3 0 8

NB. i. is iota
NB. { is from
NB. rows
rs =: monad : '(i. 9) { y' "2

NB. columns
cs =: monad : '(i.9) { |: y' "2

NB. remove 0s, test for dups, find the min
NB. 0 if not okay 1 if okay
nodups =: monad : '<./ ~: y -. 0' "1

S {"_ 1 ]
