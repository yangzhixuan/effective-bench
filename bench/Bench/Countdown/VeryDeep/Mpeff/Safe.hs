#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.Mpeff.Safe where
#else
module Bench.Countdown.VeryDeep.Mpeff.Safe (countdown, countdownDeep) where

import Control.Mp.Eff qualified as Mp
import Bench.Mpeff qualified as Mpeff

program :: (Mpeff.State Int Mp.:? e) => Mp.Eff e Int
program = do
    x <- Mpeff.get
    if x == 0 then pure x else Mpeff.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = Mp.runEff $ Mpeff.runState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ Mpeff.runState n $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = Mpeff.runReader ()
#endif
