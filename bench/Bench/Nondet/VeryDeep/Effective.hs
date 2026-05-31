#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.Effective where
#else
module Bench.Nondet.VeryDeep.Effective (pyth, pythDeep) where

import "effective" Control.Effect
import "effective" Control.Effect.Nondet.Logic
import "effective" Control.Effect.Alternative
import "effective" Control.Effect.Reader

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
        (run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> list
             ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run ++> run)
        (program n)
  where
    run = asker ()
#endif
