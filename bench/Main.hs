module Main (main) where

import Bench.Catch.Eff qualified as CatchEff
import Bench.Catch.Effectful qualified as CatchEffectful
import Bench.Catch.FusedEffects qualified as CatchFused
import Bench.Catch.Heftia qualified as CatchHeftia
import Bench.Catch.Mpeff.Safe qualified as CatchMpeffSafe
import Bench.Catch.Mpeff.Unsafe qualified as CatchMpeff
import Bench.Catch.Mtl qualified as CatchMtl
import Bench.Catch.Polysemy qualified as CatchPolysemy
import Bench.Countdown.Eff qualified as CountdownEff
import Bench.Countdown.Effectful qualified as CountdownEffectful
import Bench.Countdown.FreerSimple qualified as CountdownFreer
import Bench.Countdown.FusedEffects qualified as CountdownFused
import Bench.Countdown.Heftia qualified as CountdownHeftia
import Bench.Countdown.Mpeff.Safe qualified as CountdownMpeffSafe
import Bench.Countdown.Mpeff.Unsafe qualified as CountdownMpeff
import Bench.Countdown.Mtl qualified as CountdownMtl
import Bench.Countdown.Polysemy qualified as CountdownPolysemy
import Bench.Local.Effectful qualified as LocalEffectful
import Bench.Local.Eff qualified as LocalEff
import Bench.Local.FusedEffects qualified as LocalFused
import Bench.Local.Heftia qualified as LocalHeftia
import Bench.Local.Mpeff.Safe qualified as LocalMpeffSafe
import Bench.Local.Mpeff.Unsafe qualified as LocalMpeff
import Bench.Local.Mtl qualified as LocalMtl
import Bench.Local.Polysemy qualified as LocalPolysemy
import Bench.Nondet.Eff qualified as NondetEff
import Bench.Nondet.FreerSimple qualified as NondetFreer
import Bench.Nondet.FusedEffects qualified as NondetFused
import Bench.Nondet.Heftia qualified as NondetHeftia
import Bench.Nondet.Mpeff.Safe qualified as NondetMpeffSafe
import Bench.Nondet.Mpeff.Unsafe qualified as NondetMpeff
import Bench.Nondet.MtlLogict qualified as NondetLogict
import Bench.Nondet.Polysemy qualified as NondetPolysemy
import Data.Functor ((<&>))
import Test.Tasty.Bench

main :: IO ()
main =
    defaultMain
        [ bgroup "countdown.shallow" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf CountdownHeftia.countdown x
                    , bench "freer" $ nf CountdownFreer.countdown x
                    , bench "polysemy" $ nf CountdownPolysemy.countdown x
                    , bench "fused" $ nf CountdownFused.countdown x
                    , bench "effectful" $ nf CountdownEffectful.countdown x
                    , bench "eff" $ nf CountdownEff.countdown x
                    , bench "mp" $ nf CountdownMpeff.countdown x
                    , bench "mp.safe" $ nf CountdownMpeffSafe.countdown x
                    , bench "mtl" $ nf CountdownMtl.countdown x
                    ]

        , bgroup "countdown.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia.5+5" $ nf CountdownHeftia.countdownDeep x
                    , bench "freer.5+5" $ nf CountdownFreer.countdownDeep x
                    , bench "polysemy.5+5" $ nf CountdownPolysemy.countdownDeep x
                    , bench "fused.5+5" $ nf CountdownFused.countdownDeep x
                    , bench "effectful.5+5" $ nf CountdownEffectful.countdownDeep x
                    , bench "eff.5+5" $ nf CountdownEff.countdownDeep x
                    , bench "mp.5+5" $ nf CountdownMpeff.countdownDeep x
                    , bench "mp.safe.5+5" $ nf CountdownMpeffSafe.countdownDeep x
                    , bench "mtl.5+5" $ nf CountdownMtl.countdownDeep x
                    ]

        , bgroup "catch.shallow" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf CatchHeftia.catchBench x
                    , bench "polysemy" $ nf CatchPolysemy.catchBench x
                    , bench "fused" $ nf CatchFused.catchBench x
                    , bench "effectful" $ nf CatchEffectful.catchBench x
                    , bench "eff" $ nf CatchEff.catchBench x
                    , bench "mp" $ nf CatchMpeff.catchBench x
                    , bench "mp.safe" $ nf CatchMpeffSafe.catchBench x
                    , bench "mtl" $ nf CatchMtl.catchBench x
                    ]

        , bgroup "catch.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia.5+5" $ nf CatchHeftia.catchDeep x
                    , bench "polysemy.5+5" $ nf CatchPolysemy.catchDeep x
                    , bench "fused.5+5" $ nf CatchFused.catchDeep x
                    , bench "effectful.5+5" $ nf CatchEffectful.catchDeep x
                    , bench "eff.5+5" $ nf CatchEff.catchDeep x
                    , bench "mp.5+5" $ nf CatchMpeff.catchDeep x
                    , bench "mp.safe.5+5" $ nf CatchMpeffSafe.catchDeep x
                    , bench "mtl.5+5" $ nf CatchMtl.catchDeep x
                    ]

        , bgroup "local.shallow" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf LocalHeftia.localBench x
                    , bench "polysemy" $ nf LocalPolysemy.localBench x
                    , bench "fused" $ nf LocalFused.localBench x
                    , bench "effectful" $ nf LocalEffectful.localBench x
                    , bench "eff" $ nf LocalEff.localBench x
                    , bench "mp" $ nf LocalMpeff.localBench x
                    , bench "mp.safe" $ nf LocalMpeffSafe.localBench x
                    , bench "mtl" $ nf LocalMtl.localBench x
                    ]

        , bgroup "local.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia.5+5" $ nf LocalHeftia.localDeep x
                    , bench "polysemy.5+5" $ nf LocalPolysemy.localDeep x
                    , bench "fused.5+5" $ nf LocalFused.localDeep x
                    , bench "effectful.5+5" $ nf LocalEffectful.localDeep x
                    , bench "eff.5+5" $ nf LocalEff.localDeep x
                    , bench "mp.5+5" $ nf LocalMpeff.localDeep x
                    , bench "mp.safe.5+5" $ nf LocalMpeffSafe.localDeep x
                    , bench "mtl.5+5" $ nf LocalMtl.localDeep x
                    ]

        , bgroup "nondet.shallow" $
            [32] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf NondetHeftia.pyth x
                    , bench "freer" $ nf NondetFreer.pyth x
                    , bench "polysemy" $ nf NondetPolysemy.pyth x
                    , bench "fused" $ nf NondetFused.pyth x
                    , bench "eff" $ nf NondetEff.pyth x
                    , bench "mp" $ nf NondetMpeff.pyth x
                    , bench "mp.safe" $ nf NondetMpeffSafe.pyth x
                    , bench "mtl-logict" $ nf NondetLogict.pyth x
                    ]

        , bgroup "nondet.deep" $
            [32] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia.5+5" $ nf NondetHeftia.pythDeep x
                    , bench "freer.5+5" $ nf NondetFreer.pythDeep x
                    , bench "polysemy.5+5" $ nf NondetPolysemy.pythDeep x
                    , bench "fused.5+5" $ nf NondetFused.pythDeep x
                    , bench "eff.5+5" $ nf NondetEff.pythDeep x
                    -- `mpeff` crashes on this test. Not sure why.
    --                , bench "mp.5+5" $ nf NondetMpeff.pythDeep x
                    , bench "mp.safe.5+5" $ nf NondetMpeffSafe.pythDeep x
                    , bench "mtl-logict.5+5" $ nf NondetLogict.pythDeep x
                    ]

        ]
