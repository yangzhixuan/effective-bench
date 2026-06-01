#ifdef DISABLE_VERY_DEEP
module Bench.Catch.VeryDeep.FusedEffects where
#else
module Bench.Catch.VeryDeep.FusedEffects (catchBench, catchDeep) where

import Control.Carrier.Error.Either qualified as F
import Control.Carrier.Reader qualified as F

program :: F.Has (F.Error ()) sig m => Int -> m a
program = \case
    0 -> F.throwError ()
    n -> F.catchError (program (n - 1)) \() -> F.throwError ()

catchBench :: Int -> Either () ()
catchBench n = F.run $ F.runError $ program n

catchDeep :: Int -> Either () ()
catchDeep n = F.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ F.runError $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = F.runReader ()

#endif
