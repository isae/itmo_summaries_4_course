import Data.List
import Control.Exception.Base
which :: (Integral a) => [a] -> [a]
which list = getMax (partition (\x -> mod x 2 == 0) list)
    where getMax (a,b) = if (length a) > (length b) then a else b

testWhich = assert (which [1,2,3,4,5] == [1,3,5]) "Which test passed"

splitK k list = splitFold 0 list [[]] where
    splitFold _ [] res = res
    splitFold num (x:xs) res@(y:ys) 
        | num == k = splitFold 0 xs ([x]:res)
        | otherwise = splitFold (num+1) xs ((x:y):ys)

data SNM = SNM { 
        elements :: [Int]
    } 

snmInit k = SNM [0..k-1]

snmFind snm x = (elements snm) !! x

snmUnion snm x y 
    | x == y = snm
    | otherwise = SNM $ replaceAll $ elements snm
        where fx = snmFind snm x 
              fy = snmFind snm y 
              replaceAll list = map (\cl -> if cl == fy then fx else cl) list 

instance Show SNM where
    show (SNM l@(x:xs)) = show $ zip [0..] l
