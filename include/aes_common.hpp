// aes_common.hpp — shared AES-128 definitions.
//
// AES-128 (FIPS-197) at a glance:
//   * block = 128 bits = 16 bytes, arranged as a 4x4 byte "state" matrix
//   * key   = 128 bits, expanded into 11 round keys (176 bytes)
//   * 10 rounds: rounds 1..9 = SubBytes, ShiftRows, MixColumns, AddRoundKey;
//     round 10 omits MixColumns. An initial AddRoundKey precedes round 1.
//
// State layout (column-major, as in FIPS-197 §3.4):
//   state[r + 4*c] holds row r, column c. Input byte in[i] maps to
//   row (i mod 4), column (i / 4), so the 16 input bytes fill the state
//   column by column and the in-memory order equals the input order.
#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

namespace aes {

inline constexpr int kBlockBytes = 16;     // 128-bit block
inline constexpr int kKeyBytes = 16;       // 128-bit key (Nk = 4 words)
inline constexpr int kRounds = 10;         // Nr = 10 for AES-128
inline constexpr int kRoundKeyBytes = 176; // (Nr + 1) * 16

using Block = std::array<uint8_t, kBlockBytes>;
using RoundKeys = std::array<uint8_t, kRoundKeyBytes>;

// ---------------------------------------------------------------------------
// Common interface implemented by every AES variant under test.
// ---------------------------------------------------------------------------
struct Aes128 {
  virtual ~Aes128() = default;
  virtual void set_key(const uint8_t key[kKeyBytes]) = 0;
  virtual void encrypt_block(const uint8_t in[kBlockBytes], uint8_t out[kBlockBytes]) const = 0;
  // Bulk ECB encryption of n consecutive blocks (default: loop over encrypt_block).
  virtual void encrypt_blocks(const uint8_t* in, uint8_t* out, size_t nblocks) const {
    for (size_t i = 0; i < nblocks; ++i) encrypt_block(in + 16 * i, out + 16 * i);
  }
  virtual const char* name() const = 0;
};

// Factory: "ref", "ttable", "ct", "armv8", "openssl", "pos_leaky", "pos_twin".
std::unique_ptr<Aes128> make_impl(std::string_view name);
// The five real AES implementations, in presentation order.
const std::vector<std::string>& impl_names();
// The five real implementations plus the two positive-control variants.
const std::vector<std::string>& all_impl_names();

// ---------------------------------------------------------------------------
// GF(2^8) arithmetic.
// AES works in the finite field GF(2^8) = GF(2)[x] / m(x), with the
// irreducible polynomial m(x) = x^8 + x^4 + x^3 + x + 1 (0x11B).
// A byte b7..b0 represents the polynomial b7 x^7 + ... + b1 x + b0.
// Addition is XOR; multiplication is polynomial multiplication mod m(x).
// ---------------------------------------------------------------------------

// xtime(a) = a * x mod m(x). Shift left; if bit 7 fell off, reduce by
// XORing 0x1B (= m(x) without the x^8 term). Written branchlessly:
// -(a >> 7) is 0xFF when the top bit is set and 0x00 otherwise.
constexpr uint8_t xtime(uint8_t a) {
  return static_cast<uint8_t>((a << 1) ^ (0x1B & -(a >> 7)));
}

// General multiplication a * b in GF(2^8) (shift-and-add / "Russian peasant").
// Fixed 8 iterations and mask-based selection: no data-dependent branches.
constexpr uint8_t gf_mul(uint8_t a, uint8_t b) {
  uint8_t r = 0;
  for (int i = 0; i < 8; ++i) {
    r ^= static_cast<uint8_t>(a & -(b & 1)); // add a if the current bit of b is 1
    a = xtime(a);
    b = static_cast<uint8_t>(b >> 1);
  }
  return r;
}

// Multiplicative inverse via Fermat: in GF(2^8)* (order 255), a^255 = 1,
// so a^-1 = a^254. By convention inv(0) = 0, which a^254 also yields.
// Fixed addition chain of 11 multiplications (same work for every input).
constexpr uint8_t gf_inv(uint8_t a) {
  uint8_t a2 = gf_mul(a, a);          // a^2
  uint8_t a3 = gf_mul(a2, a);         // a^3
  uint8_t a6 = gf_mul(a3, a3);        // a^6
  uint8_t a12 = gf_mul(a6, a6);       // a^12
  uint8_t a15 = gf_mul(a12, a3);      // a^15
  uint8_t a30 = gf_mul(a15, a15);     // a^30
  uint8_t a60 = gf_mul(a30, a30);     // a^60
  uint8_t a120 = gf_mul(a60, a60);    // a^120
  uint8_t a240 = gf_mul(a120, a120);  // a^240
  uint8_t a252 = gf_mul(a240, a12);   // a^252
  return gf_mul(a252, a2);            // a^254
}

constexpr uint8_t rotl8(uint8_t x, int s) {
  return static_cast<uint8_t>((x << s) | (x >> (8 - s)));
}

// S-box (FIPS-197 §5.1.1): S(a) = Affine(a^-1), where the affine map over
// GF(2) is b' = b ^ rotl(b,1) ^ rotl(b,2) ^ rotl(b,3) ^ rotl(b,4) ^ 0x63.
// Inversion gives non-linearity; the affine step removes the algebraic
// simplicity of pure inversion and ensures no fixed points (S(a) != a).
constexpr uint8_t sbox_compute(uint8_t a) {
  uint8_t b = gf_inv(a);
  return static_cast<uint8_t>(b ^ rotl8(b, 1) ^ rotl8(b, 2) ^ rotl8(b, 3) ^ rotl8(b, 4) ^ 0x63);
}

// The S-box as a 256-byte lookup table (generated at compile time from the
// mathematical definition above, so it cannot contain typos).
extern const std::array<uint8_t, 256> SBOX;

// Round constants Rcon[i] = x^(i-1) in GF(2^8), i = 1..10.
inline constexpr std::array<uint8_t, 11> RCON = {0x00, 0x01, 0x02, 0x04, 0x08, 0x10,
                                                 0x20, 0x40, 0x80, 0x1B, 0x36};

// ---------------------------------------------------------------------------
// Key expansion (FIPS-197 §5.2), shared by the software implementations.
// w[i] = w[i-4] ^ temp, where for i % 4 == 0:
//   temp = SubWord(RotWord(w[i-1])) ^ Rcon[i/4]
// The table version uses SBOX; the constant-time version computes S(a).
// ---------------------------------------------------------------------------
void expand_key(const uint8_t key[kKeyBytes], uint8_t round_keys[kRoundKeyBytes]);
void expand_key_ct(const uint8_t key[kKeyBytes], uint8_t round_keys[kRoundKeyBytes]);

// ---------------------------------------------------------------------------
// Utilities
// ---------------------------------------------------------------------------
std::string to_hex(const uint8_t* data, size_t n);
// Parses an even-length hex string (spaces allowed). Returns false on error.
bool from_hex(std::string_view hex, std::vector<uint8_t>& out);

} // namespace aes
