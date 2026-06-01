#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.MtlListT where
#else
module Bench.Nondet.VeryDeep.MtlListT (pyth, pythDeep) where

import Control.Applicative (Alternative (empty, (<|>)))
import Control.Monad (MonadPlus)
import Control.Monad.Identity qualified as M
import Control.Monad.Reader qualified as M
import ListT qualified as M

program :: MonadPlus m => Int -> m (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice 0 = empty
    choice n = choice (n - 1) <|> pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = M.runIdentity $ M.toList $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = M.runIdentity $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ M.toList $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = (`M.runReaderT` ())
#endif
