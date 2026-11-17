#!/usr/bin/env bash
# Configure and build the Release binaries (default -O2 -mcpu=apple-m4).
# Usage: scripts/build.sh [O0|O1|O2|O3]
set -euo pipefail
cd "$(dirname "$0")/.."
OPT="${1:-O2}"
DIR=build
[[ "$OPT" != "O2" ]] && DIR="build-$OPT"
cmake -S . -B "$DIR" -DCMAKE_BUILD_TYPE=Release -DAES_OPT_LEVEL="$OPT" > /dev/null
cmake --build "$DIR" -j "$(sysctl -n hw.ncpu)"
echo "Built $DIR/aes_project (-$OPT)"
