module Bench.Nondet.Eff (pyth, pythDeep) where

import Control.Applicative (Alternative (empty, (<|>)))
import "eff" Control.Effect qualified as EF

program :: EF.NonDet EF.:< es => Int -> EF.Eff es (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice 0 = empty
    choice n = choice (n - 1) <|> pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = EF.run $ EF.runNonDetAll $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = EF.run $ runR $ runR $ runR $ runR $ runR $ EF.runNonDetAll $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = EF.runReader ()