{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# LANGUAGE MonoLocalBinds #-}

module Bench.Countdown.EffectiveFullyStaged (countdown, countdownDeep) where

import Bench.EffectiveFullyStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.Internal.AlgTrans
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Reader
import "effective" Control.Effect.State.Strict
import Data.Functor.Identity

countdown :: Int -> (Int, Int)
countdown n = runIdentity (runStateT p n)
  where
    p :: StateT Int Identity Int
    p =
        $$(stage
             (upState @Int @Identity `fuseAT` stateAT @(CodeQ Int))
             (Staged.countdownGen [|| p ||])
          )

countdownDeep' :: Int -> (Int, Int)
countdownDeep' n =
    (runIdentity . r . r . r . r . r . (`runStateT` n) . r . r . r . r . r) p
  where
    r :: ReaderT () m a -> m a
    r m = runReaderT m ()

    p :: Staged.R5 (StateT Int (Staged.R5 Identity)) Int
    p =
        $$(stage
             (Staged.upR5 @(StateT Int (Staged.R5 Identity))
                 `fuseAT` upState @Int @(Staged.R5 Identity)
                 `fuseAT` Staged.upR5 @Identity
                 `fuseAT` weakenC @((~) Gen)
                     (Staged.r5AT
                         `fuseAT` stateAT @(CodeQ Int)
                         `fuseAT` Staged.r5AT
                     )
             )
             (Staged.countdownGen [|| p ||])
          )

countdownDeep :: Int -> (Int, Int)
countdownDeep n = runIdentity (runStateT p n)
  where
    p :: StateT Int Identity Int
    p = $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
                (upState @Int @Identity `fuseAT`
                   (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                       stateAT @(CodeQ Int) `fuseAppAT`
                    r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
                (Staged.countdownGen [|| p ||])
          )
