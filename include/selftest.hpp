// selftest.hpp — quick correctness checks run before any measurement.
#pragma once

#include <string>
#include <vector>

namespace aes {

struct SelfTestLine {
  std::string label;
  std::string expected, got;
  bool ok;
};

// Known-answer tests for every implementation plus a 2,000-pair
// cross-check. The timing commands refuse to run if this fails.
bool run_self_test(std::vector<SelfTestLine>* lines = nullptr);

} // namespace aes
