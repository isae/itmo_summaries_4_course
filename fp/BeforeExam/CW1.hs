import Data.List

-- task 1
-- converting from number's binary representation as list to decimal number
fromBin :: Num a => [a] -> a
fromBin arr = foldl (\x -> (x*2 +)) 0 $ reverse arr

test1 = test1_1 && test1_2 && test1_3
test1_1 = (fromBin [0,1,1] == 6)
test1_2 = (fromBin [0] == 0)
test1_3 = (fromBin [0,0,0] == 0)

-- task 2
-- count occurences of each element in list
countOccurences :: Ord a => [a] -> [(a,Int)]
countOccurences [] = []
countOccurences x = foldl ccount [(head arr, 1)] (tail arr)
    where arr = sort x
          ccount x y = let hd = head x
                           tl = tail x
                       in if y == fst hd then (fst hd, snd hd + 1):tl else (y,1):x

test2 = test2_1 && test2_2 && test2_3
test2_1 = (countOccurences [2,4,6,1,4,8,2]) == [(8,1), (6,1), (4,2), (2,2), (1,1)]
test2_2 = length (countOccurences ([]::[Int])) == 0
test2_3 = (countOccurences [1,1,1,1,1,1,1,1,1,1,1,1]) == [(1,12)]
