import CachedSumList
import BinTree as B
import Set
import Diagnostic

instance Monoid SumList where 
    mempty = SumList [] 0
    mappend (SumList xs x) (SumList ys y) = SumList (xs++ys) (x+y)

instance (Ord t) => Monoid (B.Tree t) where 
    mempty = B.Leaf
    mappend tree1 tree2 = foldr B.insert tree2 (toList tree1)

instance Monoid (Diagnostic t) where 
    mempty = D (minBound,maxBound) ""
    mappend a1@(D r1 msg1) a2@(D r2 msg2) = D (overlaps a1 a2) (msg1 ++ msg2)


trees = [[3,1,2],[5,4,6],[8,7,9]]
diagnostics = [(D (1,4) "msg1"),(D (3,6) "msg2"),(D (2,5) "msg3")]

treeFromList :: Ord a => [a] -> B.Tree a
treeFromList = Set.fromList

testSumList = if (show $ mconcat $ map CachedSumList.fromList trees)
   == (show $ CachedSumList.fromList [3,1,2,5,4,6,8,7,9]) then 
    "Test for SumList passed" else "Test for SumList failed"
testTree = if( Set.toList $ mconcat allTrees) == [1,2,3,4,5,6,7,8,9] 
    then "Test for Tree passed" else "Test for Tree failed"
      where
        allTrees = map treeFromList trees 
testDiagnostic = if (mconcat diagnostics) 
    == (D (3,4) "msg1msg2msg3")
        then "Test for Diagnostics passed" else "Test for Diagnostics failed"

main = do
    putStrLn testSumList
    putStrLn testTree
    putStrLn testDiagnostic
    putStrLn "Finished tests execution"
