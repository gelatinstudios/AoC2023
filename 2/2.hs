
import Data.Maybe
import Data.List.Split

maxs = [("red", 12), ("green", 13), ("blue", 14)]

solve forLine forGame forHand forSet = sum . forLine . map g . lines
   where
     g = forGame . map h . splitOn ";" . last . splitOn ":"
     h = forHand . map j . splitOn ","
     j s = let [ns, color] = words s
               n = read ns :: Int
           in  forSet n color
              
part1 = solve f and and g
  where
    f = map fst . filter snd .  zip [1..]
    g n color = n <= (fromJust $ lookup color maxs)

part2 = solve id f id h
  where
    f = product . foldl g [0,0,0]
    g rgb = foldl combine rgb
    h n color = case color of
                   "red"   -> [n,0,0]
                   "green" -> [0,n,0]
                   "blue"  -> [0,0,n]
    combine a b = map (uncurry max) $ zip a b

main = interact f
  where
    f s = unlines $ map (show . ($ s)) [part1, part2]
