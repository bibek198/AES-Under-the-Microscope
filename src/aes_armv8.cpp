// aes_armv8.cpp — AES-128 using the ARMv8 Cryptography Extensions.
//
// The M4 implements AES rounds in hardware:
//   AESE  (vaeseq_u8):  state = ShiftRows(SubBytes(state XOR roundkey))
//   AESMC (vaesmcq_u8): state = MixColumns(state)
// The S-box lives inside the execution unit, not in memory, so there is no
// secret-indexed load. These instructions are designed to have fixed
// latency, independent of the data.
//
// Note: AESE applies AddRoundKey *before* SubBytes, so round keys are fed
// one step "early" compared to the FIPS-197 description, and the last
// round key is applied with a plain XOR.
#include "aes_impls.hpp"

#include <arm_neon.h>

#if !defined(__ARM_FEATURE_AES)
#error "ARMv8 AES instructions not enabled: compile with -mcpu=apple-m4 or -march=armv8-a+crypto"
#endif

namespace aes {
namespace {

class AesArmv8 final : public Aes128 {
 public:
  void set_key(const uint8_t key[kKeyBytes]) override {
    // Key expansion is done in software (once per key, outside the timed
    // region). The round keys use the same byte order as the state.
    uint8_t rk[kRoundKeyBytes];
    expand_key_ct(key, rk);
    for (int i = 0; i <= kRounds; ++i) rk_[i] = vld1q_u8(rk + 16 * i);
  }

  void encrypt_block(const uint8_t in[16], uint8_t out[16]) const override {
    uint8x16_t s = vld1q_u8(in);
    for (int round = 0; round < kRounds - 1; ++round) {
      s = vaesmcq_u8(vaeseq_u8(s, rk_[round]));  // ARK + SubBytes + ShiftRows + MixColumns
    }
    s = vaeseq_u8(s, rk_[kRounds - 1]);           // final round: no MixColumns
    s = veorq_u8(s, rk_[kRounds]);                // last AddRoundKey
    vst1q_u8(out, s);
  }

  // Bulk path: process 4 blocks at a time so the pipelined AES units stay busy.
  void encrypt_blocks(const uint8_t* in, uint8_t* out, size_t n) const override {
    size_t i = 0;
    for (; i + 4 <= n; i += 4) {
      uint8x16_t a = vld1q_u8(in + 16 * i), b = vld1q_u8(in + 16 * (i + 1));
      uint8x16_t c = vld1q_u8(in + 16 * (i + 2)), d = vld1q_u8(in + 16 * (i + 3));
      for (int r = 0; r < kRounds - 1; ++r) {
        a = vaesmcq_u8(vaeseq_u8(a, rk_[r]));
        b = vaesmcq_u8(vaeseq_u8(b, rk_[r]));
        c = vaesmcq_u8(vaeseq_u8(c, rk_[r]));
        d = vaesmcq_u8(vaeseq_u8(d, rk_[r]));
      }
      a = veorq_u8(vaeseq_u8(a, rk_[kRounds - 1]), rk_[kRounds]);
      b = veorq_u8(vaeseq_u8(b, rk_[kRounds - 1]), rk_[kRounds]);
      c = veorq_u8(vaeseq_u8(c, rk_[kRounds - 1]), rk_[kRounds]);
      d = veorq_u8(vaeseq_u8(d, rk_[kRounds - 1]), rk_[kRounds]);
      vst1q_u8(out + 16 * i, a);
      vst1q_u8(out + 16 * (i + 1), b);
      vst1q_u8(out + 16 * (i + 2), c);
      vst1q_u8(out + 16 * (i + 3), d);
    }
    for (; i < n; ++i) encrypt_block(in + 16 * i, out + 16 * i);
  }

  const char* name() const override { return "armv8"; }

 private:
  uint8x16_t rk_[kRounds + 1]{};
};

} // namespace

std::unique_ptr<Aes128> make_armv8() { return std::make_unique<AesArmv8>(); }

} // namespace aes
