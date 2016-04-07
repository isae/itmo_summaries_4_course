{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FlexibleContexts #-}
module MapVar where 
import BinTree as B
import Data.Maybe as M
import Data.List as L

class MapVar m v where
    put :: String -> v -> m v -> m v
    get :: String -> m v -> Maybe v

newtype MaybeMap v = MaybeMap (Maybe (String, v)) deriving (Show)
newtype ListMap v = ListMap ([(String, v)]) deriving (Show)
newtype TreeMap v = TreeMap (B.Tree(String, v)) deriving (Show)

instance MapVar MaybeMap v where
    put str value _ = MaybeMap(Just (str,value))
    get str1 (MaybeMap (Just(str,val))) = if (str == str1) 
                                          then Just val
                                          else Nothing 
    get _ (MaybeMap(Nothing)) = Nothing 

instance MapVar ListMap v where
    put str value (ListMap(xs)) = 
            let ind = L.findIndex (\(key,value) -> key == str) xs in 
                if ind == Nothing
                    then (ListMap((str,value):xs))
                    else (ListMap(
                        (take (M.fromJust ind) xs) ++ 
                        ((str,value):(drop ((M.fromJust ind)+1) xs))))
 
    get str (ListMap(xs)) = getValue $  L.find (\(key,value) -> str == key) xs 
                where
                    getValue (Just(key,value)) = Just value
                    getValue Nothing = Nothing 


instance MapVar TreeMap v where
    put str value (TreeMap tree) = (TreeMap( putToTree str value tree)) where  
        putToTree str val (Tree all@(key,value) l r) = 
                if (str == key) then (Tree (str,val) l r) 
                    else if (str<key) then (Tree all (putToTree str value l) r) 
                                      else (Tree all l (putToTree str value r)) 
        putToTree str val B.Leaf = (Tree (str,val) B.Leaf B.Leaf)
    get str1 (TreeMap(t)) = getFromTree t where 
        getFromTree (B.Tree all@(key,value) l r) = if (key == str1) then Just value
            else if (key < str1) then getFromTree l else getFromTree r 
        getFromTree B.Leaf = Nothing

