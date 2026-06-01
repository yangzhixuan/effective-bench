#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.EffectiveLightlyStaged where
#else
module Bench.Countdown.VeryDeep.EffectiveLightlyStaged (countdownDeep) where

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

countdownDeep :: Int -> (Int, Int)
countdownDeep n =
    $$(let run = askerC [|| () ||]
       in handleC
            (run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ stateC [|| n ||]
                 ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run)
            [|| program ||])
#endif
