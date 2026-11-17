// EDUCATIONAL IMPLEMENTATION — NOT SUITABLE FOR PROTECTING REAL SECRETS.
// Uses secret-dependent table lookups that can leak timing information.
//
// aes_ttable.cpp — classic "T-table" AES (Daemen & Rijmen, The Design of
// Rijndael §4.2). SubBytes, ShiftRows and MixColumns are merged into four
// 256-entry tables of 32-bit words (4 x 1 KB = 4 KB). One round becomes 16
// table lookups and XORs. Fast in software, but every lookup index is a
// secret-dependent byte, which is exactly what cache-timing attacks
// (Bernstein 2005; Osvik, Shamir & Tromer 2006) exploit.
//
// Word convention: a column (s0, s1, s2, s3) is packed as
//   w = s0 | s1 << 8 | s2 << 16 | s3 << 24   (row r in byte r).
#include "aes_impls.hpp"

#include <cstring>

namespace aes {
namespace {

constexpr uint32_t pack(uint8_t b0, uint8_t b1, uint8_t b2, uint8_t b3) {
  return uint32_t(b0) | uint32_t(b1) << 8 | uint32_t(b2) << 16 | uint32_t(b3) << 24;
}
constexpr uint32_t rotl32(uint32_t x, int s) { return (x << s) | (x >> (32 - s)); }

// T0[a] is the MixColumns contribution of S(a) sitting in row 0:
// column vector (02*S, 01*S, 01*S, 03*S). T1..T3 are byte rotations
// of T0 for rows 1..3 (the MixColumns matrix is circulant).
struct Tables {
  alignas(128) uint32_t t0[256];
  alignas(128) uint32_t t1[256];
  alignas(128) uint32_t t2[256];
  alignas(128) uint32_t t3[256];
};

constexpr Tables make_tables() {
  Tables t{};
  for (int a = 0; a < 256; ++a) {
    const uint8_t s = sbox_compute(static_cast<uint8_t>(a));
    const uint8_t s2 = xtime(s);
    const uint8_t s3 = static_cast<uint8_t>(s2 ^ s);
    t.t0[a] = pack(s2, s, s, s3);
    t.t1[a] = rotl32(t.t0[a], 8);
    t.t2[a] = rotl32(t.t0[a], 16);
    t.t3[a] = rotl32(t.t0[a], 24);
  }
  return t;
}

// 4 KB of tables = 32 cache lines of 128 bytes on Apple M4.
constexpr Tables kT = make_tables();

inline uint8_t byte(uint32_t w, int r) { return static_cast<uint8_t>(w >> (8 * r)); }

inline uint32_t load_word(const uint8_t* p) { return pack(p[0], p[1], p[2], p[3]); }
inline void store_word(uint8_t* p, uint32_t w) {
  p[0] = byte(w, 0);
  p[1] = byte(w, 1);
  p[2] = byte(w, 2);
  p[3] = byte(w, 3);
}

class AesTTable final : public Aes128 {
 public:
  void set_key(const uint8_t key[kKeyBytes]) override {
    uint8_t rk[kRoundKeyBytes];
    expand_key(key, rk);
    for (int i = 0; i < 44; ++i) rk_[i] = load_word(rk + 4 * i);
  }

  void encrypt_block(const uint8_t in[16], uint8_t out[16]) const override {
    uint32_t s0 = load_word(in) ^ rk_[0];
    uint32_t s1 = load_word(in + 4) ^ rk_[1];
    uint32_t s2 = load_word(in + 8) ^ rk_[2];
    uint32_t s3 = load_word(in + 12) ^ rk_[3];

    // Rounds 1..9. Output column c takes row r from input column c + r
    // (that is ShiftRows), looks it up in T_r (SubBytes + MixColumns),
    // and XORs everything with the round key.
    for (int round = 1; round < kRounds; ++round) {
      const uint32_t* k = rk_ + 4 * round;
      const uint32_t n0 = kT.t0[byte(s0, 0)] ^ kT.t1[byte(s1, 1)] ^ kT.t2[byte(s2, 2)] ^ kT.t3[byte(s3, 3)] ^ k[0];
      const uint32_t n1 = kT.t0[byte(s1, 0)] ^ kT.t1[byte(s2, 1)] ^ kT.t2[byte(s3, 2)] ^ kT.t3[byte(s0, 3)] ^ k[1];
      const uint32_t n2 = kT.t0[byte(s2, 0)] ^ kT.t1[byte(s3, 1)] ^ kT.t2[byte(s0, 2)] ^ kT.t3[byte(s1, 3)] ^ k[2];
      const uint32_t n3 = kT.t0[byte(s3, 0)] ^ kT.t1[byte(s0, 1)] ^ kT.t2[byte(s1, 2)] ^ kT.t3[byte(s2, 3)] ^ k[3];
      s0 = n0; s1 = n1; s2 = n2; s3 = n3;
    }

    // Final round: SubBytes + ShiftRows only (no MixColumns), using the
    // plain S-box.
    const uint32_t* k = rk_ + 4 * kRounds;
    const uint32_t c0 = pack(SBOX[byte(s0, 0)], SBOX[byte(s1, 1)], SBOX[byte(s2, 2)], SBOX[byte(s3, 3)]) ^ k[0];
    const uint32_t c1 = pack(SBOX[byte(s1, 0)], SBOX[byte(s2, 1)], SBOX[byte(s3, 2)], SBOX[byte(s0, 3)]) ^ k[1];
    const uint32_t c2 = pack(SBOX[byte(s2, 0)], SBOX[byte(s3, 1)], SBOX[byte(s0, 2)], SBOX[byte(s1, 3)]) ^ k[2];
    const uint32_t c3 = pack(SBOX[byte(s3, 0)], SBOX[byte(s0, 1)], SBOX[byte(s1, 2)], SBOX[byte(s2, 3)]) ^ k[3];
    store_word(out, c0);
    store_word(out + 4, c1);
    store_word(out + 8, c2);
    store_word(out + 12, c3);
  }

  const char* name() const override { return "ttable"; }

 private:
  uint32_t rk_[44]{};
};

} // namespace

std::unique_ptr<Aes128> make_ttable() { return std::make_unique<AesTTable>(); }

} // namespace aes
