module LocaltimeTemplate where

import Language.Haskell.TH

fib 0 = 1
fib 1 = 1
fib n = (fib $ n-1) + (fib $ n-2)
ctFib :: Int -> Q Exp
ctFib n = do
  return $ LitE ( IntegerL (fib n) )
