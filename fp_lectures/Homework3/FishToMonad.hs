{-# LANGUAGE NoImplicitPrelude, FlexibleInstances, UndecidableInstances #-}
import FishJoin as F

instance F.MonadFish m => F.Monad m where
    return = returnFish
    ma >>= amb = ((\x -> x) >=> amb) ma
