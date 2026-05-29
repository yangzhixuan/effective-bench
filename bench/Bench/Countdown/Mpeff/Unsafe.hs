module Bench.Countdown.Mpeff.Unsafe (countdown, countdownDeep) where

import Control.Mp.Eff qualified as Mp
import Control.Mp.Util qualified as Mp
import Bench.Mpeff qualified as Mpeff

program :: (Mp.State Int Mp.:? e) => Mp.Eff e Int
program = do
    x <- Mp.perform (Mp.get @Int) ()
    if x == 0 then pure x else Mp.perform Mp.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = Mp.runEff $ Mpeff.runMpState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ Mpeff.runMpState n $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = Mp.reader ()
