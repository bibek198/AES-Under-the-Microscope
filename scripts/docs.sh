#!/usr/bin/env bash
# Build the LaTeX report and the Beamer slides with Tectonic (brew install tectonic).
#   report/ChronoLeak_Report_23ECB0F33.pdf   <- report/latex/main.tex
#   presentation/slides.pdf                  <- presentation/beamer/slides.tex
set -euo pipefail
cd "$(dirname "$0")/.."
command -v tectonic >/dev/null || { echo "tectonic not found: brew install tectonic" >&2; exit 1; }
(cd report/latex && tectonic -X compile main.tex)
mv report/latex/main.pdf report/ChronoLeak_Report_23ECB0F33.pdf
(cd presentation/beamer && tectonic -X compile slides.tex)
mv presentation/beamer/slides.pdf presentation/slides.pdf
echo "Built report/ChronoLeak_Report_23ECB0F33.pdf and presentation/slides.pdf"
