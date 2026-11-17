// aes_common.cpp — S-box table, key expansion, hex helpers.
#include "aes_common.hpp"

#include <cctype>
#include <cstring>

namespace aes {

namespace {
constexpr std::array<uint8_t, 256> make_sbox() {
  std::array<uint8_t, 256> t{};
  for (int i = 0; i < 256; ++i) t[i] = sbox_compute(static_cast<uint8_t>(i));
  return t;
}
constexpr std::array<uint8_t, 256> kSbox = make_sbox();

// Compile-time sanity checks against FIPS-197 Figure 7.
static_assert(kSbox[0x00] == 0x63, "S(00) must be 63");
static_assert(kSbox[0x01] == 0x7C, "S(01) must be 7c");
static_assert(kSbox[0x53] == 0xED, "S(53) must be ed");
static_assert(kSbox[0xFF] == 0x16, "S(ff) must be 16");

// Generic key expansion parameterised by the S-box function used in SubWord.
template <typename SubByte>
void expand_key_impl(const uint8_t key[kKeyBytes], uint8_t rk[kRoundKeyBytes], SubByte sub) {
  // The first Nk = 4 words are the cipher key itself.
  std::memcpy(rk, key, kKeyBytes);
  for (int i = 4; i < 44; ++i) {
    uint8_t temp[4];
    std::memcpy(temp, rk + 4 * (i - 1), 4);
    if (i % 4 == 0) {
      // RotWord: [a0,a1,a2,a3] -> [a1,a2,a3,a0]
      const uint8_t t0 = temp[0];
      temp[0] = temp[1];
      temp[1] = temp[2];
      temp[2] = temp[3];
      temp[3] = t0;
      // SubWord: apply the S-box to each byte
      for (auto& b : temp) b = sub(b);
      // XOR the round constant into the first byte. Rcon breaks the
      // symmetry between rounds (otherwise all round keys would be related
      // by a simple pattern, enabling slide attacks).
      temp[0] ^= RCON[i / 4];
    }
    for (int j = 0; j < 4; ++j)
      rk[4 * i + j] = static_cast<uint8_t>(rk[4 * (i - 4) + j] ^ temp[j]);
  }
}
} // namespace

const std::array<uint8_t, 256> SBOX = kSbox;

void expand_key(const uint8_t key[kKeyBytes], uint8_t round_keys[kRoundKeyBytes]) {
  // Table lookup indexed by key bytes: secret-dependent memory access.
  expand_key_impl(key, round_keys, [](uint8_t b) { return SBOX[b]; });
}

void expand_key_ct(const uint8_t key[kKeyBytes], uint8_t round_keys[kRoundKeyBytes]) {
  // S-box computed arithmetically: no secret-indexed loads.
  expand_key_impl(key, round_keys, [](uint8_t b) { return sbox_compute(b); });
}

std::string to_hex(const uint8_t* data, size_t n) {
  static const char* digits = "0123456789abcdef";
  std::string s;
  s.reserve(2 * n);
  for (size_t i = 0; i < n; ++i) {
    s.push_back(digits[data[i] >> 4]);
    s.push_back(digits[data[i] & 0xF]);
  }
  return s;
}

bool from_hex(std::string_view hex, std::vector<uint8_t>& out) {
  out.clear();
  int hi = -1;
  for (char ch : hex) {
    if (ch == ' ' || ch == ':' || ch == '_') continue;
    int v;
    if (ch >= '0' && ch <= '9') v = ch - '0';
    else if (ch >= 'a' && ch <= 'f') v = ch - 'a' + 10;
    else if (ch >= 'A' && ch <= 'F') v = ch - 'A' + 10;
    else return false;
    if (hi < 0) {
      hi = v;
    } else {
      out.push_back(static_cast<uint8_t>((hi << 4) | v));
      hi = -1;
    }
  }
  return hi < 0;
}

} // namespace aes
