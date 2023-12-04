
import Data.List.Split

getHands :: String -> ([Int], [Int])
getHands s = (winning, mine)
  where
    [_, hands] = splitOn ":" s
    [winning, mine] = map (map read . words) $ splitOn "|" hands

getWinningCount line = let (winning, mine) = getHands line
                        in (sum $ map (fromEnum . (`elem` winning))  mine)

part1 = sum . map f . lines
  where
    f line = let winningCount = getWinningCount line
             in  if winningCount == 0 then 0 else 2 ^ (winningCount - 1)

part2 = snd . foldl f (repeat 1, 0) . lines
  where
    f (c:cs, result) line = let winningCount = getWinningCount line
                                ncs = zipWith (+) cs ((replicate winningCount c) ++ repeat 0)
                             in (ncs, result + c)

main = interact $ unlines . (\s -> map (show . ($ s)) [part1, part2])
