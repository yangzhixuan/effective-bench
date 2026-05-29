module Bench.Nondet.Polysemy (pyth, pythDeep) where

import Control.Applicative (Alternative (empty, (<|>)))
import Polysemy qualified as P
import Polysemy.NonDet qualified as P
import Polysemy.Reader qualified as P

program :: P.Member P.NonDet es => Int -> P.Sem es (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice 0 = empty
    choice n = choice (n - 1) <|> pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = P.run $ P.runNonDet $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = P.run $ runR $ runR $ runR $ runR $ runR $ P.runNonDet $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = P.runReader ()
