{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Catch.EffectiveFullyStaged (catchBench, catchDeep) where

import Bench.EffectiveFullyStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Except
import "effective" Control.Effect.Internal.AlgTrans
import "effective" Control.Effect.Reader
import Data.Functor.Identity

catchBench :: Int -> Either () ()
catchBench n = runIdentity (runExceptT (p n))
  where
    p :: Int -> ExceptT () Identity ()
    p m =
        $$( stage
                (upExcept @() @Identity `fuseAT` exceptAT @(CodeQ ()))
                (Staged.catchGen [|| m ||] [|| p ||])
          )

catchDeep' :: Int -> Either () ()
catchDeep' n =
    (runIdentity . r . r . r . r . r . runExceptT . r . r . r . r . r) (p n)
  where
    r :: ReaderT () m a -> m a
    r m = runReaderT m ()

    p :: Int -> Staged.R5 (ExceptT () (Staged.R5 Identity)) ()
    p m =
        $$(stage
                ( Staged.upR5 @(ExceptT () (Staged.R5 Identity))
                    `fuseAT` upExcept @() @(Staged.R5 Identity)
                    `fuseAT` Staged.upR5 @Identity
                    `fuseAT` weakenC @((~) Gen)
                        ( Staged.r5AT
                            `fuseAT` exceptAT @(CodeQ ())
                            `fuseAT` Staged.r5AT
                        )
                )
                (Staged.catchGen [|| m ||] [|| p ||]))

catchDeep :: Int -> Either () ()
catchDeep n = runIdentity (runExceptT (p n))
  where
    p :: Int -> ExceptT () Identity ()
    p m =
        $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
               (upExcept @() @Identity `fuseAT`
                  (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                      exceptAT @(CodeQ ()) `fuseAppAT`
                   r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
               (Staged.catchGen [|| m ||] [|| p ||]))
