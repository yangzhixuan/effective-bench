module Bench.Catch.Effective where

import "effective" Control.Effect
import "effective" Control.Effect.Except
import "effective" Control.Effect.Reader

program :: Int -> a ! '[Throw (), Catch ()]
program = \case
  0 -> throw ()
  n -> catch (program (n - 1)) \() -> throw ()

catchBench :: Int -> Either () ()
catchBench n = handle except (program n)

catchDeep :: Int -> Either () ()
catchDeep n = handle (run ++> run ++> run ++> run ++> run ++> except ++>
                         run ++> run ++> run ++> run ++> run) (program n)
  where run = asker ()