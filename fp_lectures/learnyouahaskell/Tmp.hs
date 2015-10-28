factorial :: Integer -> Integer  
factorial n = product [1..n] 

repl :: Int -> b -> [b]
repl i x  
    | i <= 0 = []
    | otherwise = x: repl (i-1) x

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

quicksort [] = []
quicksort (x:xs) = firstHalf ++ [x] ++ secondHalf where
    firstHalf = quicksort [y | y <- xs, y<=x]
    secondHalf = quicksort [y | y <- xs, y>x]

infixr 7 // 
(//) x y = x / y

--(|-|) :: (Num a) => a -> a -> a
infixl 6 |-|
x |-| y = abs (x - y)

chain :: (Integral a) => a -> [a]  
chain 1 = [1]  
chain n  
    | even n =  n:chain (n `div` 2)  
    | odd n  =  n:chain (n*3 + 1)  
