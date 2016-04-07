import Set
import qualified BinTree as B

nextN :: (Ord a) => B.Tree a -> a -> Int -> Maybe a
nextN tree elem num 
    | num <= 0 = Nothing
    | otherwise = nextMaybe tree (Just elem) num where 
        nextMaybe _ (Just e) 0 = Just e
        nextMaybe t (Just e) n = nextMaybe t (next e t) (n-1) 
        nextMaybe _ Nothing _ = Nothing

tree :: B.Tree Int 
tree = fromList [9,1,8,2,7,3,6,4,5]



