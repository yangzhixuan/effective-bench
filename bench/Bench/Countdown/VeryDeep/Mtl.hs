#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.Mtl where
#else
module Bench.Countdown.VeryDeep.Mtl (countdown, countdownDeep) where

import Control.Monad.Identity qualified as M
import Control.Monad.Reader qualified as M
import Control.Monad.State.Strict

program :: MonadState Int m => m Int
program = do
    x <- get @Int
    if x == 0
        then pure x
        else do
            put (x - 1)
            program

countdown :: Int -> (Int, Int)
countdown = runState program

countdownDeep :: Int -> (Int, Int)
countdownDeep n = M.runIdentity $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runStateT (runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ runR $ program) n
  where
    runR = (`M.runReaderT` ())

#endif
