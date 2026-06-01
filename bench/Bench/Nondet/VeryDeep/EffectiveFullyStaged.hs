#ifdef DISABLE_VERY_DEEP
module Bench.Nondet.VeryDeep.EffectiveFullyStaged where
#else
{-# OPTIONS_GHC -Wno-unused-matches #-}

module Bench.Nondet.VeryDeep.EffectiveFullyStaged (pyth, pythDeep) where

import Bench.EffectiveFullyStaged qualified as Staged
import "effective" Control.Effect
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Internal.AlgTrans
import "effective" Control.Monad.Trans.List
import "effective" Control.Effect.Reader
import Data.Functor.Identity

choose :: Int -> [Int]
choose n =
    $$( stage
            (upCache @[] `fuseAT` pushWithUpAT @Identity)
            (Staged.chooseGen [|| n ||] [|| choose ||])
      )

pyth :: Int -> [(Int, Int, Int)]
pyth n =
    $$( stage
            (upCache @[] `fuseAT` pushWithUpAT @Identity)
            (Staged.pythGen [|| n ||] [|| choose ||])
      )

pythDeep :: Int -> [(Int, Int, Int)]
pythDeep n =
    $$(let r = halg (asker ([|| () ||] :: CodeQ ()))
        in stage
               (upCache @[] `fuseAT`
                (r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT`
                pushWithUpAT @Identity `fuseAppAT`
                r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r `fuseAppAT` r))
               (Staged.pythGen [|| n ||] [|| choose ||]))
#endif
