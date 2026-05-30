module Bench.Countdown.Handrolled where

import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Control.Monad.Trans.State.Strict
import Data.Functor.Identity

type M1 a = StateT Int Identity a

type R5T m = ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () m))))

type M2 a = R5T (StateT Int (R5T Identity)) a

countdownShallow :: Int -> (Int, Int)
countdownShallow n = runIdentity $ runStateT program n
  where
    program :: M1 Int
    program = do
        x <- get
        if x == 0
            then pure x
            else put (x - 1) >> program

get2 :: M2 Int
get2 = lift $ lift $ lift $ lift $ lift get

put2 :: Int -> M2 ()
put2 = lift . lift . lift . lift . lift . put

countdownDeep :: Int -> (Int, Int)
countdownDeep n = runIdentity $ runR $ runR $ runR $ runR $ runR $ runStateT (runR $ runR $ runR $ runR $ runR program) n
  where
    program :: M2 Int
    program = do
        x <- get2
        if x == 0
            then pure x
            else put2 (x - 1) >> program

    runR :: ReaderT () m a -> m a
    runR m = runReaderT m ()
