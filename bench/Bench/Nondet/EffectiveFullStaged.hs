{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Nondet.EffectiveFullStaged (pyth, pythDeep) where

import Bench.EffectiveFullStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Internal.AlgTrans (weakenC)
import "effective" Control.Monad.Trans.List
import "effective" Control.Effect.Reader
import Data.Functor.Identity

choose :: Int -> [Int]
choose n =
    $$( stage
            (pushWithUpAT @Identity)
            (Staged.chooseGen [|| n ||] [|| choose ||])
      )

pyth :: Int -> [(Int, Int, Int)]
pyth n =
    $$( stage
            (pushWithUpAT @Identity)
            (Staged.pythGen [|| n ||] [|| choose ||])
      )

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n =
    (runIdentity . r . r . r . r . r . runListT' . r . r . r . r . r)
        $$( stage
                ( Staged.r5AT
                    `fuseAT` pushWithUpAT @(Staged.R5 Identity)
                    `fuseAT` Staged.upR5 @Identity
                    `fuseAT` weakenC @((~) Gen) Staged.r5AT
                )
                (Staged.pythGen [|| n ||] [|| choose ||])
          )
  where
    r :: ReaderT () m a -> m a
    r m = runReaderT m ()
