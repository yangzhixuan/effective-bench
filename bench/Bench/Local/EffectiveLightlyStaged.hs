module Bench.Local.EffectiveLightlyStaged (localDeep) where

import "effective" Control.Effect
import "effective" Control.Effect.Reader

program :: Int -> Int ! '[Ask Int, Local Int]
program = \case
    0 -> ask
    n -> local (+ (1 :: Int)) (program (n - 1))

localDeep :: Int -> Int
localDeep n =
    $$(let run = askerC [|| () ||]
        in handleC
             (run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ readerC [|| 0 :: Int ||]
                  ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run)
                [|| program n ||])
