# This function takes in a puzzle string and returns a vector of integers
# representing the puzzle. It converts "." to 0, and converts all other
# characters to integers.
string_to_puzzle <- function(input) {
  # Split input into individual characters
  puzzle_chars <- strsplit(input, "")[[1]]

  # Convert each character to an integer, or 0 if it is a "."
  puzzle <- c()
  for (x in puzzle_chars) {
    puzzle <- append(puzzle, if (x == ".") 0 else as.integer(x))
  }

  return(puzzle)
}

# This function takes a puzzle and returns a string representation of the puzzle.
# If the element is 0, it is represented by a period instead.
puzzle_to_string <- function(puzzle) {
  s <- c()
  for (element in puzzle) {
    # If the element is 0, set it to ., else set it to the element
    s <- append(s, if (element != 0) as.character(element) else '.')
  }
  return(paste(s, collapse = ''))
}

# This function takes a row of the sudoku grid as input and returns TRUE if that
# row is valid (i.e. no duplicate values), and FALSE otherwise.
is_valid_row <- function(row) {
    checkset <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    for (e in row) {
      if (e != 0) {
        # R is 1-indexed, so we don't need to subtract 1 from e
        checkset[e] <- checkset[e] + 1
      }
    }
    for (e in checkset) {
        if (e > 1) {
            return(FALSE)
        }
    }
    return(TRUE)
}

is_valid <- function(grid) {
  for (r in 1:9) {
    row <- c()
    for (c in 1:9) {
      row <- append(row, grid[(r-1)*9+c])
    }
    if (!is_valid_row(row)) {
      return(FALSE)
    }
  }
  for (c in 1:9) {
    col <- c()
    for (r in 1:9) {
      col <- append(col, grid[(r-1)*9+c])
    }
    if (!is_valid_row(col)) {
      return(FALSE)
    }
  }
  for (i in 1:9) {
    box_row <- floor((i-1)/3)
    box_col <- (i-1)%%3
    box <- c()
    for (r in (1:3) + box_row * 3) {
      for (c in (1:3) + box_col * 3) {
        box <- append(box, grid[(r-1)*9+c])
      }
    }
    if (!is_valid_row(box)) {
      return(FALSE)
    }
  }
  return(TRUE)
}

next_open <- function(grid) {
  for (i in 1:81) {
    if (grid[i] == 0) {
      return(i)
    }
  }
  return(NULL)
}

solve <- function(grid) {
  valid <- is_valid(grid)
  if (!valid) {
    return(NULL)
  }
  p <- next_open(grid)
  if (is.null(p)) {
    return(grid)
  }
  for (v in 1:9) {
    grid[p] <- v
    next_grid <- solve(grid)
    if (!is.null(next_grid)) {
      return(next_grid)
    }
    grid[p] <- 0
  }
  return(NULL)
}

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 2) {
    print("Please provide the name of an input file as an argument.")
    exit(1)
}

filename <- args[2]
lines <- readLines(filename)

# Strip the whitespace from each line and remove any empty lines
lines <- trimws(lines)
lines <- lines[lines != ""]

for (i in seq(1, length(lines), 2)) {
  input <- lines[i]
  expected <- lines[i+1]
  start <- Sys.time()
  s <- string_to_puzzle(input)
  solved <- solve(s)
  output <- puzzle_to_string(solved)
  end <- Sys.time()
  if (output == expected) {
    print(paste("Solved sudoku ", input, " in ", (end-start)*1000, " ms"))
  } else {
    print(paste("Failed to solve sudoku ", input, ". Expected ", expected, ", got ", output))
    stop("Failed to solve sudoku")
  }
}