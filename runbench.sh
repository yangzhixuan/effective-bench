#!/usr/bin/env bash

set -euo pipefail

csv_to_latex() {
    local input="$1"
    local output="$2"
    local caption="$3"

    python3 -c '
import csv
import sys

input_path, output_path, caption = sys.argv[1:]

def latex_escape(value):
    return (
        value.replace("\\", r"\textbackslash{}")
        .replace("&", r"\&")
        .replace("%", r"\%")
        .replace("$", r"\$")
        .replace("#", r"\#")
        .replace("_", r"\_")
        .replace("{", r"\{")
        .replace("}", r"\}")
        .replace("~", r"\textasciitilde{}")
        .replace("^", r"\textasciicircum{}")
    )

with open(input_path, newline="") as f:
    rows = list(csv.reader(f))

with open(output_path, "w", newline="") as f:
    f.write("\\begin{table}\\n")
    f.write("\\centering\\n")
    f.write(f"\\caption{{{latex_escape(caption)}}}\\n")
    f.write("\\begin{tabular}{lrrrrr}\\n")
    f.write("\\hline\\n")
    f.write("Benchmark & Mean (ps) & 2*Stdev (ps) & Allocated & Copied & Peak Memory \\\\\\n")
    f.write("\\hline\\n")
    for row in rows[1:]:
        f.write(" & ".join([latex_escape(row[0]), *row[1:]]) + " \\\\\\n")
    f.write("\\hline\\n")
    f.write("\\end{tabular}\\n")
    f.write("\\end{table}\\n")
' "$input" "$output" "$caption"
}

cabal run with-o2 -- --csv o2-results.csv -t 5 +RTS -T
csv_to_latex o2-results.csv o2-results.tex "Benchmark results compiled with -O2"

cabal run with-o0 -- --csv o0-results.csv -t 5 +RTS -T
csv_to_latex o0-results.csv o0-results.tex "Benchmark results compiled with -O0"
