#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.Heftia where
#else
module Bench.Nondet.VeryDeep.Heftia (pyth, pythDeep) where

import Control.Monad.Hefty qualified as H
import Control.Monad.Hefty.NonDet qualified as H
import Control.Monad.Hefty.Reader qualified as H

program :: (H.Choose H.:> es, H.Empty H.:> es) => Int -> H.Eff es (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else H.empty
  where
    choice :: (H.Choose H.:> es, H.Empty H.:> es) => Int -> H.Eff es Int
    choice 0 = H.empty
    choice n = choice (n - 1) `H.branch` pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = H.runPure $ H.runNonDet $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = H.runPure $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ H.runNonDet $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = H.runAsk ()
#endif
