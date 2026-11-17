#!/usr/bin/env bash
# Full experiment collection: E1-E5 + OpenSSL fallback + assembly + analysis.
# Usage: scripts/collect.sh [--quick]
# Run on AC power with other apps closed, and do not use the Mac meanwhile.
set -euo pipefail
cd "$(dirname "$0")/.."
QUICK=""
[[ "${1:-}" == "--quick" ]] && QUICK="--quick"
RUN_ID="${RUN_ID:-$(date +%Y%m%d-%H%M%S)}"
OUT="results/$RUN_ID"

scripts/build.sh O2
scripts/build.sh O0
build/aes_project test --no-color

echo "== Main run (E1-E4, profiles, toy recovery) -> $OUT"
build/aes_project all $QUICK --out "$OUT"

echo "== E5: same experiments compiled at -O0"
build-O0/aes_project controls $QUICK --out "$OUT/O0"
build-O0/aes_project leakage --impl ttable --cond hot $QUICK --out "$OUT/O0"

echo "== H4: OpenSSL with hardware detection disabled (OPENSSL_armcap=0)"
OPENSSL_armcap=0 build/aes_project bench --impl openssl $QUICK --out "$OUT/armcap0"
OPENSSL_armcap=0 build/aes_project leakage --impl openssl $QUICK --out "$OUT/armcap0"

scripts/asm.sh
scripts/analyze.sh "$OUT"
ln -sfn "$RUN_ID" results/latest
echo "Done: $OUT  (results/latest -> $RUN_ID)"
