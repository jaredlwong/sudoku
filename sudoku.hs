import qualified Data.List
import qualified Data.Char

-- putStrLn $ sudokuPrint $ Data.Maybe.fromJust $ solveSudoku  sudoku

type Sudoku = [Int]

sudoku :: Sudoku
sudoku = [8, 0, 1, 3, 4, 0, 0, 0, 0,
          4, 3, 0, 8, 0, 0, 1, 0, 7,
          0, 0, 0, 0, 6, 0, 0, 0, 3,
          2, 0, 8, 0, 5, 0, 0, 0, 9,
          0, 0, 9, 0, 0, 0, 7, 0, 0,
          6, 0, 0, 0, 7, 0, 8, 0, 4,
          3, 0, 0, 0, 1, 0, 0, 0, 0,
          1, 0, 5, 0, 0, 6, 0, 4, 2,
          0, 0, 0, 0, 2, 4, 3, 0, 8]

-- find the first index of 0
nextEmptySquare :: Sudoku -> Maybe (Int, Int)
nextEmptySquare sudoku =
  Data.List.elemIndex 0 sudoku
    >>= (\i -> Just (quot i 9, mod i 9))

replaceElemAt :: Sudoku -> Int -> Int -> Int -> Sudoku
replaceElemAt sudoku row col val =
  let i = row * 9 + col
   in take i sudoku ++ [val] ++ drop (i+1) sudoku

genPossibleSudokus :: Sudoku -> [Sudoku]
genPossibleSudokus sudoku =
  case nextEmptySquare sudoku of
    Just (r, c) -> [replaceElemAt sudoku r c v | v <- [1..9]]
    Nothing -> []

-- split a list every n
splitEvery :: Int -> [a] -> [[a]]
splitEvery amount lst =
  let helper s r =
        case Data.List.splitAt amount s of
          (row, [])   -> r ++ [row]
          (row, rest) -> helper rest (r ++ [row])
  in helper lst []

-- get list of rows
sudokuRows :: Sudoku -> [[Int]]
sudokuRows sudoku = splitEvery 9 sudoku

-- get list of cols
sudokuCols :: Sudoku -> [[Int]]
sudokuCols sudoku = Data.List.transpose $ splitEvery 9 sudoku

-- get list of squares (represented by a list) in sudoku
sudokuSquares :: Sudoku -> [[Int]]
sudokuSquares sudoku =
  map concat $
    splitEvery 3 $
      concat $
        Data.List.transpose $
          splitEvery 3 $
            splitEvery 3 sudoku

-- check if all non-zero elements are not duplicated
rowColSqrOkay :: [Int] -> Bool
rowColSqrOkay rcs = let ns = [n | n <- rcs, n /= 0]
                    in ns == Data.List.nub ns

sudokuPossible :: Sudoku -> Bool
sudokuPossible sudoku =
  let rows = sudokuRows sudoku
      cols = sudokuCols sudoku
      sqrs = sudokuSquares sudoku
      nums = rows ++ cols ++ sqrs
  in all rowColSqrOkay nums

sudokuComplete :: Sudoku -> Bool
sudokuComplete sudoku = length [v | v <- sudoku, v == 0] == 0

solveSudoku :: Sudoku -> Maybe Sudoku
solveSudoku sudoku =
  let helper s
        | not (sudokuPossible s) = []
        | sudokuComplete s = [s]
        | otherwise = concatMap helper (genPossibleSudokus s)
      solns = helper sudoku
  in if null solns then Nothing else Just (head solns)

sudokuPrint :: Sudoku -> [Char]
sudokuPrint sudoku = concat . concat $ Data.List.intersperse ["\n"] $ concat $ Data.List.intersperse [["-----------"]] $ splitEvery 3 $ map (Data.List.intersperse "|") $ splitEvery 3 $ splitEvery 3 $ map Data.Char.intToDigit sudoku
