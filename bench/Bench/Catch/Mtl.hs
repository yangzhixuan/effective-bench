module Bench.Catch.Mtl (catchBench, catchDeep) where

import Control.Monad.Except qualified as M
import Control.Monad.Identity qualified as M
import Control.Monad.Reader qualified as M

program :: M.MonadError () m => Int -> m a
program = \case
    0 -> M.throwError ()
    n -> M.catchError (program (n - 1)) \() -> M.throwError ()

catchBench :: Int -> Either () ()
catchBench n = M.runExcept $ program n

catchDeep :: Int -> Either () ()
catchDeep n = M.runIdentity $ runR $ runR $ runR $ runR $ runR $ M.runExceptT $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = (`M.runReaderT` ())