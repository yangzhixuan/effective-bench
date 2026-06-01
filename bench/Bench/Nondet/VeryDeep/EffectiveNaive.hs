#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.EffectiveNaive where
#else
module Bench.Nondet.VeryDeep.EffectiveNaive (pyth, pythDeep) where

import "effective-naive" Control.Effect
import "effective-naive" Control.Effect.Nondet.Logic
import "effective-naive" Control.Effect.Alternative
import "effective-naive" Control.Effect.Reader

program :: Int -> (Int, Int, Int) ! '[Empty, Choose]
program upbound = do
    x <- choice upbound
    y <- choice upbound
    z <- choice upbound
    if x * x + y * y == z * z then pure (x, y, z) else empty
  where
    choice 0 = empty
    choice n = choice (n - 1) <|> pure n

pyth :: Int -> [(Int, Int, Int)]
pyth n = handle list (program n)

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n =
    handle
        (run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> list
             ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run)
        (program n)
  where
    run = asker ()
#endif
