#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.Heftia where
#else
module Bench.Local.VeryDeep.Heftia (localBench, localDeep) where

import Control.Monad.Hefty qualified as H
import Control.Monad.Hefty.Reader qualified as H
-- import "data-effects" Control.Effect.Interpret qualified as HD

program :: (H.Ask Int `H.In` es, H.Local Int `H.In` es) => Int -> H.Eff es Int
program = \case
    0 -> H.ask'_
    n -> H.local'_ @Int (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = H.runPure $ H.runAsk @Int 0 $ H.runLocal @Int $ program n

localDeep :: Int -> Int
localDeep n = H.runPure $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ H.runAsk @Int 0 $ H.runLocal @Int $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ hrun $ program n
  where
    hrun = H.runAsk ()
#endif
