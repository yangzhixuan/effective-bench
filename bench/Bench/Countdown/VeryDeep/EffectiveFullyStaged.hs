#ifdef DISABLE_VERY_DEEP
module Bench.Countdown.VeryDeep.EffectiveFullyStaged where
#else
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# LANGUAGE MonoLocalBinds #-}

module Bench.Countdown.VeryDeep.EffectiveFullyStaged (countdown, countdownDeep) where

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
countdownDeep' = countdownDeep
countdownDeep :: Int -> (Int, Int)
countdownDeep n = runIdentity (runStateT p n)
  where
    p :: StateT Int Identity Int
    p = $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
                (upState @Int @Identity `fuseAT`
                   (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                       stateAT @(CodeQ Int) `fuseAppAT`
                    r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
                (Staged.countdownGen [|| p ||])
          )
#endif
