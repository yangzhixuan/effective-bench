module Bench.Local.Eff (localBench, localDeep) where

import "eff" Control.Effect qualified as E

program :: E.Reader Int E.:< es => Int -> E.Eff es Int
program = \case
    0 -> E.ask
    n -> E.local (+ (1 :: Int)) (program (n - 1))

localBench :: Int -> Int
localBench n = E.run $ E.runReader (0 :: Int) $ program n

localDeep :: Int -> Int
localDeep n = E.run $ runR $ runR $ runR $ runR $ runR $ E.runReader (0 :: Int) $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = E.runReader ()
