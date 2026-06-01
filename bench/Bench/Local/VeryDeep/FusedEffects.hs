#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.FusedEffects where
#else
module Bench.Local.VeryDeep.FusedEffects (localBench, localDeep) where

import Control.Carrier.Reader qualified as F

program :: F.Has (F.Reader Int) sig m => Int -> m Int
program = \case
    0 -> F.ask
    n -> F.local @Int (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = F.run $ F.runReader @Int 0 $ program n

localDeep :: Int -> Int
localDeep n = F.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ F.runReader @Int 0 $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = F.runReader ()

#endif
