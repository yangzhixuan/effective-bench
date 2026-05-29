module Bench.Local.Mpeff.Safe (localBench, localDeep) where

import Bench.Mpeff qualified as Mpeff
import Control.Mp.Eff qualified as Mp

program :: Int -> Mp.Eff (Mpeff.Reader Int Mp.:* e) Int
program = \case
    0 -> Mpeff.ask
    n -> Mpeff.local (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = Mp.runEff $ Mpeff.runReader 0 $ program n

localDeep :: Int -> Int
localDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ Mpeff.runReader 0 $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ program n
  where
    runR = Mpeff.runReader ()
