import BinTree as B
import Control.Monad.Identity

-- tree
instance Foldable B.Tree where
    foldMap f B.Leaf = mempty
    foldMap f (Tree k l r) = foldMap f l `mappend` f k `mappend` foldMap f r

instance Functor B.Tree where
    fmap f B.Leaf = B.Leaf
    fmap f (B.Tree k l r) = B.Tree (f k) (fmap f l) (fmap f r)

instance Traversable B.Tree where
    traverse f B.Leaf = pure B.Leaf
    traverse f (B.Tree k l r) = B.Tree <$> f k <*> traverse f l <*>traverse f r

instance Applicative B.Tree where
    pure n = B.Tree n B.Leaf B.Leaf
    B.Leaf <*> v = B.Leaf
    (B.Tree f l r) <*> t = fmap f t

-- Identity
data MyId x = MyId x

instance Foldable MyId where
    foldMap f (MyId x) = f x

instance Functor MyId where
    fmap f (MyId x) = MyId (f x)

instance Applicative MyId where
    pure = MyId
    (MyId f) <*> (MyId x) = MyId (f x)

instance Traversable MyId where
    traverse f (MyId x) = MyId <$> (f x)

--Either
data MyEither a b = MyLeft a | MyRight b

instance Foldable (MyEither a) where
    foldMap _ (MyLeft a) = mempty 
    foldMap f (MyRight x) = f x

instance Functor (MyEither a) where
    fmap _ (MyLeft a) = MyLeft a 
    fmap f (MyRight x) = MyRight $ f x

instance Applicative (MyEither a) where
    pure = MyRight
    (MyLeft f) <*> _ = MyLeft f
    _ <*> (MyLeft x) = MyLeft x
    (MyRight f) <*> (MyRight x) = MyRight (f x)

instance Traversable (MyEither a) where
    traverse _ (MyLeft x) = pure (MyLeft x)
    traverse f (MyRight x) = MyRight <$> (f x)

--pair
data Pair a b = Pair a b

instance Foldable (Pair a) where
    foldr f b (Pair x y) = f y b

instance Functor (Pair a) where
    fmap f (Pair x y) = Pair x (f y)

instance Traversable (Pair a) where
    sequenceA (Pair x y) = fmap (Pair x) y

instance Monoid a => Applicative (Pair a) where
    pure x = Pair mempty x
    (Pair x f) <*> (Pair y z) = Pair (mappend x y) (f z)

-- const
data Const a m = Const a

instance Foldable (Const m) where
    foldr _ x _ = x

instance Functor (Const m) where
    fmap _ (Const x) = Const x

instance Traversable (Const m) where
    sequenceA (Const x) = pure (Const x)

instance Monoid m => Applicative (Const m) where
    pure _ = Const mempty
    (Const x) <*> (Const y) = Const (mappend x y)
