
import Debug.Trace

testData = "0 3 6 9 12 15"

nextLine nums = map (uncurry (-)) $ zip nums $ tail nums

allLines nums
  | and $ map (== 0) nums = [nums]
  | otherwise             = nums : (allLines $ nextLine nums)

solveLine = foldl f 0 . reverse . allLines . reverse . map read . words
  where
    f n nums = head nums + n

solve = sum . map solveLine . lines

main = interact $ (++ "\n") . show . solve
