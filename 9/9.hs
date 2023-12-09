
nextLine nums = map (uncurry (-)) $ zip nums $ tail nums

allLines nums
  | and $ map (== 0) nums = [nums]
  | otherwise             = nums : (allLines $ nextLine nums)

solveLine maybeReverse = foldl f 0 . reverse . allLines . maybeReverse . map read . words
  where
    f n nums = head nums + n

solve maybeReverse = sum . map (solveLine maybeReverse) . lines

main = interact f
  where
    f input = unlines $ map (show . ($ input) . solve) [reverse, id]
