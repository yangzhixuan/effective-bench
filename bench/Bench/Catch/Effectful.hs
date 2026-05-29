module Bench.Catch.Effectful (catchBench, catchDeep) where

import Effectful qualified as EL
import Effectful.Error.Dynamic qualified as EL
import Effectful.Reader.Dynamic qualified as EL

program :: EL.Error () EL.:> es => Int -> EL.Eff es a
program = \case
    0 -> EL.throwError ()
    n -> EL.catchError (program (n - 1)) \_ () -> EL.throwError ()

catchBench :: Int -> Either (EL.CallStack, ()) ()
catchBench n = EL.runPureEff $ EL.runError $ program n

catchDeep :: Int -> Either (EL.CallStack, ()) ()
catchDeep n = EL.runPureEff $ runR $ runR $ runR $ runR $ runR $ EL.runError $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = EL.runReader ()