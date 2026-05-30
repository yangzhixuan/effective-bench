module Bench.Catch.Effective where

import "effective" Control.Effect
import "effective" Control.Effect.Except
import "effective" Control.Effect.Reader

programEffective :: Int -> a ! '[Throw (), Catch ()]
programEffective = \case
  0 -> throw ()
  n -> catch (programEffective (n - 1)) \() -> throw ()

catchBench :: Int -> Either () ()
catchBench n = handle except (programEffective n)

catchDeep :: Int -> Either () ()
catchDeep n = handle (run ++> run ++> run ++> run ++> run ++> except ++>
                                  run ++> run ++> run ++> run ++> run) (programEffective n)
  where run = asker ()