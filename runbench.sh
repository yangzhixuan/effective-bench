#!/usr/bin/env bash

set -euo pipefail

results_dir="results"
tmp_dir="$results_dir/tmp"
mkdir -p "$results_dir" "$tmp_dir"

cabal run with-o2 -- --csv "$results_dir/o2-results.csv" -t 5 +RTS -T
cabal run with-o0 -- --csv "$results_dir/o0-results.csv" -t 5 +RTS -T
