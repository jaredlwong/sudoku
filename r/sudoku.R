convert <- function(input) {
  grid <- matrix(0, nrow = 9, ncol = 9)
  for (i in 1:9) {
    for (j in 1:9) {
      print((i - 1) * 9 + j)
      print((i - 1) * 9 + j + 1)
      val <- substring(input, (i - 1) * 9 + j, (i - 1) * 9 + j + 1)
      print('--------')
      print(val)
      print('--------')
      if (val != '.') {
        grid[i, j] <- as.integer(val)
      }
    }
  }
  grid
}

puzzle_to_string <- function(grid) {
  do.call(paste, grid, sep = '')
}

is_valid <- function(grid) {
  # check rows
  for (r in 1:9) {
    checkset <- rep(0, 10)
    for (c in 1:9) {
      checkset[grid[r,c]] <- checkset[grid[r,c]] + 1
      if (grid[r,c] > 0 && checkset[grid[r,c]] > 1) {
        return(FALSE)
      }
    }
  }

  # check cols
  for (c in 1:9) {
    checkset <- rep(0, 10)
    for (r in 1:9) {
      checkset[grid[r,c]] <- checkset[grid[r,c]] + 1
      if (grid[r,c] > 0 && checkset[grid[r,c]] > 1) {
        return(FALSE)
      }
    }
  }

  # check boxes
  for (x in 1:9) {
    checkset <- rep(0, 10)
    box_row <- x %/% 3
    box_col <- x %% 3
    for (r in box_row * 3:box_row * 3 + 3) {
      for (c in box_col * 3:box_col * 3 + 3) {
        checkset[grid[r,c]] <- checkset[grid[r,c]] + 1
        if (grid[r,c] > 0 && checkset[grid[r,c]] > 1) {
          return(FALSE)
        }
      }
    }
  }

  return(TRUE)
}

next_open <- function(grid) {
  for (r in 1:9) {
    for (c in 1:9) {
      if (grid[r, c] == 0) {
        return (c(r, c))
      }
    }
  }
  return (None)
}

solve <- function(grid){
  if(!is_valid(grid)){
    return(F)
  }
  p <- next_open(grid)
  # if complete
  if(!p){
    return(T)
  }
  row <- p[1]
  col <- p[2]
  for(v in 1:10){
    grid[row][col] <- v
    result <- solve(grid)
    if(result){
      return(T)
    }
    grid[row][col] <- 0
  }
  return(F)
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
print(length(lines))

for (i in seq(0, length(lines), 2)) {
  input = lines[i]
  expected = lines[i+1]
  print(input)
  print(expected)
  s = convert(input)
  # start = time.time()
  # solve(s)
  # print(s)
  # end = time.time()
  # if (puzzle_to_string(s) == expected) {
  #   print("Solved sudoku %s in %d ms" % (input, (end-start)*1000))
  # } else {
  #   print("Failed to solve sudoku %s. Expected %s, got %s" % (input, expected, s))
  #   exit(1)
  # }
}