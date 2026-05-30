module Bench.Catch.Handrolled where

import Control.Monad.Trans.Reader
import Control.Monad.Trans.Except
import Data.Functor.Identity
import Control.Monad.Trans.Class

type M1 e a = ExceptT e Identity a

type R5T m = ReaderT () (ReaderT () (ReaderT () (ReaderT () (ReaderT () m))))

type M2 e a = R5T (ExceptT e (R5T Identity)) a

catchShallow :: Int -> Either () ()
catchShallow = runIdentity . runExceptT . p where
  p :: Int -> M1 () ()
  p 0 = throwE ()
  p n = catchE (p (n-1)) \() -> throwE ()

throwE2 :: e -> M2 e a
throwE2 e = lift (lift (lift (lift (lift (throwE e)))))

catchE2 :: M2 e a -> (e -> M2 e a) -> M2 e a
catchE2 = liftCatch (liftCatch (liftCatch (liftCatch (liftCatch catchE))))

catchDeep :: Int -> Either () ()
catchDeep = runIdentity . run . run . run . run . run . runExceptT . run . run . run . run . run . p where
  p :: Int -> M2 () ()
  p 0 = throwE2 ()
  p n = catchE2 (p (n-1)) \() -> throwE2 ()

  run :: ReaderT () m a -> m a
  run m = runReaderT m ()
