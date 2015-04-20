mother(maritza, jared).

father(ulysses, jared).

child(X, Y) :- mother(Y, X).
child(X, Y) :- father(Y, X).
