class Iterable l where
  peek :: l a -> a
  next :: l a -> (a, l a)
  hasElements :: l a -> Bool

instance Iterable [] where
  peek = head
  next l = ((head l), (tail l))
  hasElements l = (length l) /= 0
