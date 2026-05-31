#ifdef DISABLE_VERY_DEEP
module Bench.Local.VeryDeep.EffectiveFullyStaged where
#else
{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Local.VeryDeep.EffectiveFullyStaged (localBench, localDeep) where

import Bench.EffectiveFullyStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Internal.AlgTrans
import "effective" Control.Effect.Reader
import Data.Functor.Identity

localBench :: Int -> Int
localBench n = runIdentity (runReaderT (p n) 0)
  where
    p :: Int -> ReaderT Int Identity Int
    p m =
        $$( stage
                (upReader @Int @Identity `fuseAT` readerAT @(CodeQ Int))
                (Staged.localGen [|| m ||] [|| p ||])
          )

localDeep' :: Int -> Int
localDeep' = localDeep
localDeep :: Int -> Int
localDeep n = runIdentity (runReaderT (p n) 0)
  where
    p :: Int -> ReaderT Int Identity Int
    p m =
        $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
                (upReader @Int @Identity `fuseAT`
                   (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                       readerAT @(CodeQ Int) `fuseAppAT`
                    r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
                (Staged.localGen [|| m ||] [|| p ||]))
#endif
