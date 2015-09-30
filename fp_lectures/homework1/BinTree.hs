data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show)
b = Leaf 
insert :: Ord a => a -> Tree a -> Tree a
insert a Leaf = Node a Leaf Leaf
insert x (Node y lb rb) = 
    if ( x < y ) then 
        if (x == y) then
            Node y lb rb
                else
            Node y lb ( insert x rb)
            else 
        Node y ( insert x lb) rb

find :: Ord a => a -> Tree a -> Maybe a
find a Leaf = Nothing
find x (Node y lb rb) = 
    if ( x < y ) then 
        if (x == y) then
            Just x
                else
            find x rb
            else 
        find x lb

delete :: Ord a => a -> Tree a -> Tree a
delete x (Node y lb rb) = 
    if ( x < y ) then 
        if (x == y) then
            findReplacement lb rb
                else
            Node y lb ( delete x rb)
            else 
        Node y ( delete x lb) rb

findReplacement Leaf = Nothing














printTree :: Show a => Tree a -> IO ()
printTree = mapM_ putStrLn . treeIndent
  where
    treeIndent Leaf           = ["-- /-"]
    treeIndent (Node k lb rb) =
      ["--" ++ show k] ++
      map ("  |" ++) ls ++
      ("  `" ++ r) : map ("   " ++) rs
      where
        (r:rs) = treeIndent rb
        ls     = treeIndent lb
