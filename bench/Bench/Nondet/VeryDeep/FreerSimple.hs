#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.FreerSimple where
#else
module Bench.Nondet.VeryDeep.FreerSimple (pyth, pythDeep) where

import Control.Applicative (Alternative (empty, (<|>)))
import Control.Monad.Freer qualified as FS
import Control.Monad.Freer.NonDet qualified as FS
import Control.Monad.Freer.Reader qualified as FS

program :: FS.Member FS.NonDet es => Int -> FS.Eff es (Int, Int, Int)
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice 0 = empty
    choice n = choice (n - 1) <|> pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = FS.run $ FS.makeChoiceA $ program n

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n = FS.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR
                    $ FS.makeChoiceA
                    $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR
                    $ program n
  where
    runR = FS.runReader ()
#endif
