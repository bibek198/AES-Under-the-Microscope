// test_vectors.cpp — official known-answer tests (FIPS-197, NIST SP 800-38A)
// and checks of the GF(2^8) arithmetic and S-box construction.
#include <cstring>

#include "aes_common.hpp"
#include "check.hpp"
#include "kat_vectors.hpp"
#include "trace.hpp"

using namespace testing;

static void test_gf_arithmetic() {
  // FIPS-197 §4.2: {57} * {83} = {c1}; §4.2.1: {57} * {13} = {fe}
  check(aes::gf_mul(0x57, 0x83) == 0xC1, "GF: {57}*{83} = {c1}");
  check(aes::gf_mul(0x57, 0x13) == 0xFE, "GF: {57}*{13} = {fe}");
  // xtime examples from FIPS-197 §4.2.1
  check(aes::xtime(0x57) == 0xAE, "xtime({57}) = {ae}");
  check(aes::xtime(0xAE) == 0x47, "xtime({ae}) = {47}");
  check(aes::xtime(0x47) == 0x8E, "xtime({47}) = {8e}");
  check(aes::xtime(0x8E) == 0x07, "xtime({8e}) = {07}");
  // Every non-zero element times its inverse is 1.
  bool inv_ok = aes::gf_inv(0) == 0;
  for (int a = 1; a < 256; ++a)
    inv_ok &= aes::gf_mul(static_cast<uint8_t>(a), aes::gf_inv(static_cast<uint8_t>(a))) == 1;
  check(inv_ok, "GF: a * a^-1 = 1 for all a != 0, inv(0) = 0");
}

static void test_sbox() {
  check(aes::SBOX[0x00] == 0x63, "S(00) = 63");
  check(aes::SBOX[0x53] == 0xED, "S(53) = ed");
  bool same = true, no_fixed = true, bijective = true;
  bool seen[256] = {};
  for (int a = 0; a < 256; ++a) {
    const uint8_t s = aes::SBOX[a];
    same &= aes::sbox_compute(static_cast<uint8_t>(a)) == s;
    no_fixed &= (s != a) && (s != (a ^ 0xFF));  // no fixed or opposite-fixed points
    bijective &= !seen[s];
    seen[s] = true;
  }
  check(same, "computed S-box equals table S-box for all 256 inputs");
  check(no_fixed, "S-box has no fixed points and no opposite fixed points");
  check(bijective, "S-box is a permutation");
}

static void test_key_expansion() {
  // FIPS-197 Appendix A.1
  const auto key = hex("2b7e151628aed2a6abf7158809cf4f3c");
  uint8_t rk[176];
  aes::expand_key(key.data(), rk);
  check(equal_hex(rk + 16, "a0fafe1788542cb123a339392a6c7605", 16), "A.1: round key 1");
  check(equal_hex(rk + 160, "d014f9a8c9ee2589e13f0cc8b6630ca6", 16), "A.1: round key 10");
  uint8_t rk_ct[176];
  aes::expand_key_ct(key.data(), rk_ct);
  check(std::memcmp(rk, rk_ct, 176) == 0, "constant-time key expansion matches table version");
}

static void test_appendix_b_intermediates() {
  // FIPS-197 Appendix B: cipher example with intermediate round states.
  const auto key = hex("2b7e151628aed2a6abf7158809cf4f3c");
  const auto pt = hex("3243f6a8885a308d313198a2e0370734");
  const aes::Trace t = aes::trace_encrypt(key.data(), pt.data());
  auto find = [&](int round, const char* step) -> const uint8_t* {
    for (const auto& s : t.steps)
      if (s.round == round && s.step == step) return s.state.data();
    return nullptr;
  };
  check(equal_hex(find(0, "AddRoundKey"), "193de3bea0f4e22b9ac68d2ae9f84808", 16), "B: start of round 1");
  check(equal_hex(find(1, "SubBytes"), "d42711aee0bf98f1b8b45de51e415230", 16), "B: round 1 after SubBytes");
  check(equal_hex(find(1, "ShiftRows"), "d4bf5d30e0b452aeb84111f11e2798e5", 16), "B: round 1 after ShiftRows");
  check(equal_hex(find(1, "MixColumns"), "046681e5e0cb199a48f8d37a2806264c", 16), "B: round 1 after MixColumns");
  check(equal_hex(find(1, "AddRoundKey"), "a49c7ff2689f352b6b5bea43026a5049", 16), "B: start of round 2");
  check(equal_hex(t.ciphertext.data(), "3925841d02dc09fbdc118597196a0b32", 16), "B: ciphertext");
}

static void test_ciphers() {
  for (const auto& name : aes::all_impl_names()) {
    auto impl = aes::make_impl(name);
    for (const auto& v : aes::kKnownAnswers) {
      const auto key = hex(v.key), pt = hex(v.plaintext);
      uint8_t out[16];
      impl->set_key(key.data());
      impl->encrypt_block(pt.data(), out);
      check(equal_hex(out, v.ciphertext, 16), name + ": " + v.label + " (got " + aes::to_hex(out, 16) + ")");
    }
  }
}

int main() {
  test_gf_arithmetic();
  test_sbox();
  test_key_expansion();
  test_appendix_b_intermediates();
  test_ciphers();
  return finish("test_vectors");
}
