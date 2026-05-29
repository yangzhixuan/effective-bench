module Bench.Countdown.Polysemy (countdown, countdownDeep) where

import Polysemy qualified as P
import Polysemy.Reader qualified as P
import Polysemy.State qualified as P

program :: P.Member (P.State Int) es => P.Sem es Int
program = do
    x <- P.get @Int
    if x == 0 then pure x else P.put (x - 1) >> program

countdown :: Int -> (Int, Int)
countdown n = P.run $ P.runState n program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = P.run $ runR $ runR $ runR $ runR $ runR $ P.runState n $ runR $ runR $ runR $ runR $ runR $ program
  where
    runR = P.runReader ()

