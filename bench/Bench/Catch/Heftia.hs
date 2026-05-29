module Bench.Catch.Heftia (catchBench, catchDeep) where

import Control.Monad.Hefty qualified as H
import Control.Monad.Hefty.Except qualified as H
import Control.Monad.Hefty.Reader qualified as H

program :: (H.Throw () H.:> es, H.Catch () H.:> es) => Int -> H.Eff es a
program = \case
    0 -> H.throw ()
    n -> H.catch (program (n - 1)) \() -> H.throw ()

catchBench :: Int -> Either () ()
catchBench n = H.runPure $ H.runThrow $ H.runCatch @() $ program n

catchDeep :: Int -> Either () ()
catchDeep n = H.runPure $ hrun $ hrun $ hrun $ hrun $ hrun $ H.runThrow $ H.runCatch @() $ hrun $ hrun $ hrun $ hrun $ hrun $ program n
  where
    hrun = H.runAsk ()
