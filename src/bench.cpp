// bench.cpp — latency and throughput benchmarks.
#include "bench.hpp"

#include <pthread.h>
#include <pthread/qos.h>

#include <algorithm>
#include <cmath>
#include <numeric>

#include "compiler.hpp"
#include "harness.hpp"
#include "timer.hpp"

namespace aes {

namespace {

double median(std::vector<double> v) {
  std::sort(v.begin(), v.end());
  const size_t n = v.size();
  return n % 2 ? v[n / 2] : 0.5 * (v[n / 2 - 1] + v[n / 2]);
}

// Median throughput over several timed passes of encrypt_blocks.
double throughput_mbps(const Aes128& impl, size_t bytes, int passes, double min_seconds) {
  std::vector<uint8_t> in(bytes), out(bytes);
  for (size_t i = 0; i < bytes; ++i) in[i] = static_cast<uint8_t>(i * 31);
  const size_t blocks = bytes / 16;
  impl.encrypt_blocks(in.data(), out.data(), blocks);  // warm-up
  std::vector<double> rates;
  for (int p = 0; p < passes; ++p) {
    uint64_t reps = 0;
    const uint64_t t0 = timer::now_ticks();
    uint64_t t1 = t0;
    do {
      impl.encrypt_blocks(in.data(), out.data(), blocks);
      clobber_memory();
      ++reps;
      t1 = timer::now_ticks();
    } while (static_cast<double>(t1 - t0) * timer::ns_per_tick() < min_seconds * 1e9);
    const double secs = static_cast<double>(t1 - t0) * timer::ns_per_tick() * 1e-9;
    rates.push_back(static_cast<double>(reps * bytes) / secs / 1e6);
  }
  do_not_optimize(out[0]);
  return median(rates);
}

} // namespace

BenchResult run_bench(Aes128& impl, bool quick) {
  pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
  impl.set_key(kExperimentKey.data());
  BenchResult r;
  r.impl = impl.name();

  // Pick a chain length that takes ~2 ms (quick) or ~5 ms per repetition.
  const int per_rep_probe = calibrate_batch(impl, quick ? 2e6 : 5e6);
  const int reps = quick ? 15 : 41;
  uint8_t buf[16] = {};
  for (int rep = 0; rep < reps; ++rep) {
    const uint64_t t0 = timer::now_ticks();
    for (int i = 0; i < per_rep_probe; ++i) {
      impl.encrypt_block(buf, buf);  // output feeds the next input
    }
    const uint64_t t1 = timer::now_ticks();
    r.latency_ns.push_back(static_cast<double>(t1 - t0) * timer::ns_per_tick() / per_rep_probe);
  }
  do_not_optimize(buf);

  r.latency_median = median(r.latency_ns);
  r.latency_mean = std::accumulate(r.latency_ns.begin(), r.latency_ns.end(), 0.0) / reps;
  double ss = 0;
  for (double x : r.latency_ns) ss += (x - r.latency_mean) * (x - r.latency_mean);
  r.latency_sd = std::sqrt(ss / (reps - 1));

  const int passes = quick ? 3 : 7;
  const double min_s = quick ? 0.01 : 0.05;
  r.tp_4k_mbps = throughput_mbps(impl, 4096, passes, min_s);
  r.tp_1m_mbps = throughput_mbps(impl, 1u << 20, passes, min_s);
  return r;
}

} // namespace aes
