// trace.hpp — record every intermediate AES state (for the Round Explorer).
#pragma once

#include "aes_common.hpp"

namespace aes {

struct TraceStep {
  int round;          // 0..10
  std::string step;   // "input", "AddRoundKey", "SubBytes", "ShiftRows", "MixColumns"
  Block state;        // state after this step (column-major)
};

struct Trace {
  RoundKeys round_keys;
  std::vector<TraceStep> steps;
  Block ciphertext;
};

// Runs the textbook implementation step by step and records each state.
Trace trace_encrypt(const uint8_t key[kKeyBytes], const uint8_t pt[kBlockBytes]);

} // namespace aes
