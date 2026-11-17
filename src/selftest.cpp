// selftest.cpp
#include "selftest.hpp"

#include <cstring>
#include <random>

#include "aes_common.hpp"
#include "kat_vectors.hpp"

namespace aes {

bool run_self_test(std::vector<SelfTestLine>* lines) {
  bool all_ok = true;
  for (const auto& name : all_impl_names()) {
    auto impl = make_impl(name);
    for (const auto& v : kKnownAnswers) {
      std::vector<uint8_t> key, pt;
      from_hex(v.key, key);
      from_hex(v.plaintext, pt);
      uint8_t out[16];
      impl->set_key(key.data());
      impl->encrypt_block(pt.data(), out);
      const std::string got = to_hex(out, 16);
      const bool ok = got == v.ciphertext;
      all_ok &= ok;
      if (lines) lines->push_back({name + "  " + v.label, v.ciphertext, got, ok});
    }
  }
  // Cross-check on random inputs.
  std::mt19937_64 rng(42);
  auto ref = make_impl("ref");
  int mismatches = 0;
  std::vector<std::unique_ptr<Aes128>> others;
  for (const auto& n : all_impl_names())
    if (n != "ref") others.push_back(make_impl(n));
  for (int i = 0; i < 2000; ++i) {
    uint8_t key[16], pt[16], a[16], b[16];
    for (int j = 0; j < 16; ++j) {
      key[j] = static_cast<uint8_t>(rng());
      pt[j] = static_cast<uint8_t>(rng());
    }
    ref->set_key(key);
    ref->encrypt_block(pt, a);
    for (auto& o : others) {
      o->set_key(key);
      o->encrypt_block(pt, b);
      mismatches += std::memcmp(a, b, 16) != 0;
    }
  }
  all_ok &= mismatches == 0;
  if (lines)
    lines->push_back({"all implementations agree on 2,000 random (key, plaintext) pairs", "0 mismatches",
                      std::to_string(mismatches) + " mismatches", mismatches == 0});
  return all_ok;
}

} // namespace aes
