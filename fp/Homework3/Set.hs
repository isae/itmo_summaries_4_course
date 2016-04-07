module Set where

import qualified BinTree as B
import Data.List as DL hiding (insert)

instance Foldable B.Tree where 
    foldr f list (B.Tree x l r) = foldr f (f x (foldr f list l)) r
    foldr f list B.Leaf = list

class Set t where
    emptySet :: t a
    toList   :: t a -> [a]
    find     :: Ord a => a -> t a -> Maybe a
    insert   :: Ord a => a -> t a -> t a
    delete   :: Ord a => a -> t a -> t a
    next     :: Ord a => a -> t a -> Maybe a
    fromList :: Ord a => [a] -> t a
    fromList list = foldr insert emptySet list

instance Set B.Tree where
    emptySet = B.Leaf
    toList tree = foldr (:) [] tree 
    find = B.find
    insert = B.insert 
    delete = B.delete
    next elem tree  = DL.find (>elem) $ toList tree
    fromList list = foldr (B.insert) B.Leaf list
