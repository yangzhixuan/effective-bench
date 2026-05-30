#!/usr/bin/env bash

set -euo pipefail

results_dir="results"
tmp_dir="$results_dir/tmp"
mkdir -p "$results_dir" "$tmp_dir"

csv_to_latex_tables() {
    local input="$1"
    local prefix="$2"
    local caption="$3"

    python3 -c '
import csv
import sys

input_path, prefix, caption = sys.argv[1:]

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

def parse_name(name):
    parts = name.split(".")
    if parts and parts[0] == "All":
        parts = parts[1:]

    size_index = next(i for i, part in enumerate(parts) if part.isdigit())
    test = ".".join(parts[: size_index + 1])
    lib_parts = parts[size_index + 1 :]
    if lib_parts and lib_parts[-1] == "5+5":
        lib_parts = lib_parts[:-1]
    return test, ".".join(lib_parts)

def format_microseconds(picoseconds):
    value = float(picoseconds) / 1_000_000
    return f"{value:.3f}".rstrip("0").rstrip(".")

def table_value(raw_value, display_value):
    return (float(raw_value), display_value)

def format_cell(value, best):
    if value is None:
        return "--"

    raw_value, display_value = value
    if raw_value == best:
        return f"\\textbf{{{display_value}}}"
    return display_value

def write_table(path, caption, tests, libraries, values):
    with open(path, "w", newline="") as f:
        f.write("\\documentclass[varwidth,border=2pt]{standalone}\n")
        f.write("\\usepackage{booktabs}\n")
        f.write("\\usepackage{graphicx}\n")
        f.write("\\begin{document}\n")
        f.write("\\begin{center}\n")
        f.write(f"\\textbf{{{latex_escape(caption)}}}\n\n")
        f.write("\\resizebox{\\textwidth}{!}{%\n")
        f.write("\\begin{tabular}{l" + "r" * len(libraries) + "}\n")
        f.write("\\toprule\n")
        f.write("Test case & " + " & ".join(latex_escape(lib) for lib in libraries) + " \\\\\n")
        f.write("\\midrule\n")
        for test in tests:
            row = [latex_escape(test)]
            present_values = [values[(test, lib)][0] for lib in libraries if (test, lib) in values]
            best = min(present_values) if present_values else None
            row.extend(format_cell(values.get((test, lib)), best) for lib in libraries)
            f.write(" & ".join(row) + " \\\\\n")
        f.write("\\bottomrule\n")
        f.write("\\end{tabular}\n")
        f.write("}\n")
        f.write("\\end{center}\n")
        f.write("\\end{document}\n")

with open(input_path, newline="") as f:
    rows = list(csv.DictReader(f))

tests = []
libraries = []
time_values = {}
memory_values = {}

for row in rows:
    test, library = parse_name(row["Name"])
    if test not in tests:
        tests.append(test)
    if library not in libraries:
        libraries.append(library)
    time_values[(test, library)] = table_value(row["Mean (ps)"], format_microseconds(row["Mean (ps)"]))
    memory_values[(test, library)] = table_value(row["Allocated"], row["Allocated"])

write_table(f"{prefix}-time.tex", f"{caption}: mean time (microseconds)", tests, libraries, time_values)
write_table(f"{prefix}-memory.tex", f"{caption}: allocated bytes", tests, libraries, memory_values)
' "$input" "$prefix" "$caption"
}

compile_latex_tables() {
    latexmk -pdf -interaction=nonstopmode -halt-on-error -auxdir="$tmp_dir" -outdir="$results_dir" "$results_dir/o2-time.tex"
    latexmk -pdf -interaction=nonstopmode -halt-on-error -auxdir="$tmp_dir" -outdir="$results_dir" "$results_dir/o2-memory.tex"
    latexmk -pdf -interaction=nonstopmode -halt-on-error -auxdir="$tmp_dir" -outdir="$results_dir" "$results_dir/o0-time.tex"
    latexmk -pdf -interaction=nonstopmode -halt-on-error -auxdir="$tmp_dir" -outdir="$results_dir" "$results_dir/o0-memory.tex"
}

if [[ "${1:-}" == "--tables-only" ]]; then
    csv_to_latex_tables "$results_dir/o2-results.csv" "$results_dir/o2" "Benchmark results compiled with -O2"
    csv_to_latex_tables "$results_dir/o0-results.csv" "$results_dir/o0" "Benchmark results compiled with -O0"
    compile_latex_tables
    exit 0
fi

cabal run with-o2 -- --csv "$results_dir/o2-results.csv" -t 5 +RTS -T
csv_to_latex_tables "$results_dir/o2-results.csv" "$results_dir/o2" "Benchmark results compiled with -O2"

cabal run with-o0 -- --csv "$results_dir/o0-results.csv" -t 5 +RTS -T
csv_to_latex_tables "$results_dir/o0-results.csv" "$results_dir/o0" "Benchmark results compiled with -O0"
compile_latex_tables
