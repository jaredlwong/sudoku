import argparse
import random
import time
import sys
from typing import List

class Cell(object):
    def __init__(self, number: int, mask: int):
        self.num: int = number
        self.mask: int = mask

    def equals(self, val: int) -> bool:
        return self.mask == 1 and self.num == val

    def is_hidden(self) -> bool:
        return self.mask == 1

def generate_sudoku_recursive(table: List[List[Cell]], n: int, x: int, y: int) -> int:
    size: int = n**2
    mask_array: List[int] = [1 for i in range(size)]
    for i in range(y):
        mask_array[table[x][i].num - 1] = 0
    for i in range(x):
        mask_array[table[i][y].num - 1] = 0
    for i in range(n * (x//n), n * (x//n) + n):
        for j in range(n * (y//n), y):
            mask_array[table[i][j].num - 1] = 0
    rand_array: List[int] = [i + 1 for i in range(size) if mask_array[i] == 1]
    k: int = len(rand_array)
    new_x, new_y = (0, y + 1) if x == size - 1 else (x + 1, y)
    while k > 0:
        index: int = random.randint(0, k - 1)
        table[x][y].num = rand_array[index]
        for i in range(index, k - 1):
            rand_array[i] = rand_array[i + 1]
        k -= 1
        if x == size - 1 and y == size - 1:
            return 1
        if generate_sudoku_recursive(table, n, new_x, new_y):
            return 1
    return 0

def generate_sudoku(n: int) -> List[List[Cell]]:
    size: int = n**2
    table: List[List[Cell]] = [[Cell(0, 0) for i in range(size)] for j in range(size)]
    generate_sudoku_recursive(table, n, 0, 0)
    return table


def print_sudoku(table: List[List[Cell]], n: int):
    size = n * n
    for i in range(size):
        for j in range(size):
            if size > 10: # if cell number has 2 digits
                format2 = "-- "
                # add 0 if the number < 10
                if table[i][j].num < 10:
                    format = "0%d "
                else:
                    format = "%d "
            else: # if the number has only 1 digit
                format = "%d "
                format2 = "- "
            if table[i][j].mask == 0:
                print(format2, end="") # mask=0
            else:
                print(format % table[i][j].num, end="") # mask=1
            if (j+1)%n == 0:
                print(" ", end="") # Print blanks among block columns
        if (i+1)%n == 0:
            print() # Print blanks among block rows
        print() # Next line.

def hide_numbers(table: List[List[Cell]], n: int, m: int):
    # 1. Set mask=0 for all cells.
    for i in range(len(table)):
        for j in range(len(table[i])):
            table[i][j].mask = 0
    # 2. Randomly change open m cells.
    for i in range(m):
        while True:
            x = random.randint(0, len(table) - 1)
            y = random.randint(0, len(table[x]) - 1)
            if table[x][y].mask != 1:
                break
        table[x][y].mask = 1

def legal(puzzle: List[List[int]], n: int, x: int, y: int, num: int):
    size = n * n
    rowStart = (int)(x/n) * n
    colStart = (int)(y/n) * n
    for i in range(size):
        if puzzle[x][i] == num: return 0
        if puzzle[i][y] == num: return 0
        if puzzle[rowStart + (i%n)][colStart + (int)(i/n)] == num:
            return 0
    return 1
 
def check(puzzle: List[List[int]], n: int, x: int, y: int, count: int):
    """
    Check if the given Sudoku puzzle has a unique solution.
    
    Args:
        puzzle: a two-dimensional list of integers representing a Sudoku puzzle.
        n: an integer representing the size of the puzzle.
        x: an integer representing the x-coordinate of the current cell being considered.
        y: an integer representing the y-coordinate of the current cell being considered.
        count: an integer representing the number of solutions found so far.
        
    Returns:
        An integer representing the number of solutions to the puzzle.
    """
    size = n * n
    if x == size:
        x = 0
        if y + 1 == size: return (1 + count)
        y += 1
    # Skip opened cell.
    if puzzle[x][y] != 0:  return check(puzzle, n, x+1, y, count)
    # skip if the puzzle has more than one solution
    for num in range(1, size + 1):
        if count < 2 and legal(puzzle, n, x, y, num):
            puzzle[x][y] = num
            # Goto next.
            count = check(puzzle, n, x+1, y, count)
    # Reset cell on go back.
    puzzle[x][y] = 0
    return count

def puzzle_to_str(table: List[List[Cell]]):
    return ''.join(''.join('.' if c.is_hidden() else str(c.num) for c in row) for row in table)

def puzzle_to_solution(table: List[List[Cell]]):
    return ''.join(''.join(str(c.num) for c in row) for row in table)
        
def generate_puzzle(square_width: int, num_open: int) -> List[List[Cell]]:
    table = generate_sudoku(3)
    tried = 0
    size = square_width * square_width
    while True:
        hide_numbers(table, square_width, num_open)
        puzzle = [[0] * 9 for _ in range(9)]
        for i in range(size):
            for j in range(size):
                if table[i][j].is_hidden():
                    puzzle[i][j] = 0
                else:
                    puzzle[i][j] = table[i][j].num

        update = f"Finding unique solution puzzle (tried {tried} times)..."
        sys.stdout.write(update)
        sys.stdout.flush()
        sys.stdout.write("\b" * len(update)) # return to start of line, after '['
        tried += 1
        if check(puzzle, square_width, 0, 0, 0) == 1:
            break
    sys.stdout.write("\n")
    return table


if __name__ == '__main__':
    # Create an ArgumentParser object
    parser = argparse.ArgumentParser()

    # Add the arguments
    parser.add_argument("num_puzzles", type=int, help="The number of puzzles to generate")
    parser.add_argument("difficulty", type=int, help="The number of open spaces")
    parser.add_argument("output_file", type=str, help="The file path to output the puzzles")

    # Parse the arguments
    args = parser.parse_args()

    # Extract the values of the arguments
    num_puzzles = args.num_puzzles
    difficulty = args.difficulty
    output_file = args.output_file
    total = 0
    with open(output_file, 'a') as f:
        for _ in range(num_puzzles):
            start = time.time()
            table = generate_puzzle(3, difficulty)
            f.write(puzzle_to_str(table) + '\n')
            f.write(puzzle_to_solution(table) + '\n')
            total += 1
            end = time.time()
            print(f"Generated puzzle {total} in {end - start} seconds")