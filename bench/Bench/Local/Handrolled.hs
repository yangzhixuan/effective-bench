module Bench.Local.Handrolled where

import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Data.Functor.Identity

type M1 a = ReaderT Int Identity a

type R5T m = ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () m))))

type M2 a = R5T (ReaderT Int (R5T Identity)) a

localShallow :: Int -> Int
localShallow n = runIdentity $ runReaderT (program n) 0
  where
    program :: Int -> M1 Int
    program 0 = ask
    program k = local (+ 1) (program (k - 1))

ask2 :: M2 Int
ask2 = lift $ lift $ lift $ lift $ lift ask

local2 :: (Int -> Int) -> M2 a -> M2 a
local2 f = mapReaderT $ mapReaderT $ mapReaderT $ mapReaderT $ mapReaderT $ local f

localDeep :: Int -> Int
localDeep n = runIdentity $ runR $ runR $ runR $ runR $ runR $ runReaderT (runR $ runR $ runR $ runR $ runR $ program n) 0
  where
    program :: Int -> M2 Int
    program 0 = ask2
    program k = local2 (+ 1) (program (k - 1))

    runR :: ReaderT () m a -> m a
    runR m = runReaderT m ()
