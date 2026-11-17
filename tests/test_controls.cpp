// test_controls.cpp — the positive control and its branch-free twin must
// compute identical results, and the Round Explorer trace must end in the
// real ciphertext.
#include <cstring>
#include <random>

#include "aes_common.hpp"
#include "check.hpp"
#include "controls.hpp"
#include "trace.hpp"

using namespace testing;

int main() {
  bool same = true;
  for (int s = 0; s < 256; ++s)
    same &= aes::leaky_gate(static_cast<uint8_t>(s)) == aes::twin_gate(static_cast<uint8_t>(s));
  check(same, "leaky_gate(s) == twin_gate(s) for all 256 values of s");

  // Trace: final state equals encrypt_block from every implementation.
  std::mt19937 rng(7);
  for (int trial = 0; trial < 200; ++trial) {
    uint8_t key[16], pt[16];
    for (int i = 0; i < 16; ++i) {
      key[i] = static_cast<uint8_t>(rng());
      pt[i] = static_cast<uint8_t>(rng());
    }
    const aes::Trace t = aes::trace_encrypt(key, pt);
    const bool shape_ok = t.steps.size() == 2 + 9 * 4 + 3;  // input, ARK, 9 full rounds, final round
    check(shape_ok, "trace has 41 steps");
    for (const auto& name : aes::impl_names()) {
      auto impl = aes::make_impl(name);
      uint8_t out[16];
      impl->set_key(key);
      impl->encrypt_block(pt, out);
      if (std::memcmp(out, t.ciphertext.data(), 16) != 0 ||
          std::memcmp(out, t.steps.back().state.data(), 16) != 0) {
        check(false, "trace ciphertext equals " + name);
      }
    }
  }
  check(true, "trace ciphertext matches all implementations (200 random cases)");
  return finish("test_controls");
}
