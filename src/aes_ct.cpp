// aes_ct.cpp — constant-time software AES-128.
//
// Defence idea: never use a secret as a memory address or a branch
// condition. The S-box is therefore not looked up; it is *computed* from
// its mathematical definition, S(a) = Affine(a^254) in GF(2^8), using only
// shifts, ANDs and XORs on fixed-size data.
//
// To make this affordable, the 16 state bytes are processed in parallel
// as two 64-bit words ("SWAR": SIMD within a register). Each GF(2^8)
// operation below acts on 8 bytes at once, independently per byte.
//
// Constant-time here means: no secret-dependent branches and no
// secret-dependent memory addresses in the source. Whether the machine
// code keeps that property is checked in assembly/README.md, and the
// timing behaviour is tested empirically. Neither proves the absence of
// all leakage.
#include "aes_impls.hpp"

#include <cstring>

namespace aes {
namespace {

using u64 = uint64_t;
constexpr u64 kLow7 = 0x7F7F7F7F7F7F7F7FULL;
constexpr u64 kOnes = 0x0101010101010101ULL;

// xtime on 8 packed bytes: shift each byte left by 1 and conditionally
// reduce by 0x1B. ((a >> 7) & kOnes) is 1 in each byte whose top bit was set;
// multiplying by 0x1B spreads that into the reduction constant (no
// carries between bytes, since 0x1B < 0x100).
inline u64 xtime8(u64 a) { return ((a & kLow7) << 1) ^ (((a >> 7) & kOnes) * 0x1B); }

// Byte-wise GF(2^8) multiplication of 8 packed pairs, fixed 8 iterations.
// mask = 0xFF in each byte whose current bit of b is 1, else 0x00.
inline u64 gf_mul8(u64 a, u64 b) {
  u64 r = 0;
  for (int i = 0; i < 8; ++i) {
    const u64 mask = (b & kOnes) * 0xFF;
    r ^= a & mask;
    a = xtime8(a);
    b = (b >> 1) & kLow7;
  }
  return r;
}

// Rotate every byte left by s (0 < s < 8), independently.
inline u64 rotl_bytes(u64 x, int s) {
  const u64 hi_mask = kOnes * static_cast<u64>((0xFF << (8 - s)) & 0xFF); // bits leaving the top
  const u64 lo_mask = ~hi_mask;
  return ((x & lo_mask) << s) | ((x & hi_mask) >> (8 - s));
}

// S-box on 8 bytes in parallel: inversion by a^254, then the affine map.
inline u64 sbox8(u64 a) {
  const u64 a2 = gf_mul8(a, a);
  const u64 a3 = gf_mul8(a2, a);
  const u64 a6 = gf_mul8(a3, a3);
  const u64 a12 = gf_mul8(a6, a6);
  const u64 a15 = gf_mul8(a12, a3);
  const u64 a30 = gf_mul8(a15, a15);
  const u64 a60 = gf_mul8(a30, a30);
  const u64 a120 = gf_mul8(a60, a60);
  const u64 a240 = gf_mul8(a120, a120);
  const u64 a252 = gf_mul8(a240, a12);
  const u64 b = gf_mul8(a252, a2);
  return b ^ rotl_bytes(b, 1) ^ rotl_bytes(b, 2) ^ rotl_bytes(b, 3) ^ rotl_bytes(b, 4) ^
         (kOnes * 0x63);
}

inline u64 load64(const uint8_t* p) {
  u64 v;
  std::memcpy(&v, p, 8);
  return v;
}
inline void store64(uint8_t* p, u64 v) { std::memcpy(p, &v, 8); }

// SubBytes on all 16 bytes: two parallel S-box evaluations.
inline void sub_bytes_ct(uint8_t s[16]) {
  store64(s, sbox8(load64(s)));
  store64(s + 8, sbox8(load64(s + 8)));
}

// ShiftRows only moves bytes between fixed positions (indices do not
// depend on data), so the textbook version is already constant-time.
// MixColumns uses xtime, which is branch-free. AddRoundKey is XOR.

class AesCt final : public Aes128 {
 public:
  void set_key(const uint8_t key[kKeyBytes]) override { expand_key_ct(key, rk_.data()); }

  void encrypt_block(const uint8_t in[16], uint8_t out[16]) const override {
    uint8_t s[16];
    std::memcpy(s, in, 16);
    ref::add_round_key(s, rk_.data());
    for (int round = 1; round < kRounds; ++round) {
      sub_bytes_ct(s);
      ref::shift_rows(s);
      ref::mix_columns(s);
      ref::add_round_key(s, rk_.data() + 16 * round);
    }
    sub_bytes_ct(s);
    ref::shift_rows(s);
    ref::add_round_key(s, rk_.data() + 16 * kRounds);
    std::memcpy(out, s, 16);
  }

  const char* name() const override { return "ct"; }

 private:
  RoundKeys rk_{};
};

} // namespace

std::unique_ptr<Aes128> make_ct() { return std::make_unique<AesCt>(); }

} // namespace aes
