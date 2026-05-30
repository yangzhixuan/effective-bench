module Bench.Local.FreerSimple (localBench, localDeep) where

import Control.Monad.Freer qualified as FS
import Control.Monad.Freer.Reader qualified as FS

program :: FS.Member (FS.Reader Int) es => Int -> FS.Eff es Int
program = \case
    0 -> FS.ask
    n -> FS.local (+ (1 :: Int)) (program (n - 1))

localBench :: Int -> Int
localBench n = FS.run $ FS.runReader (0 :: Int) $ program n

localDeep :: Int -> Int
localDeep n = FS.run $ runR $ runR $ runR $ runR $ runR $ FS.runReader (0 :: Int) $ runR $ runR $ runR $ runR $ runR $ program n
  where
    runR = FS.runReader ()
