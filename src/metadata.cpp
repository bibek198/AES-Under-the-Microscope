// metadata.cpp — gather sysctl values, toolchain and power state.
#include "metadata.hpp"

#include <openssl/crypto.h>
#include <sys/sysctl.h>

#include <cstdio>
#include <cstdlib>
#include <ctime>

#include "json_out.hpp"
#include "timer.hpp"

#ifndef AES_OPT_LABEL
#define AES_OPT_LABEL "unknown"
#endif
#ifndef AES_CPU_LABEL
#define AES_CPU_LABEL "unknown"
#endif
#ifndef AES_GIT_HASH
#define AES_GIT_HASH "unknown"
#endif

namespace aes {

namespace {

std::string sysctl_str(const char* name) {
  size_t len = 0;
  if (sysctlbyname(name, nullptr, &len, nullptr, 0) != 0 || len == 0) return "";
  std::string s(len, '\0');
  if (sysctlbyname(name, s.data(), &len, nullptr, 0) != 0) return "";
  while (!s.empty() && s.back() == '\0') s.pop_back();
  return s;
}

long long sysctl_int(const char* name) {
  long long v = 0;
  size_t len = sizeof v;
  if (sysctlbyname(name, &v, &len, nullptr, 0) != 0) return 0;
  if (len == sizeof(int)) return static_cast<long long>(*reinterpret_cast<int*>(&v));
  return v;
}

// Runs a fixed command (no user input) and returns the first line matching `needle`.
std::string command_line_matching(const char* cmd, const char* needle) {
  std::string result;
  if (FILE* f = popen(cmd, "r")) {
    char line[512];
    while (std::fgets(line, sizeof line, f)) {
      std::string s(line);
      if (s.find(needle) != std::string::npos) {
        while (!s.empty() && (s.back() == '\n' || s.back() == ' ')) s.pop_back();
        result = s;
        break;
      }
    }
    pclose(f);
  }
  return result;
}

} // namespace

Metadata collect_metadata() {
  Metadata m;
  m.cpu = sysctl_str("machdep.cpu.brand_string");
  m.model = sysctl_str("hw.model");
  m.os_version = "macOS " + sysctl_str("kern.osproductversion");
  m.compiler = __VERSION__;
  m.opt_flags = AES_OPT_LABEL;
  m.cpu_flags = AES_CPU_LABEL;
  m.git_hash = AES_GIT_HASH;
  m.openssl_version = OpenSSL_version(OPENSSL_VERSION);
  const char* armcap = std::getenv("OPENSSL_armcap");
  m.openssl_armcap_env = armcap ? armcap : "(unset: hardware AES path expected)";
  m.l1d_bytes = sysctl_int("hw.perflevel0.l1dcachesize");
  m.l2_bytes = sysctl_int("hw.perflevel0.l2cachesize");
  m.cacheline = sysctl_int("hw.cachelinesize");
  m.p_cores = sysctl_int("hw.perflevel0.physicalcpu");
  m.e_cores = sysctl_int("hw.perflevel1.physicalcpu");
  m.feat_aes = static_cast<int>(sysctl_int("hw.optional.arm.FEAT_AES"));
  m.feat_dit = static_cast<int>(sysctl_int("hw.optional.arm.FEAT_DIT"));
  m.timebase_numer = timer::timebase_numer();
  m.timebase_denom = timer::timebase_denom();
  m.ns_per_tick = timer::ns_per_tick();
  m.tick_hz = timer::tick_hz();
  const std::string batt = command_line_matching("/usr/bin/pmset -g batt 2>/dev/null", "Now drawing from");
  m.power_source = batt.empty() ? "unknown" : batt.substr(batt.find('\'') + 1, batt.rfind('\'') - batt.find('\'') - 1);
  const std::string lpm = command_line_matching("/usr/bin/pmset -g 2>/dev/null", "lowpowermode");
  m.low_power_mode = lpm.empty() ? "unknown" : (lpm.back() == '1' ? "on" : "off");
  char ts[32];
  const std::time_t now = std::time(nullptr);
  std::strftime(ts, sizeof ts, "%Y-%m-%dT%H:%M:%S%z", std::localtime(&now));
  m.timestamp = ts;
  return m;
}

std::string metadata_json(const Metadata& m) {
  return Json()
      .str("cpu", m.cpu).str("model", m.model).str("os", m.os_version)
      .integer("p_cores", m.p_cores).integer("e_cores", m.e_cores)
      .integer("l1d_bytes_pcore", m.l1d_bytes).integer("l2_bytes_pcluster", m.l2_bytes)
      .integer("cacheline_bytes", m.cacheline)
      .integer("feat_aes", m.feat_aes).integer("feat_dit", m.feat_dit)
      .str("compiler", m.compiler).str("opt_flags", m.opt_flags).str("cpu_flags", m.cpu_flags)
      .str("git_commit", m.git_hash)
      .str("openssl_version", m.openssl_version).str("openssl_armcap", m.openssl_armcap_env)
      .integer("timebase_numer", m.timebase_numer).integer("timebase_denom", m.timebase_denom)
      .num("ns_per_tick", m.ns_per_tick).num("timer_hz", m.tick_hz)
      .str("power_source", m.power_source).str("low_power_mode", m.low_power_mode)
      .str("timestamp", m.timestamp)
      .done();
}

} // namespace aes
