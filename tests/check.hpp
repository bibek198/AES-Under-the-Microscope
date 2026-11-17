// check.hpp — a minimal test helper (no external framework needed).
#pragma once

#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>

#include "aes_common.hpp"

namespace testing {

inline int g_failures = 0;
inline int g_checks = 0;

inline void check(bool ok, const std::string& what) {
  ++g_checks;
  if (!ok) {
    ++g_failures;
    std::printf("  FAIL  %s\n", what.c_str());
  }
}

inline std::vector<uint8_t> hex(const char* s) {
  std::vector<uint8_t> v;
  if (!aes::from_hex(s, v)) {
    std::printf("bad hex literal in test: %s\n", s);
    std::abort();
  }
  return v;
}

inline bool equal_hex(const uint8_t* got, const char* expected_hex, size_t n) {
  return aes::to_hex(got, n) == aes::to_hex(hex(expected_hex).data(), n);
}

inline int finish(const char* suite) {
  if (g_failures == 0)
    std::printf("[PASS] %s: %d checks\n", suite, g_checks);
  else
    std::printf("[FAIL] %s: %d of %d checks failed\n", suite, g_failures, g_checks);
  return g_failures == 0 ? 0 : 1;
}

} // namespace testing
