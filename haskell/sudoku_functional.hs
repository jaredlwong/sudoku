import Data.List
import Data.Maybe

type Row = Int
type Col = Int
type Box = Int
type Value  = Int
type Grid   = [[Value]]

-- Notice how Sudoku is actually a function from (row, col) to value, pretty
-- ingenious for a functional language
type Sudoku = (Row, Col) -> Value

sudokuToGrid :: Sudoku -> Grid
sudokuToGrid s = [[s (r, c) | c <- [1..9]] | r <- [1..9]]

gridToSudoku :: Grid -> Sudoku
gridToSudoku g = \(r, c) -> pos g (r, c)
  where
  pos :: Grid -> (Row, Col) -> Value
  pos g (r, c) = g !! (r-1) !! (c-1)

showVal :: Value -> String
showVal 0 = " "
showVal d = show d

showRow :: [Value] -> IO()
showRow [a1,a2,a3,a4,a5,a6,a7,a8,a9] =
 do  putChar '|'         ; putChar ' '
     putStr (showVal a1) ; putChar ' '
     putStr (showVal a2) ; putChar ' '
     putStr (showVal a3) ; putChar ' '
     putChar '|'         ; putChar ' '
     putStr (showVal a4) ; putChar ' '
     putStr (showVal a5) ; putChar ' '
     putStr (showVal a6) ; putChar ' '
     putChar '|'         ; putChar ' '
     putStr (showVal a7) ; putChar ' '
     putStr (showVal a8) ; putChar ' '
     putStr (showVal a9) ; putChar ' '
     putChar '|'         ; putChar '\n'

showGrid :: Grid -> IO()
showGrid [as,bs,cs,ds,es,fs,gs,hs,is] =
 do putStrLn ("+-------+-------+-------+")
    showRow as; showRow bs; showRow cs
    putStrLn ("+-------+-------+-------+")
    showRow ds; showRow es; showRow fs
    putStrLn ("+-------+-------+-------+")
    showRow gs; showRow hs; showRow is
    putStrLn ("+-------+-------+-------+")

showSudoku :: Sudoku -> IO()
showSudoku = showGrid . sudokuToGrid


-- find the first index of 0
nextEmptySquare :: Sudoku -> Maybe (Int, Int)
nextEmptySquare s = listToMaybe [(r, c) | r <- [1..9], c <- [1..9], s (r, c) == 0]

-- check if all non-zero elements are not duplicated
isValidGroup :: [Int] -> Bool
isValidGroup values = ns == nub ns where
  ns = [n | n <- values, n /= 0]

-- check if valid row
isValidRow :: Sudoku -> Row -> Bool
isValidRow s r = isValidGroup [s (r, c) | c <- [1..9]]

-- check if valid col
isValidCol :: Sudoku -> Col -> Bool
isValidCol s c = isValidGroup [s (r, c) | r <- [1..9]]

-- check if valid box
isValidBox :: Sudoku -> Box -> Bool
isValidBox s b = isValidGroup [s (r, c) | r <- rows, c <- cols] where
  -- this uses a where expression, divMod returns both b / 3 and b % 3
  (box_row, box_col) = divMod b 3
  rows = [box_row*3-1..box_row*3+3-1]
  cols = [box_col*3-1..box_col*3+3-1]

isValid :: Sudoku -> Bool
isValid s = and $
            [isValidRow s r | r <- [1..9]]
            ++
            [isValidCol s c | c <- [1..9]]
            ++
            [isValidRow s b | b <- [1..9]]

-- this is an ingenious way to update the sudoku function to basically override
-- it for a single case
update :: Sudoku -> ((Row, Col), Value) -> Sudoku
update s ((r, c), v) (r', c') = if r == r' && c == c' then v else s (r', c')

solveSudoku :: Sudoku -> [Sudoku]
solveSudoku s
  | valid && complete = [s]
  -- this is pretty shitty but i'm extracting the (x, y) coords out of x into y using flatMap
  | valid && not complete = [solved | ns <- nextPossibilities, solved <- solveSudoku ns ]
  | otherwise = []
  where valid = isValid s
        -- convert this to a list so it's easy to map over
        x :: [(Row, Col)]
        x = [y | y <- maybeToList $ nextEmptySquare s, valid]
        complete :: Bool
        complete = null x
        nextPossibilities :: [Sudoku]
        nextPossibilities = [update s (y, v) | v <- [1..9], y <- x]


grid :: Grid
grid = [[8, 0, 1, 3, 4, 0, 0, 0, 0],
        [4, 3, 0, 8, 0, 0, 1, 0, 7],
        [0, 0, 0, 0, 6, 0, 0, 0, 3],
        [2, 0, 8, 0, 5, 0, 0, 0, 9],
        [0, 0, 9, 0, 0, 0, 7, 0, 0],
        [6, 0, 0, 0, 7, 0, 8, 0, 4],
        [3, 0, 0, 0, 1, 0, 0, 0, 0],
        [1, 0, 5, 0, 0, 6, 0, 4, 2],
        [0, 0, 0, 0, 2, 4, 3, 0, 8]]

sudoku :: Sudoku
sudoku = gridToSudoku grid

-- main = do putStrLn $ show $ isValid sudoku
main = case listToMaybe $ solveSudoku sudoku 0 of Just s -> showSudoku s
                                                  Nothing -> showSudoku sudoku
