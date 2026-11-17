// controls.cpp — positive-control implementations.
//
// INTENTIONALLY VULNERABLE EDUCATIONAL DEMONSTRATION (see controls.hpp).
// The AES encryption itself uses the ARMv8 instructions, so the only
// intended source of data-dependent timing is the injected branch.
#include "controls.hpp"

#include "aes_impls.hpp"
#include "compiler.hpp"

namespace aes {

__attribute__((noinline)) uint32_t control_workload(uint8_t s) {
  uint32_t x = s;
  for (int i = 0; i < 64; ++i) {
    x = x * 1664525u + 1013904223u;  // LCG step; each depends on the previous
    asm volatile("" : "+r"(x));      // stop the compiler collapsing the loop
  }
  return x;
}

// The secret-dependent branch: work is done only when s < 0x80.
__attribute__((noinline)) uint32_t leaky_gate(uint8_t s) {
  if (s < 0x80) {
    return control_workload(s);
  }
  return s;
}

// Branch-free twin: always compute, then choose with a mask.
// mask = 0xFFFFFFFF if s < 0x80 (top bit clear), else 0.
__attribute__((noinline)) uint32_t twin_gate(uint8_t s) {
  const uint32_t w = control_workload(s);
  const uint32_t mask = static_cast<uint32_t>(s >> 7) - 1u;
  return (w & mask) | (static_cast<uint32_t>(s) & ~mask);
}

namespace {

template <uint32_t (*Gate)(uint8_t)>
class PositiveControl final : public Aes128 {
 public:
  explicit PositiveControl(const char* name) : name_(name) {}

  void set_key(const uint8_t key[kKeyBytes]) override {
    inner_->set_key(key);
    k0_ = key[0];
  }

  void encrypt_block(const uint8_t in[16], uint8_t out[16]) const override {
    inner_->encrypt_block(in, out);
    const uint8_t s = SBOX[in[0] ^ k0_];  // first-round S-box output, byte 0
    const uint32_t g = Gate(s);
    do_not_optimize(g);                   // ciphertext is unchanged
  }

  const char* name() const override { return name_; }

 private:
  std::unique_ptr<Aes128> inner_ = make_armv8();
  uint8_t k0_ = 0;
  const char* name_;
};

} // namespace

std::unique_ptr<Aes128> make_pos_leaky() {
  return std::make_unique<PositiveControl<leaky_gate>>("pos_leaky");
}

std::unique_ptr<Aes128> make_pos_twin() {
  return std::make_unique<PositiveControl<twin_gate>>("pos_twin");
}

} // namespace aes
