{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Local.EffectiveFullyStaged (localBench, localDeep) where

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
localDeep' n =
    (runIdentity . r . r . r . r . r . (`runReaderT` 0) . r . r . r . r . r) (p n)
  where
    r :: ReaderT () m a -> m a
    r m = runReaderT m ()

    p :: Int -> Staged.R5 (ReaderT Int (Staged.R5 Identity)) Int
    p m =
        $$( stage
                ( Staged.upR5 @(ReaderT Int (Staged.R5 Identity))
                    `fuseAT` upReader @Int @(Staged.R5 Identity)
                    `fuseAT` Staged.upR5 @Identity
                    `fuseAT` weakenC @((~) Gen)
                        (Staged.r5AT
                            `fuseAT` readerAT @(CodeQ Int)
                            `fuseAT` Staged.r5AT))
                (Staged.localGen [|| m ||] [|| p ||])
          )

localDeep :: Int -> Int
localDeep n = runIdentity (runReaderT (p n) 0)
  where
    p :: Int -> ReaderT Int Identity Int
    p m =
        $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
           in stage
                (upReader @Int @Identity `fuseAT`
                   (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                       readerAT @(CodeQ Int) `fuseAppAT`
                    r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
                (Staged.localGen [|| m ||] [|| p ||]))
