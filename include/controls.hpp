// controls.hpp — experimental controls for the leakage harness.
//
// POSITIVE CONTROL — INTENTIONALLY VULNERABLE EDUCATIONAL DEMONSTRATION.
// It deliberately injects a secret-dependent branch next to an AES
// encryption, to prove that the measurement harness CAN detect timing
// leakage when it exists. It is NOT a weakness of AES or of any real
// implementation.
//
// The secret condition is on the first-round S-box output byte
//   s = S[p0 XOR k0]   (plaintext byte 0, key byte 0)
// If s < 0x80 an extra fixed workload runs; otherwise it is skipped.
#pragma once

#include "aes_common.hpp"

namespace aes {

// Deterministic 64-step workload (a dependent chain of multiply-adds).
uint32_t control_workload(uint8_t s);

// LEAKY: branches on the secret-derived byte s.
uint32_t leaky_gate(uint8_t s);

// TWIN: identical result, computed without a branch (always does the
// work, then selects the answer with a bit mask).
uint32_t twin_gate(uint8_t s);

std::unique_ptr<Aes128> make_pos_leaky();  // ARMv8 AES + leaky_gate
std::unique_ptr<Aes128> make_pos_twin();   // ARMv8 AES + twin_gate

} // namespace aes
