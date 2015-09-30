module CachedSumList (
newSumList,
fromList,
getList,
getSum,
prepend,
behead,
remove
) where 
data SumList = SumList { innerList :: [Int], innerSum :: Int }
     deriving (Show)   
newSumList = SumList [] 0
fromList sl = SumList sl (sum sl)

getList sl = innerList sl
getSum sl = innerSum sl
prepend sl x = SumList (x : getList sl) (x + getSum sl) 
behead (SumList l sum) x = SumList (tail l) (sum-x)
remove (SumList l sum) i = SumList (start ++ end) (sum - element) where
    element = l !! i
    start = take i l
    end = drop (i+1) l
