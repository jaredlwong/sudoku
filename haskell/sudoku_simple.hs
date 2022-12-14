import Control.Monad (forM_)
import System.Environment (getArgs)
import Data.List
import Data.Maybe
import System.Exit (exitWith, ExitCode(ExitFailure))
import Data.Time.Clock.POSIX (getPOSIXTime)
import Data.Function (on)


stringToPuzzle :: String -> [[Int]]
stringToPuzzle input =
  [ [ if input !! (i * 9 + j) /= '.' then read [input !! (i * 9 + j)] else 0 | j <- [0..8] ] | i <- [0..8] ]

puzzleToString :: [[Int]] -> String
puzzleToString grid =
  concat [ concat [ show e | e <- row ] | row <- grid ]

-- isValidRow :: [Int] -> Bool
-- isValidRow row = all (\e -> e <= 1) (counts row)
--   where
--     counts row = map (\n -> length (filter (== n) row)) [1..9]

-- isValidRow :: [Int] -> Bool
-- isValidRow row = all (\x -> x <= 1) (foldl (\acc x -> acc !! (x-1) += 1) row [0,0,0,0,0,0,0,0,0])

isValidRow :: [Int] -> Bool
isValidRow row = ((==) `on` length) (nub b) b
  where b = filter (/= 0) row

isValid :: [[Int]] -> Bool
isValid grid =
    -- check rows
    all isValidRow grid &&
    -- check cols
    let transposed = transpose grid
    in all isValidRow transposed &&
    -- check boxes
    let boxes = map (\x -> let boxRow = x `div` 3
                               boxCol = x `mod` 3
                               box = [grid !! r !! c | r <- [boxRow * 3..boxRow * 3 + 2], c <- [boxCol * 3..boxCol * 3 + 2]]
                           in box) [0..8]
    in all isValidRow boxes


nextOpen :: [[Int]] -> Maybe (Int, Int)
nextOpen grid =
  let openPositions = [ (r, c) | r <- [0..8], c <- [0..8], grid !! r !! c == 0 ]
  in case openPositions of
    [] -> Nothing
    _  -> Just (head openPositions)

setValue :: [[Int]] -> Int -> Int -> Int -> [[Int]]
setValue matrix row col value =
  let
    (beforeRows, targetRow:afterRows) = splitAt row matrix
    (beforeCols, _:afterCols) = splitAt col targetRow
  in
    beforeRows ++ [beforeCols ++ [value] ++ afterCols] ++ afterRows

solve :: [[Int]] -> Maybe [[Int]]
solve grid = if isValid grid then solve' grid else Nothing
  where
    solve' grid =
      case nextOpen grid of
        Nothing -> Just grid
        Just (row, col) ->
          let tryValue prev v =
                let grid' = setValue grid row col v
                    result = solve grid'
                in if isJust prev then prev else (if isJust result then result else Nothing)
          in foldl (tryValue) Nothing [1..9]

solveString :: [[Int]] -> IO String
solveString grid = do
  case solve grid of
    Nothing -> return $ puzzleToString grid
    Just solution -> return $ puzzleToString solution

replaceNth :: Int -> a -> [a] -> [a]
replaceNth n newVal (x:xs)
  | n == 0 = newVal:xs
  | otherwise = x:replaceNth (n-1) newVal xs

-- | Reads the lines of a file, pairs them up and prints them out.
-- If the number of lines in the file is not even, the last line is discarded.
sudokuMain :: FilePath -> IO ()
sudokuMain filePath = do
  -- Read the lines of the file
  lines <- fmap lines (readFile filePath)

  -- Pair up the lines
  let pairs = [(lines !! i, lines !! (i + 1)) | i <- [0, 2 .. length lines - 2]]

  forM_ pairs $ \(input, expected) -> do
    let s = stringToPuzzle input
    start <- getPOSIXTime
    solution <- solveString s
    end <- getPOSIXTime
    if solution == expected
      then putStrLn $ "Solved sudoku " ++ input ++ " in " ++ show ((end - start) * 1000) ++ " ms"
      else do
        putStrLn $ "Failed to solve sudoku " ++ input ++ ". Expected " ++ expected ++ ", got " ++ (solution)
        exitWith $ ExitFailure 1

-- | Main entry point of the program.
-- Reads the filename from the command line arguments and passes it to 'pairLines'.
main :: IO ()
main = do
  args <- getArgs
  case args of
    -- If no filename is provided, print an error message and exit.
    [] -> putStrLn "Please provide a filename."
    -- Otherwise, call 'pairLines' with the first argument (the filename)
    (filePath:_) -> sudokuMain filePath