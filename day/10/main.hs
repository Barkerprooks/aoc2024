import Data.Char
import Data.Set (toList, fromList)

showTuple :: (Int, Int) -> String
showTuple (x, y) = "(" ++ (show x) ++ ", " ++ (show y) ++ ")"

startingCells :: [String] -> [(Int, Int)]
startingCells m = [(x, y) | (y, r) <- zip [0..] m, (x, c) <- zip [0..] r, c == '0']

outOfBounds :: [String] -> (Int, Int) -> Bool
outOfBounds m (x, y) = x < 0 || y < 0 || y >= (length m) || x >= (length (m !! y))

isNextCell :: [String] -> (Int, Int) -> (Int, Int) -> Bool
isNextCell m xy nxy = not (outOfBounds m nxy) &&
    (digitToInt (getCell m nxy) == (digitToInt (getCell m xy) + 1))

getCell :: [String] -> (Int, Int) -> Char
getCell m (x, y) = ((m) !! y) !! x

next :: [String] -> (Int, Int) -> [(Int, Int)]
next m (x, y) =
    [(x, ny) | ny <- [y - 1, y + 1], isNextCell m (x, y) (x, ny)] ++
    [(nx, y) | nx <- [x - 1, x + 1], isNextCell m (x, y) (nx, y)]

findPaths :: [String] -> (Int, Int) -> [(Int, Int)]
findPaths m xy = do
    if (getCell m xy) == '9' then [xy]
    else concat (map (\cell -> findPaths m cell) (next m xy))

findAllPaths :: [String] -> [(Int, Int)] -> [Int] -> [Int]
findAllPaths m (xy:xs) paths = findAllPaths m xs paths ++ [(length (toList (fromList (findPaths m xy))))]
findAllPaths m [] paths = paths

main :: IO()
main = do
    content <- readFile "./day/10/input.txt"
    let m = (lines content)

    let paths = findAllPaths m (startingCells m) []
    
    putStrLn ("part 1: " ++ (show (sum paths)))