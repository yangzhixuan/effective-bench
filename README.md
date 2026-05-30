This benchmark suite was adapted from the benchmarking suite of [heftia-effects](https://hackage.haskell.org/package/heftia) with the following modifications:

1. the test of coroutine is removed because the bottleneck is in the actual computation rather than the effect framework.

2. The `NOINLINE` pragmas in the test cases are removed. Instead we create two benchmarks `with-o0` and `with-o2` for different optimisation levels. Note that we pass `O2` to all packages in `cabal.project` so in the benchmark `with-o0`, it is the testing programs receiving `O0` but the libraries are still compiled with `O2`. This is probably a more realistic scenario than everything being unoptimised.

3. We separate the libraries into different modules to make sure that each of them receives the same amount of simplifier ticks.

4. The handlers for state and reader of `Mp.Eff` internally use `IORef` and `unsafePerformIO` to store the state. So we create a separate test `mp.safe` where state are handled in the usual way as state-passing functions. Because this makes the handler of state no longer tail-resumptive, a noticeable performance drop for the `countdown` from `mp` to `mp.safe` test is observed.

5. GHC is pinned to 9.10.1 and all libraries are pinned to specific versions in `effective-bench.cabal` for reproducibility. GHC 9.8.4 was also tested. All libraries compile without modification with 9.8.4 but `mp` and `mp.safe` crash at runtime, which should be caused by GHC bugs (since they don't crash with 9.10.1).

6. The library `freer-simple-1.2.1.2` is slightly patched to work with GHC 9.10.1.

  1. `freer-simple.cabal` is modified to allow the version of `template-haskell` that ships with GHC 9.10.1
  2. Line 156 of `src/Control/Monad/Freer/Internal.hs` is changed from
```
instance (MonadBase b m, LastMember m effs) => MonadBase b (Eff effs) where
```
     to
```
instance (Monad b, MonadBase b m, LastMember m effs) => MonadBase b (Eff effs) where
```
It's not clear to me why GHC 9.10.1 can't see `MonadBase b m` already implies `Monad b`. The patched version is shipped in `vendor/freer-simple-1.2.1.2`.