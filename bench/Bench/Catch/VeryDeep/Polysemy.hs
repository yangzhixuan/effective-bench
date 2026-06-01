#ifdef DISABLE_VERY_DEEP
module Bench.Catch.VeryDeep.Polysemy where
#else
module Bench.Catch.VeryDeep.Polysemy (catchBench, catchDeep) where

import Polysemy qualified as P
import Polysemy.Error qualified as P
import Polysemy.Reader qualified as P

program :: P.Member (P.Error ()) es => Int -> P.Sem es a
program = \case
    0 -> P.throw ()
    n -> P.catch (program (n - 1)) \() -> P.throw ()

catchBench :: Int -> Either () ()
catchBench n = P.run $ P.runError $ program n

catchDeep :: Int -> Either () ()
catchDeep n = P.run $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ P.runError $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = P.runReader ()
#endif
