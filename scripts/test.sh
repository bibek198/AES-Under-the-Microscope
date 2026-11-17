#!/usr/bin/env bash
# Build and run the full correctness suite, plus a sanitizer (ASan+UBSan) pass.
set -euo pipefail
cd "$(dirname "$0")/.."
scripts/build.sh > /dev/null
(cd build && ctest --output-on-failure)
if [[ "${1:-}" != "--no-sanitize" ]]; then
  echo "== AddressSanitizer + UndefinedBehaviorSanitizer (Debug) =="
  cmake -S . -B build-asan -DCMAKE_BUILD_TYPE=Debug -DAES_SANITIZE=ON > /dev/null
  cmake --build build-asan -j "$(sysctl -n hw.ncpu)" > /dev/null
  (cd build-asan && ctest --output-on-failure)
fi
