This benchmark suite was adapted from the benchmarking suite of [heftia-effects](https://hackage.haskell.org/package/heftia) with the following modifications:

1. the test of coroutine is removed because the bottleneck is in the actual computation rather than the effect framework.

2. The NOINLINE pragmas in the test cases are removed. Instead we create two benchmarks `with-o0` and `with-o2` for different optimisation levels. Note that we pass `O2` to all packages in `cabal.project` so in the benchmark `with-o0`, it is the testing programs receiving `O0` but the libraries are still compiled with `O2`. I think that this is a more realistic scenario than everything being unoptimised.

3. We separate the libraries into different modules to make sure that each of them receives the same amount of simplifier ticks.

4. The handlers for state and reader of `Mp.Eff` internally use `IORef` and `unsafePerformIO` to store the state. So I created a separate version where state are handled in the usual way as state-passing functions.