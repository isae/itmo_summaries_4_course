import Data.List
factor :: (Integral a) => [a] -> [a]
factor list = sort $ list >>= factorNum

factorNum :: (Integral a) => a -> [a]
factorNum num 
    | num == 1 = [1]
    | num == 0 = [0]
    | num == -1 = [-1]
    | num < 0 = (-1):factorNum (-num)
    | otherwise = toList [] 2 num where 
        toList prev cur n
            | n == cur = cur:prev
            | mod n cur == 0 = toList (cur:prev) cur (div n cur)
            | otherwise = toList prev (cur+1) n
