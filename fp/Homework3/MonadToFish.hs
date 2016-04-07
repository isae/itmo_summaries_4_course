{-# LANGUAGE NoImplicitPrelude, FlexibleInstances, UndecidableInstances #-}
import FishJoin as F

instance F.Monad m => F.MonadFish m where
    returnFish = return
    (>=>) l r = \a->(l a) >>= r
