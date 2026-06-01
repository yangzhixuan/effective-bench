Experiment Setup
================

This benchmark suite is for evaluating the runtime performance of the [`effective`](https://github.com/zenzike/effective) library.
The test cases are mostly adapted from the benchmarking suite of [heftia-effects](https://hackage.haskell.org/package/heftia) with the following modifications:

1. The test of coroutine is removed because the bottleneck is in the actual computation rather than the effect framework.

  We added a new group of tests called `very.deep` where there are 50 reader effects before and after the effect handler being tested. This group of tests needs a lot of memory to compile so it is disabled by default in `effective-bench.cabal`. The library `fused-effects` is disabled for `very.deep` because it fails in compilation because of running out of simplifier ticks.

2. Beside the implementations of `effective`, we also add another implementation for hand-rolled monadic code that does not use the `MonadXYZ` type-classes. In the benchmark suite of [heftia-effects](https://hackage.haskell.org/package/heftia), the test cases `catch` and `local` are not implemented for libraries that do not support higher-order effects. We added these tests for all libraries by implementing `catch` and `local` as handlers.

3. The `NOINLINE` pragmas in the test cases are removed. Instead we create two benchmarks `with-o0` and `with-o2` for different optimisation levels. Note that we pass `O2` to all packages in `cabal.project`, so in the benchmark `with-o0`, it is the testing programs receiving `O0` but the libraries are still compiled with `O2`. This is probably a more realistic scenario than everything being unoptimised.

4. We separate the libraries into different compilation units to make sure that each of them receives the same amount of simplifier ticks.

5. The handlers for state and reader of `Mp.Eff` internally use `IORef` and `unsafePerformIO` to store the state. So we create a separate test `mp.safe` where state are handled in the usual way as state-passing functions.

6. GHC is pinned to 9.10.1 and all libraries are pinned to specific versions in `effective-bench.cabal` for reproducibility. GHC 9.8.4 was also tested. All libraries compile without modification with 9.8.4 but `mp` and `mp.safe` crash at runtime, which should be caused by GHC bugs (since they don't crash with 9.10.1).

7. The library `freer-simple-1.2.1.2` is slightly patched to compile with GHC 9.10.1.

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

The shell script `runbench.sh` runs the benchmarks. The benchmarking framework [`tasty-bench`](https://hackage.haskell.org/package/tasty-bench) automatically runs each test case multiple times for a target relative standard deviation of 5%.

All results are generated in the directory `results/`. The raw data are recorded in `o0-results.csv` and `o2-results.csv`. The script also generates some `pdf` files (using LaTeX) for showing the results more nicely. The file [`results/benchmark-tables.pdf`](results/benchmark-tables.pdf) contains all results.

The files in `results/` of this repo were generated on my Apple M4 laptop with 24GB memory.


Results Analysis
================

**First of all, we emphasise that the results of this experiment do not necessarily generalise to practical scenarios because the testing programs are all small artificial toy programs**. The purpose of this experiment is to check that our implementation of `effective` has the expected performance characteristics, rather than to compare the performance of the different libraries. However, we can still draw some useful conclusions from these small tests.

* Fully staged `effective` (`effective.fstg` in the tables) consistently performs very well under both `O2` and `O0`. This is not surprising at all because if we inspect the generated code, it is clear that the code is overhead-free. For example, the code for the `countdown` test is
```haskell
countdownDeep :: Int -> (Int, Int)
countdownDeep n = runIdentity (runStateT p n)
  where
  p =
    StateT
      (\ s_aSEK
         -> Identity
              (if (s_aSEK > 0) then
                   case runIdentity (runStateT p_aRZI (s_aSEK - 1)) of
                     (a_aSEL, b_aSEM) -> (a_aSEL, b_aSEM)
               else
                   (s_aSEK, s_aSEK)))
```
The effectful operations `get` and `put` and the (unused) reader effects are all evaluated away. The code does have an unnecessary pattern matching `(a_aSEL, b_aSEM) -> (a_aSEL, b_aSEM)` but GHC can optimise this out (and we can tweak the handler a bit to avoid generating this pattern matching).

  Only for `nondet` in `O0`

* Lightly staged `effective` (`effective.lstg` in the tables) does not offer consistent performance boost in these tests. This is not surprising because there is no non-trivial handler interaction in these tests, so handler combinators aren't the performance bottleneck.

* Non-staged `effective` performs reasonably fast compared to other implementations of effect handlers under both `O0` and `O2`. It is not always the fastest in the shallow tests but it does very well in the deep and very deep tests because of handler fusion and storing algebras as arrays.

* The version of `effective` with the naive encoding of programs and algebras (`effective.naive`) does better than `effective` under `O2` for shallow tests. After inspecting the generated core, we found that it was because GHC was willing to do more inlining for `effective.naive`, while it almost never inlined anything related to arrays.

* Because this makes the handler of state no longer tail-resumptive, a noticeable performance drop for the `countdown` from `mp` to `mp.safe` test is observed.