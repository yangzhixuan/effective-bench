#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.HandrolledListT where
#else
module Bench.Nondet.VeryDeep.HandrolledListT where

import Control.Applicative
import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Data.Functor.Identity
import ListT qualified

type M1 a = ListT.ListT Identity a

type R50T m = ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () (m))))))))))))))))))))))))))))))))))))))))))))))))))

type M2 a = R50T (ListT.ListT (R50T Identity)) a

choice1 :: Int -> M1 Int
choice1 0 = empty
choice1 n = choice1 (n - 1) <|> pure n

program1 :: Int -> M1 (Int, Int, Int)
program1 upbound = do
    x <- choice1 upbound
    y <- choice1 upbound
    z <- choice1 upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty

choice2 :: Int -> M2 Int
choice2 0 = lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ lift $ empty
choice2 n = choice2 (n - 1) <|> pure n

program2 :: Int -> M2 (Int, Int, Int)
program2 upbound = do
    x <- choice2 upbound
    y <- choice2 upbound
    z <- choice2 upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty

pyth :: Int -> [(Int, Int, Int)]
pyth n = runIdentity $ ListT.toList $ program1 n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = runIdentity $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ ListT.toList $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program2 n
  where
    runR :: ReaderT () m a -> m a
    runR m = runReaderT m ()
#endif
