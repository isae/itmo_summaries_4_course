{-# LANGUAGE NoImplicitPrelude, FlexibleInstances, UndecidableInstances #-}
import FishJoin

instance MonadFish m => MonadJoin m where
    returnJoin = returnFish
    join mma = ((\x->x) >=> (\x->x)) mma
