module BinTree where

    data Tree a = Leaf | Tree a (Tree a) (Tree a) deriving (Show,Eq)
    insert :: Ord a => a -> Tree a -> Tree a
    insert a Leaf = Tree a Leaf Leaf
    insert x (Tree y lb rb) = 
        if ( x < y ) then 
            if (x == y) then
                Tree y lb rb
                    else
                Tree y lb ( insert x rb)
                else 
            Tree y ( insert x lb) rb

    find :: Ord a => a -> Tree a -> Maybe a
    find a Leaf = Nothing
    find x (Tree y lb rb) = 
        if ( x < y ) then 
            if (x == y) then
                Just x
                    else
                find x rb
                else 
            find x lb

    delete :: Ord a => a -> Tree a -> Tree a
    delete x (Tree y lb rb) 
        | x < y = Tree y (delete x lb) rb
        | x > y = Tree y lb (delete x rb)
        | otherwise =
            if lb /= Leaf then let maxLeft = rightmost lb in 
                    Tree maxLeft (delete maxLeft lb) rb
            else if rb /= Leaf then let maxRight = leftmost rb in 
                    Tree maxRight lb (delete maxRight rb)
            else Leaf
    rightmost (Tree a l Leaf) = a
    rightmost Leaf = error "cannot delete from empty list"
    rightmost (Tree a l r) = rightmost r

    leftmost (Tree a Leaf r) = a
    leftmost (Tree a l r) = leftmost l
    leftmost Leaf = error "cannot delete from empty list"


    printTree :: Show a => Tree a -> IO ()
    printTree = mapM_ putStrLn . treeIndent
      where
        treeIndent Leaf           = ["-- /-"]
        treeIndent (Tree k lb rb) =
          ["--" ++ show k] ++
          map ("  |" ++) ls ++
          ("  `" ++ r) : map ("   " ++) rs
          where
            (r:rs) = treeIndent rb
            ls     = treeIndent lb
