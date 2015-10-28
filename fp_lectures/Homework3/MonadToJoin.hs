{-# LANGUAGE NoImplicitPrelude, FlexibleInstances, UndecidableInstances #-}
import FishJoin as F


instance F.Monad m => F.MonadJoin m where
    returnJoin = return
    join mma = mma >>= (\x -> x)
