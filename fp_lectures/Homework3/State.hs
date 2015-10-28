{-# LANGUAGE NoImplicitPrelude, FlexibleInstances, UndecidableInstances #-}
newtype State s a = Sate { runState :: s -> (a,s)}

instance Monad (State s)where
    return a = State $ \s -> a,s)
    (>>=) l r =
