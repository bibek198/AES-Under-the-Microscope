#!/usr/bin/env bash
# Generate assembly listings for inspection (Experiment E5 / assembly/README.md).
set -euo pipefail
cd "$(dirname "$0")/.."
OSSL="$(brew --prefix openssl@3 2>/dev/null || echo /opt/homebrew/opt/openssl@3)"
FLAGS=(-std=c++20 -mcpu=apple-m4 -Iinclude -I"$OSSL/include" -fno-asynchronous-unwind-tables)
mkdir -p assembly
for f in aes_ref aes_ttable aes_ct aes_armv8 controls; do
  clang++ "${FLAGS[@]}" -O2 -S "src/$f.cpp" -o "assembly/${f}_O2.s"
done
clang++ "${FLAGS[@]}" -O0 -S src/controls.cpp -o assembly/controls_O0.s
clang++ "${FLAGS[@]}" -O0 -S src/aes_ttable.cpp -o assembly/aes_ttable_O0.s
# OpenSSL: count hardware AES instructions in the shared library.
LIB="$OSSL/lib/libcrypto.3.dylib"
{
  echo "libcrypto: $LIB"
  echo "aese  instructions: $(otool -tV "$LIB" | grep -c $'\taese')"
  echo "aesmc instructions: $(otool -tV "$LIB" | grep -c $'\taesmc')"
  echo "AES-related symbols:"
  nm "$LIB" 2>/dev/null | grep -Ei ' t _?(aes_v8|vpaes|bsaes|AES_encrypt|aes_hw)' | awk '{print "  " $3}' | sort -u | head -20
} > assembly/openssl_symbols.txt
echo "Assembly written to assembly/"
