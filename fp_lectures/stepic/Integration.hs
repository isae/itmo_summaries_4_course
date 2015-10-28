integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b = (\x->(+)$step*(f x)) `foldl'` 0 [a,a+step..b]
 where
    step = (b-a)/1000
