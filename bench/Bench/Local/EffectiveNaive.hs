module Bench.Local.EffectiveNaive (localBench, localDeep) where

import "effective-naive" Control.Effect
import "effective-naive" Control.Effect.Reader

program :: Int -> Int ! '[Ask Int, Local Int]
program = \case
    0 -> ask
    n -> local (+ (1 :: Int)) (program (n - 1))

localBench :: Int -> Int
localBench n = handle (reader (0 :: Int)) (program n)

localDeep :: Int -> Int
localDeep n =
    handle
        (run ++> run ++> run ++> run ++> run ++> reader (0 :: Int)
             ++> run ++> run ++> run ++> run ++> run)
        (program n)
  where
    run = asker ()
