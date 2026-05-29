module Bench.Nondet.Mpeff.Safe (pyth, pythDeep) where

import Bench.Mpeff qualified as Mpeff
import Control.Mp.Eff qualified as Mp
import Control.Mp.Util qualified as Mp

program :: (Mp.Choose Mp.:? e) => Int -> Mp.Eff e (Int, Int, Int)
program upbound = do
    x <- Mp.perform Mp.choose upbound
    y <- Mp.perform Mp.choose upbound
    z <- Mp.perform Mp.choose upbound
    if x * x + y * y == z * z then pure (x, y, z) else Mp.perform (\r -> Mp.none r) ()

pyth :: Int -> [(Int, Int, Int)]
pyth n = Mp.runEff $ Mp.chooseAll $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ Mp.chooseAll $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = Mpeff.runReader ()
