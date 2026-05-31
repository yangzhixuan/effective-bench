{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Local.EffectiveFullStaged (localBench, localDeep) where

import Bench.EffectiveFullStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Internal.AlgTrans (weakenC)
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

localDeep :: Int -> Int
localDeep n =
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
                        ( Staged.r5AT
                            `fuseAT` readerAT @(CodeQ Int)
                            `fuseAT` Staged.r5AT
                        )
                )
                (Staged.localGen [|| m ||] [|| p ||])
          )
