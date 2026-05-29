module Bench.Nondet.MtlLogict (pyth, pythDeep) where

import Control.Applicative (Alternative (empty, (<|>)))
import Control.Monad (MonadPlus)
import Control.Monad.Identity qualified as M
import Control.Monad.Logic qualified as M
import Control.Monad.Reader qualified as M

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
pyth n = M.observeAll $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = M.runIdentity $ runR $ runR $ runR $ runR $ runR $ M.observeAllT $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = (`M.runReaderT` ())