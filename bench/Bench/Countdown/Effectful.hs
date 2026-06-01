module Bench.Countdown.Effectful (countdown, countdownDeep) where

import Effectful qualified as EL
import Effectful.Reader.Dynamic qualified as EL
import Effectful.State.Dynamic qualified as EL

program :: EL.State Int EL.:> es => EL.Eff es Int
program = do
    x <- EL.get @Int
    if x == 0 then pure x else EL.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = EL.runPureEff $ EL.runStateLocal n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = EL.runPureEff $ runR $ runR $ runR $ runR $ runR $ EL.runStateLocal n $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = EL.runReader ()