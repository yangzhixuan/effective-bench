#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.FusedEffects where
#else
module Bench.Nondet.VeryDeep.FusedEffects (pyth, pythDeep) where

import Control.Applicative (Alternative (empty))
import Control.Carrier.NonDet.Church qualified as F
import Control.Carrier.Reader qualified as F

program :: (Monad m, Alternative m) => Int -> m (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice x = F.oneOf [1 .. x]

pyth :: Int -> [(Int, Int, Int)]
pyth n = F.run $ F.runNonDetA $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = F.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ F.runNonDetA $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = F.runReader ()
#endif
