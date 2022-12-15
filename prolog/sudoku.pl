% Parse a string of numbers and dots to a Sudoku puzzle
parse_sudoku(String, Puzzle) :-
    string_chars(String, Chars), % Convert the string to a list of characters
    maplist(char_to_digit, Chars, Digits), % Convert each character to a digit
    maplist(digit_to_int, Digits, Puzzle). % Convert each digit to an integer

% Convert a character to a digit (0-9 or . for empty cells)
char_to_digit(Char, Digit) :-
    (   char_type(Char, digit(Digit0)) % Convert a digit character to a digit
    ->  Digit = Digit0
    ;   Char = '.', % Convert a dot to 0 (empty cell)
        Digit = 0
    ).

% Convert a digit to an integer (0-9 or -1 for empty cells)
digit_to_int(Digit, Int) :-
    (   Digit = 0 % Convert 0 to -1 (empty cell)
    ->  Int = -1
    ;   Int = Digit % Convert other digits to themselves
    ).
