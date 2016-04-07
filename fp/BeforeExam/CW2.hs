import Control.Monad.State

-- task1
-- N-th Fibonacci number using State monad
type LastTwo = (Int,Int)
type Stack = [Int]

inc :: State LastTwo ()
inc = state $ \(a,b) -> ((), ((a+b), a))

fibNstate :: Int -> State LastTwo ()

fubNstate 0 = do return
fibNstate n = do
  inc
  fibNstate $ n-1

pop :: State Stack Int
pop = state $ \(x:xs) -> (x,xs)

push :: Int -> State Stack ()
push a = state $ \xs -> ((),a:xs)

stackManip :: State Stack Int
stackManip = do
    push 3
    a <- pop
    pop
