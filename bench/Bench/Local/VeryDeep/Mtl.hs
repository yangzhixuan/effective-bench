#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.Mtl where
#else
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}

module Bench.Local.VeryDeep.Mtl (localBench, localDeep) where

import Control.Monad.Identity qualified as M
import Control.Monad.Reader qualified as M

newtype R m a = R (M.ReaderT () m a)

runR :: R m a -> m a
runR (R m) = M.runReaderT m ()

instance Functor m => Functor (R m) where
    fmap f (R m) = R (fmap f m)

instance Applicative m => Applicative (R m) where
    pure = R . pure
    R f <*> R x = R (f <*> x)

instance Monad m => Monad (R m) where
    R m >>= f = R (m >>= \x -> case f x of R y -> y)

instance M.MonadReader r m => M.MonadReader r (R m) where
    ask = R (M.lift M.ask)
    local f (R m) = R (M.mapReaderT (M.local f) m)

program :: M.MonadReader Int m => Int -> m Int
program = \case
    0 -> M.ask
    n -> M.local (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = M.runReader (program n) 0

localDeep :: Int -> Int
localDeep n = M.runIdentity $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ M.runReaderT (runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n) 0
#endif
