module Bench.Countdown.Eff (countdown, countdownDeep) where

import "eff" Control.Effect qualified as EF

program :: EF.State Int EF.:< es => EF.Eff es Int
program = do
    x <- EF.get @Int
    if x == 0 then pure x else EF.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = EF.run $ EF.runState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = EF.run $ runR $ runR $ runR $ runR $ runR $ EF.runState n $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = EF.runReader ()