#!/usr/bin/env bash

set -euo pipefail

results_dir="results"
tmp_dir="$results_dir/tmp"
mkdir -p "$results_dir" "$tmp_dir"

csv_to_latex_tables() {
    local o2_input="$1"
    local o0_input="$2"
    local output_prefix="$3"

    python3 -c '
import csv
import sys

o2_input_path, o0_input_path, output_prefix = sys.argv[1:]

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

def format_percent(value, best):
    percent = value / best * 100
    return f"{percent:.1f}\\%"

def table_value(raw_value, display_value):
    return (float(raw_value), display_value)

def format_cell(value, best):
    if value is None:
        return "--"

    raw_value, display_value = value
    if raw_value == best:
        return f"\\textbf{{{display_value}}}"
    return display_value

def format_absolute_cell(value, best):
    return format_cell(value, best)

def format_relative_cell(value, best):
    if value is None:
        return "--"

    raw_value, _ = value
    display_value = format_percent(raw_value, best)
    if raw_value == best:
        return f"\\textbf{{{display_value}}}"
    return display_value

def read_results(input_path):
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

    libraries.sort(key=str.casefold)
    return tests, libraries, time_values, memory_values

def write_table_body(f, tests, libraries, values, format_value):
    f.write("\\begin{center}\n")
    f.write("\\resizebox{\\textwidth}{!}{%\n")
    f.write("\\begin{tabular}{l" + "r" * len(libraries) + "}\n")
    f.write("\\toprule\n")
    f.write("Test case & " + " & ".join(latex_escape(lib) for lib in libraries) + " \\\\\n")
    f.write("\\midrule\n")
    for test in tests:
        row = [latex_escape(test)]
        present_values = [values[(test, lib)][0] for lib in libraries if (test, lib) in values]
        best = min(present_values) if present_values else None
        row.extend(format_value(values.get((test, lib)), best) for lib in libraries)
        f.write(" & ".join(row) + " \\\\\n")
    f.write("\\bottomrule\n")
    f.write("\\end{tabular}\n")
    f.write("}\n")
    f.write("\\end{center}\n\n")

def write_combined_table(f, caption, tests, libraries, values, format_value):
    f.write("\\section*{" + latex_escape(caption) + "}\n")
    write_table_body(f, tests, libraries, values, format_value)

def write_standalone_table(path, caption, tests, libraries, values, format_value):
    with open(path, "w", newline="") as f:
        f.write("\\documentclass[varwidth,border=2pt]{standalone}\n")
        f.write("\\usepackage{booktabs}\n")
        f.write("\\usepackage{graphicx}\n")
        f.write("\\begin{document}\n")
        f.write("\\textbf{" + latex_escape(caption) + "}\n\n")
        write_table_body(f, tests, libraries, values, format_value)
        f.write("\\end{document}\n")

def write_result_tables(f, caption, result):
    tests, libraries, time_values, memory_values = result
    write_combined_table(f, f"{caption}: mean time (microseconds)", tests, libraries, time_values, format_absolute_cell)
    write_combined_table(f, f"{caption}: mean time (% of fastest)", tests, libraries, time_values, format_relative_cell)
    write_combined_table(f, f"{caption}: allocated bytes", tests, libraries, memory_values, format_absolute_cell)
    write_combined_table(f, f"{caption}: allocated bytes (% of least allocated)", tests, libraries, memory_values, format_relative_cell)

def write_standalone_result_tables(prefix, caption, result):
    tests, libraries, time_values, memory_values = result
    write_standalone_table(f"{prefix}-time.tex", f"{caption}: mean time (microseconds)", tests, libraries, time_values, format_absolute_cell)
    write_standalone_table(f"{prefix}-time-percent.tex", f"{caption}: mean time (% of fastest)", tests, libraries, time_values, format_relative_cell)
    write_standalone_table(f"{prefix}-memory.tex", f"{caption}: allocated bytes", tests, libraries, memory_values, format_absolute_cell)
    write_standalone_table(f"{prefix}-memory-percent.tex", f"{caption}: allocated bytes (% of least allocated)", tests, libraries, memory_values, format_relative_cell)

o2_results = read_results(o2_input_path)
o0_results = read_results(o0_input_path)

write_standalone_result_tables(f"{output_prefix}/o2", "Benchmark results compiled with -O2", o2_results)
write_standalone_result_tables(f"{output_prefix}/o0", "Benchmark results compiled with -O0", o0_results)

with open(f"{output_prefix}/benchmark-tables.tex", "w", newline="") as f:
    f.write("\\documentclass{article}\n")
    f.write("\\usepackage[margin=0.5in]{geometry}\n")
    f.write("\\usepackage{booktabs}\n")
    f.write("\\usepackage{graphicx}\n")
    f.write("\\begin{document}\n")
    write_result_tables(f, "Benchmark results compiled with -O2", o2_results)
    write_result_tables(f, "Benchmark results compiled with -O0", o0_results)
    f.write("\\end{document}\n")
' "$o2_input" "$o0_input" "$output_prefix"
}

compile_latex_tables() {
    local tex
    local stem
    local ext
    local generated_file
    for tex in "$results_dir"/benchmark-tables.tex "$results_dir"/o{0,2}-{time,memory}{,-percent}.tex; do
        latexmk -pdf -interaction=nonstopmode -halt-on-error -emulate-aux-dir -auxdir="$tmp_dir" -outdir="$results_dir" "$tex"

        stem="$(basename "$tex" .tex)"
        for ext in aux fdb_latexmk fls log synctex.gz synctex.tz; do
            generated_file="$results_dir/$stem.$ext"
            if [[ -e "$generated_file" ]]; then
                mv -f "$generated_file" "$tmp_dir/"
            fi
        done
    done
}

if [[ "${1:-}" == "--tables-only" ]]; then
    csv_to_latex_tables "$results_dir/o2-results.csv" "$results_dir/o0-results.csv" "$results_dir"
    compile_latex_tables
    exit 0
fi

cabal run with-o2 -- --csv "$results_dir/o2-results.csv" -t 5 +RTS -T

cabal run with-o0 -- --csv "$results_dir/o0-results.csv" -t 5 +RTS -T
csv_to_latex_tables "$results_dir/o2-results.csv" "$results_dir/o0-results.csv" "$results_dir"
compile_latex_tables
