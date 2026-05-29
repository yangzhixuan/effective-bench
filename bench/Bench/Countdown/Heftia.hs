module Bench.Countdown.Heftia (countdown, countdownDeep) where

import Control.Monad.Hefty qualified as H
import Control.Monad.Hefty.Reader qualified as H
import Control.Monad.Hefty.State qualified as H

program :: (H.State Int H.:> es) => H.Eff es Int
program = do
    x <- H.get @Int
    if x == 0 then pure x else H.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = H.runPure $ H.runState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = H.runPure $ hrunR $ hrunR $ hrunR $ hrunR $ hrunR $ H.runState n $ hrunR $ hrunR $ hrunR $ hrunR $ hrunR $ program
  where
    hrunR = H.runAsk ()
