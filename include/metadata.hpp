// metadata.hpp — platform and build information recorded with every run.
#pragma once

#include <string>

namespace aes {

struct Metadata {
  std::string cpu, model, os_version, compiler, opt_flags, cpu_flags, git_hash;
  std::string openssl_version, openssl_armcap_env, power_source, low_power_mode, timestamp;
  long long l1d_bytes = 0, l2_bytes = 0, cacheline = 0, p_cores = 0, e_cores = 0;
  int feat_aes = 0, feat_dit = 0;
  unsigned timebase_numer = 0, timebase_denom = 0;
  double ns_per_tick = 0, tick_hz = 0;
};

Metadata collect_metadata();
std::string metadata_json(const Metadata& m);  // single-line JSON object

} // namespace aes
