#ifdef DISABLE_VERY_DEEP
module Bench.Catch.VeryDeep.EffectiveFullyStaged where
#else
{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Catch.VeryDeep.EffectiveFullyStaged (catchBench, catchDeep) where

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
catchDeep' = catchDeep
catchDeep :: Int -> Either () ()
catchDeep n = runIdentity (runExceptT (p n))
  where
    p :: Int -> ExceptT () Identity ()
    p m =
        $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
               (upExcept @() @Identity `fuseAT`
                  (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                      exceptAT @(CodeQ ()) `fuseAppAT`
                   r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
               (Staged.catchGen [|| m ||] [|| p ||]))
#endif
