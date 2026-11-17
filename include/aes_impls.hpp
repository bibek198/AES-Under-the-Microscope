// aes_impls.hpp — constructors for each implementation, plus the textbook
// round transformations (exposed so the Round Explorer trace can reuse them).
#pragma once

#include "aes_common.hpp"

namespace aes {

std::unique_ptr<Aes128> make_ref();      // textbook, byte-oriented, S-box table
std::unique_ptr<Aes128> make_ttable();   // 4 x 1 KB T-tables
std::unique_ptr<Aes128> make_ct();       // constant-time, computed S-box
std::unique_ptr<Aes128> make_armv8();    // ARMv8 Crypto Extensions
std::unique_ptr<Aes128> make_openssl();  // OpenSSL 3 EVP AES-128-ECB

namespace ref {
// The four FIPS-197 round transformations on a column-major state.
void sub_bytes(uint8_t s[16]);
void shift_rows(uint8_t s[16]);
void mix_columns(uint8_t s[16]);
void add_round_key(uint8_t s[16], const uint8_t* rk);
} // namespace ref

} // namespace aes
