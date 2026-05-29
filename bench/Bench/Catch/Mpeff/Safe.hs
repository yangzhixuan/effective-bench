module Bench.Catch.Mpeff.Safe (catchBench, catchDeep) where

import Bench.Mpeff qualified as Mpeff
import Control.Mp.Eff qualified as Mp
import Control.Mp.Util qualified as Mp

program :: (Mp.Except () Mp.:? e) => Int -> Mp.Eff e a
program = \case
    0 -> Mp.perform (\h -> Mp.throwError h) ()
    n -> Mp.catchError (program (n - 1)) \() -> Mp.perform (\h -> Mp.throwError h) ()

catchBench :: Int -> Either () ()
catchBench n = Mp.runEff $ Mp.exceptEither $ program n

catchDeep :: Int -> Either () ()
catchDeep n = Mp.runEff $ runR $ runR $ runR $ runR $ runR $ Mp.exceptEither $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = Mpeff.runReader ()
