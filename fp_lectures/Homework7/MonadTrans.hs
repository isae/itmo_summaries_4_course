import Control.Monad
import Control.Applicative
import Control.Monad.Trans.Class
import Data.Functor.Identity

-- some copy-paste from Control.Monad.Trans.*
newtype StateT s m a = StateT { runStateT :: s -> m (a,s) }
newtype WriterT w m a = WriterT { runWriterT :: m (a, w) }
newtype EitherT e m a = EitherT { runEitherT :: m (Either e a) }

instance Monad m => Functor (EitherT e m) where
  fmap f = EitherT . liftM (fmap f) . runEitherT

instance Monad m => Applicative (EitherT e m) where
  pure a  = EitherT $ return (Right a)
  EitherT f <*> EitherT v = EitherT $ f >>= \mf -> case mf of
    Left  e -> return (Left e)
    Right k -> v >>= \mv -> case mv of
      Left  e -> return (Left e)
      Right x -> return (Right (k x))

mapWriterT f m = WriterT $ f (runWriterT m)
instance (Functor m) => Functor (WriterT w m) where
    fmap f = mapWriterT $ fmap $ \ ~(a, w) -> (f a, w)

instance (Monoid w, Applicative m) => Applicative (WriterT w m) where
    pure a  = WriterT $ pure (a, mempty)
    f <*> v = WriterT $ liftA2 k (runWriterT f) (runWriterT v)
      where k ~(a, w) ~(b, w') = (a b, w `mappend` w')

runState m s = return runStateT m s

instance (Functor m) => Functor (StateT s m) where
    fmap f m = StateT $ \ s ->
        fmap (\ ~(a, s') -> (f a, s')) $ runStateT m s

instance (Functor m, Monad m) => Applicative (StateT s m) where
    pure = return
    (<*>) = ap

--instances
instance (Monad m) => Monad (StateT s m) where
    return a = undefined
    m >>= f  = undefined

instance MonadTrans (StateT s) where
    lift m = undefined

instance (Monoid w, Monad m) => Monad (WriterT w m) where
    return a = undefined
    m >>= f  = undefined

instance (Monoid w) => MonadTrans (WriterT w) where
    lift m = undefined

instance Monad m => Monad (EitherT l m) where
    return  = undefined
    m >>= f = undefined

instance MonadTrans (EitherT l) where
    lift m = undefined

-- list transformer
newtype ListT m a = ListT { runListT :: m [a] }

instance Show (ListT m a) where
    show listT = "sosi"

instance (Functor m) => Functor (ListT m) where
    fmap f listT = ListT $ map f <$> runListT listT

instance (Functor m, Monad m) => Applicative (ListT m) where
    pure = return
    (<*>) = ap

instance (Monad m) => Monad (ListT m) where
    return a = ListT $ return [a]
    listT >>= f = f2 <$> listM where
        listM = fmap f <$> runListT listT
        f2 list = fmap (runListT $ return) list

instance MonadTrans ListT where
    lift m = undefined
