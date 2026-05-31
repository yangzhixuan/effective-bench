module Bench.Catch.EffectiveLightlyStaged (catchDeep) where

import "effective" Control.Effect
import "effective" Control.Effect.Except
import "effective" Control.Effect.Reader

program :: Int -> a ! '[Throw (), Catch ()]
program = \case
  0 -> throw ()
  n -> catch (program (n - 1)) \() -> throw ()

catchDeep :: Int -> Either () ()
catchDeep n =
    $$(let run = askerC [|| () ||]
       in handleC
            (run ++>$ run ++>$ run ++>$ run ++>$ run ++>$ exceptC
                 ++>$ run ++>$ run ++>$ run ++>$ run ++>$ run)
            [|| program n ||])
