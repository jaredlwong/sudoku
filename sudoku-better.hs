data SudokuSquare = One | Two | Three | Four | Five | Six | Seven | Eight | Nine
type Sudoku = [[SudokuSquare]]


sudoku :: Sudoku
sudoku = [[8, 0, 1, 3, 4, 0, 0, 0, 0],
          [4, 3, 0, 8, 0, 0, 1, 0, 7],
          [0, 0, 0, 0, 6, 0, 0, 0, 3],
          [2, 0, 8, 0, 5, 0, 0, 0, 9],
          [0, 0, 9, 0, 0, 0, 7, 0, 0],
          [6, 0, 0, 0, 7, 0, 8, 0, 4],
          [3, 0, 0, 0, 1, 0, 0, 0, 0],
          [1, 0, 5, 0, 0, 6, 0, 4, 2],
          [0, 0, 0, 0, 2, 4, 3, 0, 8]]

main = do putStrLn $ "Hello"
