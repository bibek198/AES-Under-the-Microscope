// main.cpp — command-line interface for AES Under the Microscope.
//
//   aes_project test | info | bench | leakage | controls | race |
//               trace | profile | recover | all      (see usage())
//
// Human-readable coloured output by default; --json switches every command
// to NDJSON (one JSON object per line) for the demo dashboard.
#include <unistd.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <optional>
#include <random>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

#include "aes_common.hpp"
#include "bench.hpp"
#include "controls.hpp"
#include "harness.hpp"
#include "json_out.hpp"
#include "metadata.hpp"
#include "selftest.hpp"
#include "timer.hpp"
#include "trace.hpp"

namespace fs = std::filesystem;
using namespace aes;

namespace {

constexpr double kThreshold = 4.5;  // TVLA |t| threshold

// --------------------------------------------------------------------------
// Options
// --------------------------------------------------------------------------
struct Options {
  std::string command;
  std::vector<std::string> impls;
  std::string cond = "both";
  std::optional<uint64_t> n;
  int batch = 0;
  uint64_t seed = 1;
  bool quick = false, json = false, stream = false, color = true;
  uint64_t stream_every = 5000;
  std::string out_dir;
  std::string pt_hex, key_hex, target = "leaky";
  int key_byte = -1;
};

bool g_color = true;
const char* c(const char* code) { return g_color ? code : ""; }
#define RESET c("\033[0m")
#define BOLD c("\033[1m")
#define DIM c("\033[2m")
#define GREEN c("\033[32m")
#define RED c("\033[31m")
#define YELLOW c("\033[33m")
#define BLUE c("\033[34m")
#define CYAN c("\033[36m")
#define ORANGE c("\033[38;5;208m")

void usage() {
  std::printf(
      "AES Under the Microscope: timing side-channel experiments on AES-128\n\n"
      "Usage: aes_project <command> [options]\n\n"
      "Commands:\n"
      "  test                         correctness self-test (FIPS-197, SP 800-38A, cross-check)\n"
      "  info                         platform, timer and OpenSSL information\n"
      "  bench    [--impl X|all] [--quick]\n"
      "  leakage  [--impl X|all] [--cond hot|evicted|both] [--n N] [--quick]\n"
      "  controls [--n N]             positive control, branch-free twin, A/A negative control\n"
      "  race     [--impl list] [--cond hot|evicted] [--n N]   interleaved live comparison\n"
      "  trace    --pt HEX --key HEX  every intermediate AES state\n"
      "  profile  --impl X [--cond hot|evicted] [--n N]   mean time per plaintext byte value\n"
      "  recover  --target leaky|ct --key-byte XX [--n N] toy recovery (INJECTED branch only)\n"
      "  all      [--quick] [--out DIR]   full experiment pipeline -> results/<run_id>/\n\n"
      "Options:\n"
      "  --impl a,b,c   implementations: ref ttable ct armv8 openssl pos_leaky pos_twin | all\n"
      "  --json         NDJSON output (for the dashboard)\n"
      "  --stream       emit progress records every --every samples (default 5000)\n"
      "  --seed S       RNG seed (default 1)\n"
      "  --batch B      encryptions per sample (default: calibrated)\n"
      "  --out DIR      write raw samples and summaries to DIR\n"
      "  --no-color     plain output\n");
}

std::vector<std::string> split(const std::string& s, char sep) {
  std::vector<std::string> out;
  std::stringstream ss(s);
  std::string item;
  while (std::getline(ss, item, sep))
    if (!item.empty()) out.push_back(item);
  return out;
}

bool parse(int argc, char** argv, Options& o, std::string& err) {
  if (argc < 2) return false;
  o.command = argv[1];
  for (int i = 2; i < argc; ++i) {
    std::string a = argv[i];
    auto need = [&](const char* what) -> const char* {
      if (i + 1 >= argc) {
        err = std::string("missing value for ") + what;
        return nullptr;
      }
      return argv[++i];
    };
    try {
      if (a == "--impl" || a == "--impls") {
        const char* v = need("--impl"); if (!v) return false;
        if (std::string(v) == "all") o.impls = impl_names();
        else o.impls = split(v, ',');
      } else if (a == "--cond") { const char* v = need("--cond"); if (!v) return false; o.cond = v; }
      else if (a == "--n") { const char* v = need("--n"); if (!v) return false; o.n = std::stoull(v); }
      else if (a == "--batch") { const char* v = need("--batch"); if (!v) return false; o.batch = std::stoi(v); }
      else if (a == "--seed") { const char* v = need("--seed"); if (!v) return false; o.seed = std::stoull(v); }
      else if (a == "--every") { const char* v = need("--every"); if (!v) return false; o.stream_every = std::max<uint64_t>(100, std::stoull(v)); }
      else if (a == "--out") { const char* v = need("--out"); if (!v) return false; o.out_dir = v; }
      else if (a == "--pt") { const char* v = need("--pt"); if (!v) return false; o.pt_hex = v; }
      else if (a == "--key") { const char* v = need("--key"); if (!v) return false; o.key_hex = v; }
      else if (a == "--target") { const char* v = need("--target"); if (!v) return false; o.target = v; }
      else if (a == "--key-byte") {
        const char* v = need("--key-byte"); if (!v) return false;
        o.key_byte = static_cast<int>(std::stoul(v, nullptr, 16));
        if (o.key_byte < 0 || o.key_byte > 255) { err = "--key-byte must be 00..ff"; return false; }
      }
      else if (a == "--quick") o.quick = true;
      else if (a == "--json") o.json = true;
      else if (a == "--stream") o.stream = true;
      else if (a == "--no-color") o.color = false;
      else { err = "unknown option: " + a; return false; }
    } catch (const std::exception&) {
      err = "invalid value for " + a;
      return false;
    }
  }
  for (const auto& name : o.impls)
    if (name != "aa_control" && !make_impl(name)) { err = "unknown implementation: " + name; return false; }
  return true;
}

void emit(const std::string& json_line) {
  std::fputs(json_line.c_str(), stdout);
  std::fputc('\n', stdout);
  std::fflush(stdout);
}

std::string verdict(double t) { return std::fabs(t) > kThreshold ? "LEAK DETECTED" : "no evidence"; }

std::string make_run_id() {
  char buf[32];
  const std::time_t now = std::time(nullptr);
  std::strftime(buf, sizeof buf, "%Y%m%d-%H%M%S", std::localtime(&now));
  return buf;
}

// --------------------------------------------------------------------------
// Record builders (shared by --json output and the results directory)
// --------------------------------------------------------------------------
std::string leakage_json(const LeakageResult& r, const char* type, const std::string& label) {
  const double npt = r.ns_per_tick / r.batch;  // ticks per sample -> ns per encryption
  return Json()
      .str("type", type).str("label", label).str("impl", r.impl).str("cond", r.cond).str("mode", r.mode)
      .integer("n", static_cast<int64_t>(r.n)).integer("batch", r.batch)
      .num("t", r.t).num("t_crop", r.t_crop)
      .integer("n_fixed", static_cast<int64_t>(r.fixed.n)).integer("n_random", static_cast<int64_t>(r.random.n))
      .num("mean_fixed_ns", r.fixed.mean * npt).num("mean_random_ns", r.random.mean * npt)
      .num("sd_fixed_ns", std::sqrt(r.fixed.var()) * npt).num("sd_random_ns", std::sqrt(r.random.var()) * npt)
      .num("crop_threshold_ticks", r.crop_threshold)
      .num("elapsed_s", r.elapsed_s)
      .boolean("leak", std::fabs(r.t) > kThreshold)
      .done();
}

std::string bench_json(const BenchResult& b) {
  return Json()
      .str("type", "bench").str("impl", b.impl)
      .num("latency_ns_median", b.latency_median).num("latency_ns_mean", b.latency_mean)
      .num("latency_ns_sd", b.latency_sd).nums("latency_ns_reps", b.latency_ns)
      .num("throughput_4k_MBps", b.tp_4k_mbps).num("throughput_1m_MBps", b.tp_1m_mbps)
      .done();
}

std::string profile_json(const ProfileResult& p, const std::string& impl, const std::string& cond,
                         double ns_per_tick) {
  std::vector<double> mean_ns(256);
  std::vector<int64_t> counts(256);
  for (int i = 0; i < 256; ++i) {
    mean_ns[i] = p.by_p0[i].n ? p.by_p0[i].mean * ns_per_tick / p.batch : NAN;
    counts[i] = static_cast<int64_t>(p.by_p0[i].n);
  }
  return Json()
      .str("type", "profile").str("impl", impl).str("cond", cond)
      .integer("n", static_cast<int64_t>(p.n)).integer("batch", p.batch)
      .nums("mean_ns_by_p0", mean_ns).ints("count_by_p0", counts)
      .done();
}

std::string recover_json(const GuessScores& s, const ProfileResult& p, const std::string& target,
                         int true_byte, bool final) {
  std::vector<double> scores(s.score.begin(), s.score.end());
  return Json()
      .str("type", final ? "recover_result" : "recover").str("target", target)
      .integer("n", static_cast<int64_t>(p.n)).integer("batch", p.batch)
      .integer("best_guess", s.best).integer("true_rank", rank_of(s, true_byte))
      .integer("true_byte", true_byte)
      .num("best_score", s.score[s.best])
      .nums("scores", scores)
      .done();
}

// Every output directory records the platform and build it came from.
void write_metadata(const fs::path& dir, const std::string& command, const Options& o) {
  std::ofstream(dir / "metadata.json")
      << Json().raw("platform", metadata_json(collect_metadata())).str("command", command)
             .boolean("quick", o.quick).integer("seed", static_cast<int64_t>(o.seed)).done() << '\n';
}

void write_samples_csv(const fs::path& path, const std::vector<uint8_t>& classes,
                       const std::vector<uint32_t>& ticks, int batch) {
  std::ofstream f(path);
  f << "sample_idx,class,ticks,B\n";
  for (size_t i = 0; i < ticks.size(); ++i)
    f << i << ',' << (classes[i] == 0 ? "fixed" : "random") << ',' << ticks[i] << ',' << batch << '\n';
}

// --------------------------------------------------------------------------
// Pretty printers
// --------------------------------------------------------------------------
void print_leakage_line(const LeakageResult& r, const std::string& label) {
  const bool leak = std::fabs(r.t) > kThreshold;
  const double npt = r.ns_per_tick / r.batch;
  char crop[16];  // the crop threshold is only fixed after the first 10,000 samples
  if (r.crop_threshold > 0) std::snprintf(crop, sizeof crop, "%6.2f", std::fabs(r.t_crop));
  else std::snprintf(crop, sizeof crop, "%6s", "n/a");
  std::printf("  %-12s %-8s n=%-9llu B=%-5d |t|=%s%8.2f%s  (crop %s)  fixed %8.2f ns  random %8.2f ns  %s%s %s%s\n",
              label.c_str(), r.cond.c_str(), static_cast<unsigned long long>(r.n), r.batch,
              leak ? ORANGE : BLUE, std::fabs(r.t), RESET, crop,
              r.fixed.mean * npt, r.random.mean * npt,
              leak ? ORANGE : BLUE, leak ? "✘" : "✔", verdict(r.t).c_str(), RESET);
}

void print_header(const char* title) {
  std::printf("\n%s%s%s\n", BOLD, title, RESET);
}

bool self_test_gate(const Options& o) {
  if (run_self_test()) return true;
  if (o.json)
    emit(Json().str("type", "error").str("message", "self-test failed: refusing to measure").done());
  else
    std::fprintf(stderr, "%sSelf-test FAILED: refusing to run timing experiments.%s Run `aes_project test`.\n",
                 RED, RESET);
  return false;
}

// --------------------------------------------------------------------------
// Commands
// --------------------------------------------------------------------------
int cmd_test(const Options& o) {
  std::vector<SelfTestLine> lines;
  const bool ok = run_self_test(&lines);
  if (o.json) {
    for (const auto& l : lines)
      emit(Json().str("type", "selftest").str("label", l.label).str("expected", l.expected)
               .str("got", l.got).boolean("ok", l.ok).done());
    emit(Json().str("type", "selftest_summary").boolean("ok", ok).integer("checks", static_cast<int64_t>(lines.size())).done());
    return ok ? 0 : 1;
  }
  print_header("Correctness self-test");
  const bool tty = isatty(STDOUT_FILENO) && g_color;
  // Headline: reveal the FIPS-197 C.1 ciphertext byte by byte.
  auto ref = make_impl("ref");
  std::vector<uint8_t> key, pt;
  from_hex("000102030405060708090a0b0c0d0e0f", key);
  from_hex("00112233445566778899aabbccddeeff", pt);
  uint8_t ct[16];
  ref->set_key(key.data());
  ref->encrypt_block(pt.data(), ct);
  std::printf("  FIPS-197 Appendix C.1\n");
  std::printf("  key        %s\n", to_hex(key.data(), 16).c_str());
  std::printf("  plaintext  %s\n", to_hex(pt.data(), 16).c_str());
  std::printf("  expected   69c4e0d86a7b0430d8cdb78070b4c55a\n");
  std::printf("  ours       %s", GREEN);
  const std::string hex = to_hex(ct, 16);
  for (size_t i = 0; i < hex.size(); i += 2) {
    std::printf("%s", hex.substr(i, 2).c_str());
    std::fflush(stdout);
    if (tty) std::this_thread::sleep_for(std::chrono::milliseconds(45));
  }
  std::printf("%s  %s\n\n", RESET, hex == "69c4e0d86a7b0430d8cdb78070b4c55a" ? "✔ match" : "✘ MISMATCH");

  for (const auto& l : lines)
    std::printf("  %s%s%s  %s\n", l.ok ? GREEN : RED, l.ok ? "✔" : "✘", RESET, l.label.c_str());
  std::printf("\n  %s%s%zu checks %s%s\n", BOLD, ok ? GREEN : RED, lines.size(), ok ? "passed" : "FAILED", RESET);
  return ok ? 0 : 1;
}

int cmd_info(const Options& o) {
  const Metadata m = collect_metadata();
  if (o.json) {
    emit(Json().str("type", "info").raw("metadata", metadata_json(m)).done());
    return 0;
  }
  print_header("Platform");
  std::printf("  CPU            %s (%s), %lld P-cores + %lld E-cores\n", m.cpu.c_str(), m.model.c_str(), m.p_cores, m.e_cores);
  std::printf("  OS             %s\n", m.os_version.c_str());
  std::printf("  Caches         L1D %lld KB per P-core, L2 %lld MB per P-cluster, %lld B lines\n",
              m.l1d_bytes / 1024, m.l2_bytes / (1024 * 1024), m.cacheline);
  std::printf("  ARM features   FEAT_AES=%d  FEAT_DIT=%d\n", m.feat_aes, m.feat_dit);
  print_header("Timer");
  std::printf("  mach_absolute_time: timebase %u/%u -> %.3f ns per tick (%.2f MHz)\n",
              m.timebase_numer, m.timebase_denom, m.ns_per_tick, m.tick_hz / 1e6);
  std::printf("  %sNot a cycle counter: samples time batches of B encryptions.%s\n", DIM, RESET);
  print_header("Build");
  std::printf("  Compiler       %s\n  Flags          %s %s\n  Commit         %s\n",
              m.compiler.c_str(), m.opt_flags.c_str(), m.cpu_flags.c_str(), m.git_hash.c_str());
  std::printf("  OpenSSL        %s, OPENSSL_armcap=%s\n", m.openssl_version.c_str(), m.openssl_armcap_env.c_str());
  print_header("Measurement conditions");
  std::printf("  Power          %s%s%s   Low Power Mode: %s\n",
              m.power_source == "AC Power" ? GREEN : YELLOW, m.power_source.c_str(), RESET, m.low_power_mode.c_str());
  return 0;
}

int cmd_bench(const Options& o, const fs::path* out_dir = nullptr) {
  if (!self_test_gate(o)) return 2;
  const auto impls = o.impls.empty() ? impl_names() : o.impls;
  if (!o.json) {
    print_header(o.quick ? "Performance (quick)" : "Performance");
    std::printf("  %-10s %14s %12s %16s %16s\n", "impl", "latency ns/blk", "sd", "MB/s (4 KB)", "MB/s (1 MB)");
  }
  std::ofstream f;
  if (out_dir) f.open(*out_dir / "bench.jsonl");
  for (const auto& name : impls) {
    auto impl = make_impl(name);
    const BenchResult b = run_bench(*impl, o.quick);
    const std::string j = bench_json(b);
    if (o.json) emit(j);
    else
      std::printf("  %-10s %14.2f %12.2f %16.1f %16.1f\n", name.c_str(), b.latency_median, b.latency_sd,
                  b.tp_4k_mbps, b.tp_1m_mbps);
    if (f) f << j << '\n';
  }
  return 0;
}

// Runs a list of leakage experiments sequentially; optionally saves samples.
struct LeakageJob {
  RunConfig cfg;
  std::string label;
};

int run_leakage_jobs(const Options& o, const std::vector<LeakageJob>& jobs, const fs::path* out_dir,
                     const char* title) {
  if (!o.json) {
    print_header(title);
    std::printf("  %sFixed-vs-random Welch t-test; |t| > %.1f = leakage detected (TVLA threshold).%s\n",
                DIM, kThreshold, RESET);
  }
  std::ofstream summary;
  if (out_dir) summary.open(*out_dir / "leakage.jsonl", std::ios::app);
  for (const auto& job : jobs) {
    RunConfig cfg = job.cfg;
    cfg.stream_every = o.stream ? o.stream_every : 0;
    std::vector<uint8_t> classes;
    std::vector<uint32_t> ticks;
    auto progress = [&](const LeakageResult& r) {
      if (o.json) emit(leakage_json(r, "tstat", job.label));
    };
    if (!o.json) {
      std::printf("  %s%-12s %-8s running %llu samples...%s\r", DIM, job.label.c_str(),
                  cfg.evict ? "evicted" : "hot", static_cast<unsigned long long>(cfg.n), RESET);
      std::fflush(stdout);
    }
    const LeakageResult r = run_leakage(cfg, progress, out_dir ? &classes : nullptr, out_dir ? &ticks : nullptr);
    const std::string j = leakage_json(r, "leakage", job.label);
    if (o.json) emit(j);
    else { std::printf("\033[2K"); print_leakage_line(r, job.label); }
    if (out_dir) {
      summary << j << '\n';
      write_samples_csv(*out_dir / ("samples_" + job.label + "_" + r.cond + ".csv"), classes, ticks, r.batch);
    }
  }
  return 0;
}

std::vector<bool> conditions(const std::string& cond) {
  if (cond == "hot") return {false};
  if (cond == "evicted") return {true};
  return {false, true};
}

int cmd_leakage(const Options& o, const fs::path* out_dir = nullptr) {
  if (!self_test_gate(o)) return 2;
  const auto impls = o.impls.empty() ? impl_names() : o.impls;
  const uint64_t n = o.n.value_or(o.quick ? 100'000 : 1'000'000);
  std::vector<LeakageJob> jobs;
  for (bool ev : conditions(o.cond))
    for (const auto& name : impls) {
      RunConfig cfg;
      cfg.impl = name;
      cfg.evict = ev;
      cfg.n = n;
      cfg.batch = o.batch;
      cfg.seed = o.seed;
      jobs.push_back({cfg, name});
    }
  return run_leakage_jobs(o, jobs, out_dir, "Leakage assessment (E4)");
}

int cmd_controls(const Options& o, const fs::path* out_dir = nullptr) {
  if (!self_test_gate(o)) return 2;
  const uint64_t n = o.n.value_or(o.quick ? 100'000 : 1'000'000);
  std::vector<LeakageJob> jobs;
  RunConfig base;
  base.n = n;
  base.batch = o.batch;
  base.seed = o.seed;
  RunConfig pos = base;  pos.impl = "pos_leaky";
  RunConfig twin = base; twin.impl = "pos_twin";
  RunConfig aa = base;   aa.impl = "pos_leaky"; aa.aa = true;
  jobs.push_back({pos, "pos_leaky"});
  jobs.push_back({twin, "pos_twin"});
  jobs.push_back({aa, "aa_control"});
  if (!o.json)
    std::printf("\n%sPOSITIVE CONTROL = an intentionally injected secret-dependent branch (educational).%s\n"
                "%sIt demonstrates that the harness can detect leakage; it is not a weakness of AES.%s\n",
                YELLOW, RESET, DIM, RESET);
  return run_leakage_jobs(o, jobs, out_dir, "Controls (E3)");
}

// Interleaved runs: every implementation advances by --every samples in turn,
// so all the |t| curves grow together (used by the live dashboard).
int cmd_race(const Options& o) {
  if (!self_test_gate(o)) return 2;
  std::vector<std::string> impls = o.impls.empty()
      ? std::vector<std::string>{"pos_leaky", "aa_control", "ttable", "ct", "armv8", "openssl"}
      : o.impls;
  const bool evict = o.cond == "evicted";
  const uint64_t n = o.n.value_or(o.quick ? 100'000 : 400'000);
  std::vector<std::unique_ptr<LeakageRun>> runs;
  for (const auto& name : impls) {
    RunConfig cfg;
    cfg.aa = name == "aa_control";
    cfg.impl = cfg.aa ? "pos_leaky" : name;
    cfg.evict = evict;
    cfg.n = n;
    cfg.batch = o.batch;
    cfg.seed = o.seed;
    runs.push_back(std::make_unique<LeakageRun>(cfg));
  }
  if (!o.json) {
    print_header(evict ? "Leakage race (evicted cache)" : "Leakage race (hot cache)");
  }
  bool any = true;
  while (any) {
    any = false;
    for (size_t i = 0; i < runs.size(); ++i) {
      if (runs[i]->finished()) continue;
      any = true;
      runs[i]->step(o.stream_every);
      const LeakageResult& r = runs[i]->result();
      if (o.json) emit(leakage_json(r, "tstat", impls[i]));
    }
    if (!o.json && any) {
      std::printf("\r  n=%-8llu", static_cast<unsigned long long>(runs[0]->result().n));
      for (size_t i = 0; i < runs.size(); ++i) {
        const double t = std::fabs(runs[i]->result().t);
        std::printf("  %s%s %.1f%s", t > kThreshold ? ORANGE : BLUE, impls[i].c_str(), t, RESET);
      }
      std::fflush(stdout);
    }
  }
  if (o.json) {
    for (size_t i = 0; i < runs.size(); ++i) emit(leakage_json(runs[i]->result(), "leakage", impls[i]));
    emit(Json().str("type", "done").done());
  } else {
    std::printf("\n\n");
    for (size_t i = 0; i < runs.size(); ++i) print_leakage_line(runs[i]->result(), impls[i]);
  }
  return 0;
}

int cmd_trace(const Options& o) {
  std::vector<uint8_t> pt, key;
  if (!from_hex(o.pt_hex, pt) || pt.size() != 16 || !from_hex(o.key_hex, key) || key.size() != 16) {
    std::fprintf(stderr, "trace: --pt and --key must each be 32 hex digits\n");
    return 1;
  }
  const Trace t = trace_encrypt(key.data(), pt.data());
  if (o.json) {
    std::string steps = "[";
    for (size_t i = 0; i < t.steps.size(); ++i) {
      if (i) steps += ",";
      steps += Json().integer("round", t.steps[i].round).str("step", t.steps[i].step)
                   .str("state", to_hex(t.steps[i].state.data(), 16)).done();
    }
    steps += "]";
    std::string rks = "[";
    for (int r = 0; r <= kRounds; ++r) rks += (r ? ",\"" : "\"") + to_hex(t.round_keys.data() + 16 * r, 16) + "\"";
    rks += "]";
    emit(Json().str("type", "trace").str("key", to_hex(key.data(), 16)).str("plaintext", to_hex(pt.data(), 16))
             .str("ciphertext", to_hex(t.ciphertext.data(), 16)).raw("round_keys", rks).raw("steps", steps).done());
    return 0;
  }
  print_header("AES-128 trace (column-major state, shown as 4x4)");
  for (const auto& s : t.steps) {
    std::printf("  round %2d  %-12s %s\n", s.round, s.step.c_str(), to_hex(s.state.data(), 16).c_str());
  }
  std::printf("  ciphertext             %s%s%s\n", GREEN, to_hex(t.ciphertext.data(), 16).c_str(), RESET);
  return 0;
}

int cmd_profile(const Options& o, const fs::path* out_dir = nullptr) {
  if (!self_test_gate(o)) return 2;
  const std::string name = o.impls.empty() ? "ttable" : o.impls[0];
  const bool evict = o.cond == "evicted";
  const uint64_t n = o.n.value_or(o.quick ? 200'000 : 2'000'000);
  auto impl = make_impl(name);
  std::array<uint8_t, 16> key = kExperimentKey;
  if (o.key_byte >= 0) key[0] = static_cast<uint8_t>(o.key_byte);
  const ProfileResult p = run_profile(*impl, key.data(), evict, n, o.batch, o.seed);
  const std::string j = profile_json(p, name, evict ? "evicted" : "hot", timer::ns_per_tick());
  if (o.json) emit(j);
  else {
    print_header(("Timing profile by plaintext byte p0: " + name + (evict ? " (evicted)" : " (hot)")).c_str());
    double lo = 1e300, hi = 0;
    for (const auto& w : p.by_p0) if (w.n) { lo = std::min(lo, w.mean); hi = std::max(hi, w.mean); }
    const double npt = timer::ns_per_tick() / p.batch;
    std::printf("  n=%llu, B=%d, mean time per p0 ranges %.2f .. %.2f ns\n",
                static_cast<unsigned long long>(n), p.batch, lo * npt, hi * npt);
  }
  if (out_dir) {
    std::ofstream(*out_dir / ("profile_" + name + "_" + (evict ? "evicted" : "hot") + ".json")) << j << '\n';
  }
  return 0;
}

int cmd_recover(const Options& o, const fs::path* out_dir = nullptr) {
  if (!self_test_gate(o)) return 2;
  if (o.target != "leaky" && o.target != "ct") {
    std::fprintf(stderr, "recover: --target must be leaky or ct\n");
    return 1;
  }
  int secret = o.key_byte;
  if (secret < 0) secret = static_cast<int>(std::random_device{}() & 0xFF);
  const uint64_t n = o.n.value_or(o.target == "ct" ? 200'000 : 100'000);
  // The "victim": the injected leaky function, or the constant-time AES.
  auto victim = make_impl(o.target == "leaky" ? "pos_leaky" : "ct");
  std::array<uint8_t, 16> key = kExperimentKey;
  key[0] = static_cast<uint8_t>(secret);  // the secret byte the attacker wants

  if (!o.json) {
    print_header(("Toy key recovery against " + std::string(o.target == "leaky" ? "the INJECTED leaky branch" : "constant-time AES")).c_str());
    std::printf("  %sToy demonstration: the leak exists only because we injected it (positive control).%s\n", YELLOW, RESET);
  }
  std::vector<int64_t> rank_trace, n_trace;
  auto progress = [&](const ProfileResult& p) {
    const GuessScores s = score_key_guesses(p);  // attacker sees only timings + public S-box
    rank_trace.push_back(rank_of(s, secret));
    n_trace.push_back(static_cast<int64_t>(p.n));
    if (o.json) emit(recover_json(s, p, o.target, secret, false));
    else {
      std::printf("\r  n=%-8llu best guess 0x%02x  rank of true byte: %-4d", static_cast<unsigned long long>(p.n), s.best, rank_of(s, secret));
      std::fflush(stdout);
    }
  };
  const ProfileResult p = run_profile(*victim, key.data(), false, n, o.batch, o.seed,
                                      o.stream || !o.json ? std::max<uint64_t>(n / 40, 1000) : 0, progress);
  const GuessScores s = score_key_guesses(p);
  const std::string j = recover_json(s, p, o.target, secret, true);
  if (o.json) emit(j);
  else {
    const bool ok = s.best == secret;
    std::printf("\n  secret byte 0x%02x, best guess 0x%02x (score %.3f): %s%s%s\n", secret, s.best, s.score[s.best],
                ok ? (o.target == "leaky" ? ORANGE : YELLOW) : BLUE,
                ok ? "RECOVERED" : "not recovered (scores look like noise)", RESET);
  }
  if (out_dir) {
    std::ofstream f(*out_dir / ("recover_" + o.target + ".json"));
    f << Json().str("type", "recover_run").str("target", o.target).integer("true_byte", secret)
             .ints("n_trace", n_trace).ints("rank_trace", rank_trace).raw("final", j).done() << '\n';
  }
  return 0;
}

int cmd_all(Options o) {
  const fs::path dir = o.out_dir.empty() ? fs::path("results") / make_run_id() : fs::path(o.out_dir);
  fs::create_directories(dir);
  write_metadata(dir, "all", o);
  if (!o.json) {
    std::printf("%sAES Under the Microscope: full experiment run%s\n  output: %s\n", BOLD, RESET, dir.c_str());
    cmd_info(o);
  }
  std::vector<SelfTestLine> lines;
  const bool ok = run_self_test(&lines);
  {
    std::ofstream f(dir / "selftest.jsonl");
    for (const auto& l : lines)
      f << Json().str("label", l.label).str("expected", l.expected).str("got", l.got).boolean("ok", l.ok).done() << '\n';
  }
  if (!ok) {
    std::fprintf(stderr, "Self-test FAILED; aborting.\n");
    return 2;
  }
  if (!o.json) std::printf("\n%s✔ self-test passed (%zu checks)%s\n", GREEN, lines.size(), RESET);

  o.impls.clear();
  o.stream = false;
  cmd_bench(o, &dir);
  cmd_controls(o, &dir);
  o.cond = "both";
  cmd_leakage(o, &dir);

  // Per-byte profiles for the heatmap (E7) and toy recovery runs.
  Options p = o;
  p.n = o.quick ? 200'000 : 2'000'000;
  for (auto [impl, cond] : std::vector<std::pair<std::string, std::string>>{
           {"ttable", "evicted"}, {"ct", "evicted"}, {"ttable", "hot"}}) {
    p.impls = {impl};
    p.cond = cond;
    cmd_profile(p, &dir);
  }
  Options r = o;
  r.n.reset();
  r.key_byte = 0x3c;  // fixed, documented secret for the recorded run
  r.target = "leaky";
  cmd_recover(r, &dir);
  r.target = "ct";
  cmd_recover(r, &dir);

  if (!o.json) std::printf("\n%sDone.%s Results in %s\n  Next: scripts/analyze.sh %s\n", BOLD, RESET, dir.c_str(), dir.c_str());
  else emit(Json().str("type", "done").str("dir", dir.string()).done());
  return 0;
}

} // namespace

int main(int argc, char** argv) {
  Options o;
  std::string err;
  if (!parse(argc, argv, o, err)) {
    if (!err.empty()) std::fprintf(stderr, "error: %s\n\n", err.c_str());
    usage();
    return 1;
  }
  g_color = o.color && !o.json && isatty(STDOUT_FILENO);
  std::unique_ptr<fs::path> out;
  if (!o.out_dir.empty() && o.command != "all") {
    fs::create_directories(o.out_dir);
    out = std::make_unique<fs::path>(o.out_dir);
    write_metadata(*out, o.command, o);
  }
  try {
    const std::string& cmd = o.command;
    if (cmd == "test") return cmd_test(o);
    if (cmd == "info") return cmd_info(o);
    if (cmd == "bench") return cmd_bench(o, out.get());
    if (cmd == "leakage") return cmd_leakage(o, out.get());
    if (cmd == "controls") return cmd_controls(o, out.get());
    if (cmd == "race") return cmd_race(o);
    if (cmd == "trace") return cmd_trace(o);
    if (cmd == "profile") return cmd_profile(o, out.get());
    if (cmd == "recover") return cmd_recover(o, out.get());
    if (cmd == "all") return cmd_all(o);
    if (cmd == "help" || cmd == "--help" || cmd == "-h") { usage(); return 0; }
    std::fprintf(stderr, "error: unknown command '%s'\n\n", cmd.c_str());
    usage();
    return 1;
  } catch (const std::exception& e) {
    if (o.json) emit(Json().str("type", "error").str("message", e.what()).done());
    else std::fprintf(stderr, "error: %s\n", e.what());
    return 1;
  }
}
