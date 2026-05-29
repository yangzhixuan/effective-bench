module Bench.Local.Effectful (localBench, localDeep) where

import Effectful qualified as EL
import Effectful.Reader.Dynamic qualified as EL

program :: EL.Reader Int EL.:> es => Int -> EL.Eff es Int
program = \case
    0 -> EL.ask
    n -> EL.local @Int (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = EL.runPureEff $ EL.runReader @Int 0 $ program n

localDeep :: Int -> Int
localDeep n = EL.runPureEff $ runR $ runR $ runR $ runR $ runR $ EL.runReader @Int 0 $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = EL.runReader ()