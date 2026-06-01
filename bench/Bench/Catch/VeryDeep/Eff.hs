#ifdef DISABLE_VERY_DEEP
module Bench.Catch.VeryDeep.Eff where
#else
module Bench.Catch.VeryDeep.Eff (catchBench, catchDeep) where

import "eff" Control.Effect qualified as E

program :: E.Error () E.:< es => Int -> E.Eff es a
program = \case
    0 -> E.throw ()
    n -> E.catch (program (n - 1)) \() -> E.throw ()

catchBench :: Int -> Either () ()
catchBench n = E.run $ E.runError $ program n

catchDeep :: Int -> Either () ()
catchDeep n = E.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ E.runError $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = E.runReader ()
#endif
