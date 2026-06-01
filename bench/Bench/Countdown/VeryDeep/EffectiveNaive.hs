#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.EffectiveNaive where
#else
module Bench.Countdown.VeryDeep.EffectiveNaive (countdown, countdownDeep) where

import "effective-naive" Control.Effect
import "effective-naive" Control.Effect.Reader
import "effective-naive" Control.Effect.State

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
