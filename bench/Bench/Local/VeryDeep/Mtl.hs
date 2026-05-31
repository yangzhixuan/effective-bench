#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.Mtl where
#else
module Bench.Local.VeryDeep.Mtl (localBench, localDeep) where

import Control.Monad.Identity qualified as M
import Control.Monad.Reader qualified as M

program :: M.MonadReader Int m => Int -> m Int
program = \case
    0 -> M.ask
    n -> M.local (+ 1) (program (n - 1))

localBench :: Int -> Int
localBench n = M.runReader (program n) 0

localDeep :: Int -> Int
localDeep n = M.runIdentity $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ M.runReaderT (runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ runI $ program n) 0
  where
    runI = M.runIdentityT
#endif
