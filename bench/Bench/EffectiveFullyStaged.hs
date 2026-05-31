{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE TypeFamilies #-}

module Bench.EffectiveFullyStaged where

import "effective" Control.Effect
import "effective" Control.Effect.Internal.AlgTrans
import "effective" Control.Effect.Alternative
import "effective" Control.Effect.CodeGen
import "effective" Control.Effect.Except
import "effective" Control.Effect.Reader
import "effective" Control.Effect.State.Strict
import "effective" Control.Monad.Trans.List

catchGen :: Members '[CodeGen, UpOp m, Catch (CodeQ ()), Throw (CodeQ ())] sig
         => CodeQ Int -> CodeQ (Int -> m ()) -> Prog sig (CodeQ ())
catchGen cN self = do
    b <- split [|| $$cN > 0 ||]
    if b
        then catch (up [|| $$self ($$cN - 1) ||]) \(_ :: CodeQ ()) -> throw @(CodeQ ()) [|| () ||]
        else throw @(CodeQ ()) [|| () ||]

countdownGen :: Members '[CodeGen, UpOp m, Put (CodeQ Int), Get (CodeQ Int)] sig
             => CodeQ (m Int) -> Prog sig (CodeQ Int)
countdownGen self = do
    cs <- get @(CodeQ Int)
    b <- split [|| $$cs > 0 ||]
    if b
        then do
            put [|| $$cs - 1 ||]
            up self
        else pure cs

localGen :: Members '[CodeGen, UpOp m, Ask (CodeQ Int), Local (CodeQ Int)] sig
         => CodeQ Int -> CodeQ (Int -> m Int) -> Prog sig (CodeQ Int)
localGen cN self = do
    b <- split [|| $$cN > 0 ||]
    if b
        then local @(CodeQ Int) (\r -> [|| $$r + 1 ||]) (up [|| $$self ($$cN - 1) ||])
        else ask @(CodeQ Int)

pythGen :: Members '[CodeGen, Choose, Empty, UpOp m] sig
        => CodeQ Int -> CodeQ (Int -> m Int) -> Prog sig (CodeQ (Int, Int, Int))
pythGen cN cChoose = do
    x <- up [|| $$cChoose $$cN ||]
    y <- up [|| $$cChoose $$cN ||]
    z <- up [|| $$cChoose $$cN ||]
    genIf
        [|| $$x * $$x + $$y * $$y == $$z * $$z ||]
        (pure [|| ($$x, $$y, $$z) ||])
        empty

chooseGen :: Members '[CodeGen, Choose, Empty, UpOp m] sig
          => CodeQ Int -> CodeQ (Int -> m Int) -> Prog sig (CodeQ Int)
chooseGen cN self =
    genIf
        [|| $$cN > 0 ||]
        (up [|| $$self ($$cN - 1) ||] <|> pure cN)
        empty

type R1 m = ReaderT () m
type R2 m = ReaderT () (R1 m)
type R3 m = ReaderT () (R2 m)
type R4 m = ReaderT () (R3 m)
type R5 m = ReaderT () (R4 m)
type M = R5 (ListT (R5 Identity))

rAT :: AlgTrans '[Ask (CodeQ ())] '[] '[ReaderT (CodeQ ())] Monad
rAT = readerAskAT @(CodeQ ())

r5AT :: AlgTrans '[Ask (CodeQ ())] '[]
                 [ ReaderT (CodeQ ())
                 , ReaderT (CodeQ ())
                 , ReaderT (CodeQ ())
                 , ReaderT (CodeQ ())
                 , ReaderT (CodeQ ())
                 ]
                 Monad
r5AT = weakenC (rAT `fuseAT` rAT `fuseAT` rAT `fuseAT` rAT `fuseAT` rAT)

upR5 :: forall l. AlgTrans '[UpOp (R5 l)] '[Ask (CodeQ ()), CodeGen, UpOp l] '[] Monad
upR5 =
    weakenC $
        upReader @() @(R4 l)
            `pipeAT` upReader @() @(R3 l)
            `pipeAT` upReader @() @(R2 l)
            `pipeAT` upReader @() @(R1 l)
            `pipeAT` upReader @() @l
