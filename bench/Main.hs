module Main (main) where

import Bench.Catch.Eff qualified as CatchEff
import Bench.Catch.Effectful qualified as CatchEffectful
import Bench.Catch.EffectiveLightlyStaged qualified as CatchEffectiveLightlyStaged
import Bench.Catch.FreerSimple qualified as CatchFreer
import Bench.Catch.FusedEffects qualified as CatchFused
import Bench.Catch.Heftia qualified as CatchHeftia
import Bench.Catch.Mpeff.Safe qualified as CatchMpeffSafe
import Bench.Catch.Mpeff.Unsafe qualified as CatchMpeff
import Bench.Catch.Mtl qualified as CatchMtl
import Bench.Catch.Polysemy qualified as CatchPolysemy
import Bench.Catch.Effective qualified as CatchEffective
import Bench.Catch.EffectiveNaive qualified as CatchEffectiveNaive
import Bench.Catch.Handrolled qualified as CatchHandrolled
import Bench.Countdown.Handrolled qualified as CountdownHandrolled
import Bench.Countdown.Eff qualified as CountdownEff
import Bench.Countdown.Effective qualified as CountdownEffective
import Bench.Countdown.EffectiveLightlyStaged qualified as CountdownEffectiveLightlyStaged
import Bench.Countdown.EffectiveNaive qualified as CountdownEffectiveNaive
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
import Bench.Local.Effective qualified as LocalEffective
import Bench.Local.EffectiveLightlyStaged qualified as LocalEffectiveLightlyStaged
import Bench.Local.EffectiveNaive qualified as LocalEffectiveNaive
import Bench.Local.FreerSimple qualified as LocalFreer
import Bench.Local.FusedEffects qualified as LocalFused
import Bench.Local.Handrolled qualified as LocalHandrolled
import Bench.Local.Heftia qualified as LocalHeftia
import Bench.Local.Mpeff.Safe qualified as LocalMpeffSafe
import Bench.Local.Mpeff.Unsafe qualified as LocalMpeff
import Bench.Local.Mtl qualified as LocalMtl
import Bench.Local.Polysemy qualified as LocalPolysemy
import Bench.Nondet.Eff qualified as NondetEff
import Bench.Nondet.Effective qualified as NondetEffective
import Bench.Nondet.EffectiveLightlyStaged qualified as NondetEffectiveLightlyStaged
import Bench.Nondet.EffectiveNaive qualified as NondetEffectiveNaive
import Bench.Nondet.FreerSimple qualified as NondetFreer
import Bench.Nondet.FusedEffects qualified as NondetFused
import Bench.Nondet.HandrolledListT qualified as NondetHandrolledListT
import Bench.Nondet.HandrolledLogicT qualified as NondetHandrolledLogicT
import Bench.Nondet.Heftia qualified as NondetHeftia
import Bench.Nondet.Mpeff.Safe qualified as NondetMpeffSafe
import Bench.Nondet.Mpeff.Unsafe qualified as NondetMpeff
import Bench.Nondet.MtlListT qualified as NondetListT
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
                    , bench "effective" $ nf CountdownEffective.countdown x
                    , bench "effective.naive" $ nf CountdownEffectiveNaive.countdown x
                    , bench "mp" $ nf CountdownMpeff.countdown x
                    , bench "mp.safe" $ nf CountdownMpeffSafe.countdown x
                    , bench "mtl.logict" $ nf CountdownMtl.countdown x
                    , bench "handrolled.logict" $ nf CountdownHandrolled.countdownShallow x
                    ]

        , bgroup "countdown.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf CountdownHeftia.countdownDeep x
                    , bench "freer" $ nf CountdownFreer.countdownDeep x
                    , bench "polysemy" $ nf CountdownPolysemy.countdownDeep x
                    , bench "fused" $ nf CountdownFused.countdownDeep x
                    , bench "effectful" $ nf CountdownEffectful.countdownDeep x
                    , bench "eff" $ nf CountdownEff.countdownDeep x
                    , bench "effective" $ nf CountdownEffective.countdownDeep x
                    , bench "effective.lstg" $ nf CountdownEffectiveLightlyStaged.countdownDeep x
                    , bench "effective.naive" $ nf CountdownEffectiveNaive.countdownDeep x
                    , bench "mp" $ nf CountdownMpeff.countdownDeep x
                    , bench "mp.safe" $ nf CountdownMpeffSafe.countdownDeep x
                    , bench "mtl.logict" $ nf CountdownMtl.countdownDeep x
                    , bench "handrolled.logict" $ nf CountdownHandrolled.countdownDeep x
                    ]

        , bgroup "catch.shallow" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf CatchHeftia.catchBench x
                    , bench "freer" $ nf CatchFreer.catchBench x
                    , bench "polysemy" $ nf CatchPolysemy.catchBench x
                    , bench "fused" $ nf CatchFused.catchBench x
                    , bench "effectful" $ nf CatchEffectful.catchBench x
                    , bench "eff" $ nf CatchEff.catchBench x
                    , bench "mp" $ nf CatchMpeff.catchBench x
                    , bench "mp.safe" $ nf CatchMpeffSafe.catchBench x
                    , bench "mtl.logict" $ nf CatchMtl.catchBench x
                    , bench "effective" $ nf CatchEffective.catchBench x
                    , bench "effective.naive" $ nf CatchEffectiveNaive.catchBench x
                    , bench "handrolled.logict" $ nf CatchHandrolled.catchShallow x
                    ]

        , bgroup "catch.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf CatchHeftia.catchDeep x
                    , bench "freer" $ nf CatchFreer.catchDeep x
                    , bench "polysemy" $ nf CatchPolysemy.catchDeep x
                    , bench "fused" $ nf CatchFused.catchDeep x
                    , bench "effectful" $ nf CatchEffectful.catchDeep x
                    , bench "eff" $ nf CatchEff.catchDeep x
                    , bench "mp" $ nf CatchMpeff.catchDeep x
                    , bench "mp.safe" $ nf CatchMpeffSafe.catchDeep x
                    , bench "mtl.logict" $ nf CatchMtl.catchDeep x
                    , bench "effective" $ nf CatchEffective.catchDeep x
                    , bench "effective.lstg" $ nf CatchEffectiveLightlyStaged.catchDeep x
                    , bench "effective.naive" $ nf CatchEffectiveNaive.catchDeep x
                    , bench "handrolled.logict" $ nf CatchHandrolled.catchDeep x
                    ]

        , bgroup "local.shallow" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf LocalHeftia.localBench x
                    , bench "freer" $ nf LocalFreer.localBench x
                    , bench "polysemy" $ nf LocalPolysemy.localBench x
                    , bench "fused" $ nf LocalFused.localBench x
                    , bench "effectful" $ nf LocalEffectful.localBench x
                    , bench "eff" $ nf LocalEff.localBench x
                    , bench "effective" $ nf LocalEffective.localBench x
                    , bench "effective.naive" $ nf LocalEffectiveNaive.localBench x
                    , bench "mp" $ nf LocalMpeff.localBench x
                    , bench "mp.safe" $ nf LocalMpeffSafe.localBench x
                    , bench "mtl.logict" $ nf LocalMtl.localBench x
                    , bench "handrolled.logict" $ nf LocalHandrolled.localShallow x
                    ]

        , bgroup "local.deep" $
            [10000] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf LocalHeftia.localDeep x
                    , bench "freer" $ nf LocalFreer.localDeep x
                    , bench "polysemy" $ nf LocalPolysemy.localDeep x
                    , bench "fused" $ nf LocalFused.localDeep x
                    , bench "effectful" $ nf LocalEffectful.localDeep x
                    , bench "eff" $ nf LocalEff.localDeep x
                    , bench "effective" $ nf LocalEffective.localDeep x
                    , bench "effective.lstg" $ nf LocalEffectiveLightlyStaged.localDeep x
                    , bench "effective.naive" $ nf LocalEffectiveNaive.localDeep x
                    , bench "mp" $ nf LocalMpeff.localDeep x
                    , bench "mp.safe" $ nf LocalMpeffSafe.localDeep x
                    , bench "mtl.logict" $ nf LocalMtl.localDeep x
                    , bench "handrolled.logict" $ nf LocalHandrolled.localDeep x
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
                    , bench "effective" $ nf NondetEffective.pyth x
                    , bench "effective.naive" $ nf NondetEffectiveNaive.pyth x
                    , bench "mp" $ nf NondetMpeff.pyth x
                    , bench "mp.safe" $ nf NondetMpeffSafe.pyth x
                    , bench "mtl.listt" $ nf NondetListT.pyth x
                    , bench "mtl.logict" $ nf NondetLogict.pyth x
                    , bench "handrolled.listt" $ nf NondetHandrolledListT.pyth x
                    , bench "handrolled.logict" $ nf NondetHandrolledLogicT.pyth x
                    ]

        , bgroup "nondet.deep" $
            [32] <&> \x ->
                bgroup
                    (show x)
                    [ bench "heftia" $ nf NondetHeftia.pythDeep x
                    , bench "freer" $ nf NondetFreer.pythDeep x
                    , bench "polysemy" $ nf NondetPolysemy.pythDeep x
                    , bench "fused" $ nf NondetFused.pythDeep x
                    , bench "eff" $ nf NondetEff.pythDeep x
                    , bench "effective" $ nf NondetEffective.pythDeep x
                    , bench "effective.lstg" $ nf NondetEffectiveLightlyStaged.pythDeep x
                    , bench "effective.naive" $ nf NondetEffectiveNaive.pythDeep x
                    , bench "mp" $ nf NondetMpeff.pythDeep x
                    , bench "mp.safe" $ nf NondetMpeffSafe.pythDeep x
                    , bench "mtl.listt" $ nf NondetListT.pythDeep x
                    , bench "mtl.logict" $ nf NondetLogict.pythDeep x
                    , bench "handrolled.listt" $ nf NondetHandrolledListT.pythDeep x
                    , bench "handrolled.logict" $ nf NondetHandrolledLogicT.pythDeep x
                    ]
        ]
