sudoku_puzzle = [
[8,0,1,3,4,0,0,0,0],
[4,3,0,8,0,0,1,0,7],
[0,0,0,0,6,0,0,0,3],
[2,0,8,0,5,0,0,0,9],
[0,0,9,0,0,0,7,0,0],
[6,0,0,0,7,0,8,0,4],
[3,0,0,0,1,0,0,0,0],
[1,0,5,0,0,6,0,4,2],
[0,0,0,0,2,4,3,0,8]]

#sudoku_puzzle = [
#[0,0,0, 0,0,4, 0,2,8],
#[4,0,6, 0,0,0, 0,0,5],
#[1,0,0, 0,3,0, 6,0,0],
#
#[0,0,0, 3,0,1, 0,0,0],
#[0,8,7, 0,0,0, 1,4,0],
#[0,0,0, 7,0,9, 0,0,0],
#
#[0,0,2, 0,1,0, 0,0,3],
#[9,0,0, 0,0,0, 5,0,7],
#[6,7,0, 4,0,0, 0,0,0]]

sudoku_fmt = \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"||---+---+---||---+---+---||---+---+---||\n" + \
"|| {} | {} | {} || {} | {} | {} || {} | {} | {} ||\n" + \
"++===========++===========++===========++\n"

def sudoku_to_str(sudoku):
    return sudoku_fmt.format(*[x if x != 0 else " " for r in sudoku for x in r])

class Sudoku(object):
    def __init__(self, sudoku_puzzle):
        self.sudoku = [list(row) for row in sudoku_puzzle]
        for i in range(9):
            for j in range(9):
                if self.sudoku[i][j] == 0:
                    self.sudoku[i][j] = set(range(1, 10))
                else:
                    self.sudoku[i][j] = set([self.sudoku[i][j]])
        self.__history = []

    def __repr__(self):
        return sudoku_to_str([[x[0] if len(x) == 1 else 0 for x in map(list, row)] for row in self.sudoku])

    def get_row(self, row):
        return self.sudoku[row]

    def get_col(self, col):
        return [self.sudoku[i][col] for i in range(9)]

    """given a row and col within the square, get all elements of the square"""
    def get_sqr(self, row, col):
        row = row/3 * 3
        col = col/3 * 3
        return [self.sudoku[i][j] for i in range(row, row+3) for j in range(col, col+3)]

    def get_possible(self, row, col):
        return self.sudoku[row][col]

    """given a row, col, or sqr returned from get_row, etc. return a set of all
    chosen (set size of 1) numbers"""
    def chosen_numbers(self, rcs):
        chosen = set()
        for possible in rcs:
            if len(possible) == 1:
                chosen |= possible
        return chosen

    """eliminate possibilities because of the row/col/sqr uniqueness rules"""
    def eliminate_possibilities_within_square_by_rules(self, row, col):
        initial_possibilities = set(self.sudoku[row][col])
        # if we've already chosen, don't continue
        if len(initial_possibilities) == 1:
            return 0
        all_chosen = set()
        all_chosen |= self.chosen_numbers(self.get_row(row))
        all_chosen |= self.chosen_numbers(self.get_col(col))
        all_chosen |= self.chosen_numbers(self.get_sqr(row, col))
        eliminated_possibilities = list(initial_possibilities & all_chosen)
        def execute():
            self.sudoku[row][col] -= all_chosen
        def undo():
            self.sudoku[row][col] = initial_possibilities
        description = "Eliminate the possibility of {} from square {}, {} because they have already been chosen in this square's row, column, or box.".format(eliminated_possibilities, row, col)
        if len(eliminated_possibilities) > 0:
            self.__history.append((description, execute, undo))
            execute()
        return len(eliminated_possibilities)

    def strategy_possibles(self, row, col):
        initial_possibilities = set(self.sudoku[row][col])
        # if we've already chosen, don't continue
        if len(initial_possibilities) == 1:
            return 0
        all_chosen = set()
        all_chosen |= self.chosen_numbers(self.get_row(row))
        all_chosen |= self.chosen_numbers(self.get_col(col))
        all_chosen |= self.chosen_numbers(self.get_sqr(row, col))
        eliminated_possibilities = initial_possibilities & all_chosen
        next_possibilities = initial_possibilities - eliminated_possibilities
        if len(next_possibilities) == 1:
            def execute():
                self.sudoku[row][col] = next_possibilities
            def undo():
                self.sudoku[row][col] = initial_possibilities
            description = "Choose {}, {} to be {} because none other possible by rules.".format(row, col, list(next_possibilities)[0])
            self.__history.append((description, execute, undo))
            execute()
            return 1
        return 0

    def undo(self):
        last_execute, last_undo = self.__history.pop()
        last_undo()

    def eliminate_possibilities_by_rules(self):
        loops = 0
        while True:
            loops += 1
            chosen = 0
            for i in range(9):
                for j in range(9):
                    chosen += self.strategy_possibles(i, j)
            if chosen == 0:
                break
        return loops

    def history(self):
        for desc, _, _ in self.__history:
            print desc

s = Sudoku(sudoku_puzzle)
print s
print s.eliminate_possibilities_by_rules()
print s
print s.history()
