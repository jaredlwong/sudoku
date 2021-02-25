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

sudoku_puzzle =[
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,3,0,8,5],
[0,0,1,0,2,0,0,0,0],
[0,0,0,5,0,7,0,0,0],
[0,0,4,0,0,0,1,0,0],
[0,9,0,0,0,0,0,0,0],
[5,0,0,0,0,0,0,7,3],
[0,0,2,0,1,0,0,0,0],
[0,0,0,0,4,0,0,0,9]]

def transpose(mat):
    return [list(x) for x in zip(*mat)]

def sudoku_rows(sudoku):
    return sudoku

def sudoku_cols(sudoku):
    return transpose(sudoku)

def sudoku_sqrs(sudoku):
    sqrs = {(x, y): [] for x in range(3) for y in range(3)}
    for i, row in enumerate(sudoku):
        for j, v in enumerate(row):
            sqrs[(i//3, j//3)].append(v)
    return sqrs.values()

def grp_okay(grp):
    grp_minus_zeros = [x for x in grp if x != 0]
    return len(grp_minus_zeros) == len(set(grp_minus_zeros))

def sudoku_possible(sudoku):
    grps = []
    grps.extend(sudoku_rows(sudoku))
    grps.extend(sudoku_cols(sudoku))
    grps.extend(sudoku_sqrs(sudoku))
    return all(grp_okay(grp) for grp in grps)

def sudoku_complete(sudoku):
    for row in sudoku:
        for v in row:
            if v == 0:
                return False
    return True

def sudoku_next_empty(sudoku):
    for i in range(len(sudoku)):
        for j in range(len(sudoku[i])):
            if sudoku[i][j] == 0:
                return (i, j)
    return None


def sudoku_solve(sudoku):
    queue = []
    i, j = sudoku_next_empty(sudoku)
    queue.extend((i, j, k) for x in zip([0]*9, range(1,10)) for k in x)
    while len(queue) > 0:
        row, col, k = queue.pop()
        sudoku[row][col] = k
        if k != 0:
            if not sudoku_possible(sudoku):
                continue
            if sudoku_complete(sudoku):
                return sudoku
            i, j = sudoku_next_empty(sudoku)
            queue.extend((i, j, k) for x in zip([0]*9, range(1,10)) for k in x)
    return None


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

if __name__ == '__main__':
    print(sudoku_solve(sudoku_puzzle))
    #s =  sudoku_next(sudoku_puzzle)
    #print sudoku_to_str(sudoku_puzzle)
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
    #print sudoku_to_str(s.next())
#    print sudoku_to_str(sudoku_solve(sudoku))
