#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.Effective where
#else
module Bench.Countdown.VeryDeep.Effective (countdown, countdownDeep) where

import "effective" Control.Effect
import "effective" Control.Effect.Reader
import "effective" Control.Effect.State

program :: Int ! '[Get Int, Put Int]
program = do
    x <- get @Int
    if x == 0
        then pure x
        else do
            put (x - 1)
            program

countdown :: Int -> (Int, Int)
countdown n = handle (state n) program

countdownDeep :: Int -> (Int, Int)
countdownDeep n =
    handle
        (run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> state n
             ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run)
        program
  where run = asker ()
#endif
