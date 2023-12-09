
import Data.List

removeCard card = filter ((/= card) . fst)

addCard card cardCounts = update cardCounts $ (card, maybe 0 id (lookup card cardCounts) + 1)
  where
    update result count@(card,_) = count : removeCard card result

countCards cards = f cards []
  where
    f [] result = result
    f (card:cards) result = f cards $ addCard card result

handTypes :: [[Int]]
handTypes = [[5], [1, 4], [2, 3], [1, 1, 3], [1, 2, 2], [1, 1, 1, 2], [1, 1, 1, 1, 1]]
getTypeValue types x = maybe 0 id $ lookup x (zip (reverse types) [1..])

handify :: String -> [(Char, Int)]
handify = sortOn snd . countCards

third (_, _, x) = x
solve cardTypes getHandValue = sum . map (uncurry (*)) . zip [1..] . map third . sortBy handCmp . map f . lines
  where
    f :: String -> (String, [(Char, Int)], Int)
    f line = let [raw, bid] = words line
              in (raw, handify raw, read bid :: Int)
    handCmp (raw1, hand1, _) (raw2, hand2, _) =
      let a = getHandValue hand1
          b = getHandValue hand2
       in if a == b then compareCards raw1 raw2 else compare a b
    getCardValue = getTypeValue cardTypes
    compareCards (c1:cs1) (c2:cs2) = let a = getCardValue c1
                                         b = getCardValue c2
                                      in if a == b then compareCards cs1 cs2 else compare a b

part1GetHandValue = getTypeValue handTypes . map snd
part1 = solve "AKQJT98765432" part1GetHandValue

-- stupidly brute force part 2

type Hand = [(Char, Int)]
getAllPermutations :: Hand -> [Hand]
getAllPermutations hand
  | jCount == 0 = [removeCard 'J' hand]
  | otherwise   = concat $ map getAllPermutations permutations
    where
      jCount :: Int
      jCount = maybe 0 id $ lookup 'J' hand
      permutations = map g $ "AKQT98765432" 
      g card = sortOn snd $ addCard card (('J', jCount-1) : removeCard 'J' hand)

part2GetHandValue = maximum . map part1GetHandValue . getAllPermutations
part2 = solve "AKQT98765432J" part2GetHandValue

bothParts input = unlines $ map (show . ($ input)) [part1, part2]

main = interact $ bothParts
