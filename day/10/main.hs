import Data.Char
import Data.Set (toList, fromList)

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

-- finds every path it can possibly take to each 9
findAllPathRatings :: [String] -> [(Int, Int)] -> [Int] -> [Int]
findAllPathRatings m (xy:xs) paths = findAllPathRatings m xs paths ++
    [(length (findPaths m xy))]
findAllPathRatings m [] paths = paths

-- same as above only the paths are filtered to be unique so each 9 is only recorded once
findAllPaths :: [String] -> [(Int, Int)] -> [Int] -> [Int]
findAllPaths m (xy:xs) paths = findAllPaths m xs paths ++ 
    [(length (toList (fromList (findPaths m xy))))]
findAllPaths m [] paths = paths

main :: IO()
main = do
    text <- readFile "./day/10/input.txt"
    let m = (lines text)
    let s = (startingCells m)

    let scores = findAllPaths m s []
    let ratings = findAllPathRatings m s []

    putStrLn ("part 1: " ++ (show (sum scores)))
    putStrLn ("part 2: " ++ (show (sum ratings)))