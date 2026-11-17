// timer.hpp — the timing source used for every measurement.
//
// On Apple Silicon, mach_absolute_time() reads the system counter, which
// ticks at 24 MHz (one tick ~ 41.67 ns). std::chrono::steady_clock wraps the
// same counter; we call it directly so the raw tick values and the
// tick-to-nanosecond conversion are explicit and recorded in the metadata.
//
// This is NOT a CPU-cycle counter. A single fast AES block takes far less
// than one tick, which is why samples time a batch of B encryptions.
#pragma once

#include <mach/mach_time.h>

#include <cstdint>

namespace aes::timer {

// ISB (instruction synchronisation barrier) on both sides stops the CPU
// from reordering the counter read relative to the timed work.
inline uint64_t now_ticks() {
  __builtin_arm_isb(0xF);
  const uint64_t t = mach_absolute_time();
  __builtin_arm_isb(0xF);
  return t;
}

double ns_per_tick();     // from mach_timebase_info (125/3 on Apple Silicon)
double tick_hz();         // counter frequency in Hz
uint32_t timebase_numer();
uint32_t timebase_denom();

} // namespace aes::timer
