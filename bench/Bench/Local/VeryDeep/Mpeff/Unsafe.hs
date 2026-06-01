#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.Mpeff.Unsafe where
#else
module Bench.Local.VeryDeep.Mpeff.Unsafe (localBench, localDeep) where

import Control.Mp.Eff qualified as Mp
import Control.Mp.Util qualified as Mp
import Bench.Mpeff qualified as Mpeff

program :: Int -> Mp.Eff (Mpeff.Reader Int Mp.:* e) Int
program = \case
    0 -> Mpeff.ask
    n -> Mpeff.local (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = Mp.runEff $ Mpeff.runReader 0 $ program n

localDeep :: Int -> Int
localDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ Mpeff.runReader 0 $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ runR $ Mp.mask $ program n
  where
    runR = Mp.reader ()
#endif
