#!/usr/bin/env bash
# Statistical analysis + figures for a run directory (default: results/latest).
set -euo pipefail
cd "$(dirname "$0")/.."
RUN="${1:-results/latest}"
if [[ ! -x .venv/bin/python ]]; then
  python3 -m venv .venv
  .venv/bin/pip install -q -r analysis/requirements.txt
fi
.venv/bin/python analysis/analyze.py "$RUN"
