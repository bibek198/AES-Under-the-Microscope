// timer.cpp — timebase conversion.
#include "timer.hpp"

namespace aes::timer {

namespace {
const mach_timebase_info_data_t& timebase() {
  static const mach_timebase_info_data_t tb = [] {
    mach_timebase_info_data_t t{};
    mach_timebase_info(&t);
    return t;
  }();
  return tb;
}
} // namespace

uint32_t timebase_numer() { return timebase().numer; }
uint32_t timebase_denom() { return timebase().denom; }
double ns_per_tick() { return static_cast<double>(timebase().numer) / timebase().denom; }
double tick_hz() { return 1e9 / ns_per_tick(); }

} // namespace aes::timer
