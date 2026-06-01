#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.FusedEffects where
#else
module Bench.Countdown.VeryDeep.FusedEffects (countdown, countdownDeep) where

import Control.Carrier.Reader qualified as F
import Control.Carrier.State.Strict qualified as F

program :: F.Has (F.State Int) sig m => m Int
program = do
    x <- F.get @Int
    if x == 0 then pure x else F.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = F.run $ F.runState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = F.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ F.runState n $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = F.runReader ()

#endif
