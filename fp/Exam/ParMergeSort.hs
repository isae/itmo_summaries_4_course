import Control.Parallel.Strategies
import Data.Time.Clock

sort :: (Ord a) => [a] -> [a]
sort = sortBy compare

sortBy :: (a -> a -> Ordering) -> [a] -> [a]
sortBy pred []   = []
sortBy pred [x]  = [x]
sortBy pred xs = runEval $ do
  let (xs1,xs2) = split xs
  left <- rpar (sortBy pred xs1)
  right <- rpar (sortBy pred xs2)
  return $ merge pred left right

split :: [a] -> ([a],[a])
split (x:y:zs) = (x:xs,y:ys) where (xs,ys) = split zs
split xs       = (xs,[])

merge :: (a -> a -> Ordering) -> [a] -> [a] -> [a]
merge pred xs []         = xs
merge pred [] ys         = ys
merge pred (x:xs) (y:ys)
    | pred x y == LT = x: merge pred xs (y:ys)
    | otherwise = y: merge pred (x:xs) ys

main :: IO()
main = do
  timeBefore <- getCurrentTime
  print $ sort [1000001, 999999..1]
  timeAfter <- getCurrentTime
  print $ diffUTCTime timeBefore timeAfter
