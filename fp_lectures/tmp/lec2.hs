first :: a -> a -> a
first x y = x

f n = if n <=1
    then 1
    else n * f (n-1 )
getFont n  = case n of
    0 -> "PLAIN"
apply a b f = f a b
ff 0 = 1
ff n = n * f (n-1)
