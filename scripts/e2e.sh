#!/usr/bin/env bash
# End-to-end test of every module (CLI, pipeline, analysis, server, dashboard, scripts).
#   scripts/e2e.sh          ~1 minute
#   scripts/e2e.sh --full   adds the sanitizer build and scripts/collect.sh --quick (~2 minutes)
set -euo pipefail
cd "$(dirname "$0")/.."
exec python3 tests/e2e/run_e2e.py "$@"
