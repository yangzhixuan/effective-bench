module Bench.Local.Polysemy (localBench, localDeep) where

import Polysemy qualified as P
import Polysemy.Reader qualified as P

program :: P.Member (P.Reader Int) es => Int -> P.Sem es Int
program = \case
    0 -> P.ask
    n -> P.local @Int (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = P.run $ P.runReader @Int 0 $ program n

localDeep :: Int -> Int
localDeep n = P.run $ runR $ runR $ runR $ runR $ runR $ P.runReader @Int 0 $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = P.runReader ()

