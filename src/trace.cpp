// trace.cpp — step-by-step AES-128 encryption using the textbook functions.
#include "trace.hpp"

#include <cstring>

#include "aes_impls.hpp"

namespace aes {

Trace trace_encrypt(const uint8_t key[kKeyBytes], const uint8_t pt[kBlockBytes]) {
  Trace t{};
  expand_key(key, t.round_keys.data());
  Block s{};
  std::memcpy(s.data(), pt, 16);
  auto record = [&](int round, const char* step) { t.steps.push_back({round, step, s}); };

  record(0, "input");
  ref::add_round_key(s.data(), t.round_keys.data());
  record(0, "AddRoundKey");
  for (int round = 1; round <= kRounds; ++round) {
    ref::sub_bytes(s.data());
    record(round, "SubBytes");
    ref::shift_rows(s.data());
    record(round, "ShiftRows");
    if (round != kRounds) {
      ref::mix_columns(s.data());
      record(round, "MixColumns");
    }
    ref::add_round_key(s.data(), t.round_keys.data() + 16 * round);
    record(round, "AddRoundKey");
  }
  t.ciphertext = s;
  return t;
}

} // namespace aes
