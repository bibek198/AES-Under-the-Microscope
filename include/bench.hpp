// bench.hpp — performance measurement (Experiment E2).
#pragma once

#include <string>
#include <vector>

#include "aes_common.hpp"

namespace aes {

struct BenchResult {
  std::string impl;
  std::vector<double> latency_ns;  // per-repetition ns per block (dependent chain)
  double latency_median = 0, latency_mean = 0, latency_sd = 0;
  double tp_4k_mbps = 0, tp_1m_mbps = 0;  // bulk ECB throughput (MB = 10^6 bytes)
};

// Latency: each block's output is the next block's input, so blocks cannot
// overlap in the pipeline. Throughput: independent blocks via encrypt_blocks.
BenchResult run_bench(Aes128& impl, bool quick);

} // namespace aes
