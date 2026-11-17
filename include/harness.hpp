// harness.hpp — fixed-vs-random leakage measurement (TVLA / dudect style).
//
// Protocol for each of N samples:
//   1. Flip a fair coin to pick the class: FIXED (always the same
//      plaintext) or RANDOM (a fresh random plaintext).
//   2. [evicted condition] Flush the L1 data cache by reading a large buffer.
//   3. Time B back-to-back encryptions of that input with the system counter.
// Classes are interleaved randomly so slow drifts (temperature, frequency,
// background tasks) affect both classes equally.
//
// If the implementation's running time does not depend on the data, the
// two classes have the same timing distribution and Welch's t statistic
// stays small. |t| > 4.5 is the conventional TVLA threshold for "leakage
// detected". A small |t| is NOT proof of constant-time behaviour.
#pragma once

#include <array>
#include <functional>
#include <string>
#include <vector>

#include "aes_common.hpp"

namespace aes {

// Experiment key: FIPS-197 Appendix C.1 key (public test key).
inline constexpr std::array<uint8_t, 16> kExperimentKey = {
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
// Fixed-class plaintext: all zeros. With it, the first-round S-box indices
// (p XOR k) equal the key bytes themselves, a distinctive, documented choice.
inline constexpr std::array<uint8_t, 16> kFixedPlaintext = {};

// Running mean/variance (Welford's algorithm): numerically stable, O(1) memory.
struct Welford {
  uint64_t n = 0;
  double mean = 0.0, m2 = 0.0;
  void add(double x) {
    ++n;
    const double d = x - mean;
    mean += d / static_cast<double>(n);
    m2 += d * (x - mean);
  }
  double var() const { return n > 1 ? m2 / static_cast<double>(n - 1) : 0.0; }
};

// Welch's t = (mean_a - mean_b) / sqrt(var_a/n_a + var_b/n_b).
double welch_t(const Welford& a, const Welford& b);

struct RunConfig {
  std::string impl;
  bool evict = false;        // flush the cache before every sample
  bool aa = false;           // negative control: both classes random
  uint64_t n = 1'000'000;    // number of samples
  int batch = 0;             // encryptions per sample (0 = calibrate automatically)
  uint64_t seed = 1;
  uint64_t stream_every = 0; // call progress() every k samples (0 = never)
};

struct LeakageResult {
  std::string impl, cond, mode;  // cond: hot|evicted ; mode: fixed_vs_random|random_vs_random
  int batch = 1;
  uint64_t n = 0;
  Welford fixed, random;           // all samples (ticks)
  Welford fixed_crop, random_crop; // samples below the p90 crop threshold
  double crop_threshold = 0;       // ticks (from the first 10,000 samples)
  double t = 0, t_crop = 0;
  double ns_per_tick = 0;
  double elapsed_s = 0;
};

using LeakageProgress = std::function<void(const LeakageResult&)>;

// A resumable fixed-vs-random experiment. step(k) collects k more samples,
// so several experiments can be interleaved (the dashboard's live "race").
class LeakageRun {
 public:
  explicit LeakageRun(const RunConfig& cfg, bool keep_samples = false);
  ~LeakageRun();
  LeakageRun(const LeakageRun&) = delete;
  LeakageRun& operator=(const LeakageRun&) = delete;

  void step(uint64_t k);
  const LeakageResult& result();  // statistics so far
  bool finished() const { return res_.n >= cfg_.n; }
  const std::vector<uint8_t>& classes() const { return classes_; }
  const std::vector<uint32_t>& ticks() const { return ticks_; }

 private:
  RunConfig cfg_;
  bool keep_;
  std::unique_ptr<Aes128> impl_;
  struct Rng;
  std::unique_ptr<Rng> rng_;
  LeakageResult res_;
  std::vector<uint32_t> warm_;
  std::vector<uint8_t> classes_;
  std::vector<uint32_t> ticks_;
  double elapsed_ = 0;
};

// Runs one fixed-vs-random (or A/A) experiment to completion. Optionally
// returns the raw class labels and tick counts for offline analysis.
LeakageResult run_leakage(const RunConfig& cfg, const LeakageProgress& progress = {},
                          std::vector<uint8_t>* classes = nullptr,
                          std::vector<uint32_t>* ticks = nullptr);

// Chooses B so that one sample lasts about target_ns.
int calibrate_batch(Aes128& impl, double target_ns = 2500.0);

// Evicts the L1 data cache (and much of L2) by streaming through a buffer
// far larger than L1 at cache-line stride.
void evict_cache();

// --- Per-byte timing profile (Bernstein-style) and toy key recovery -------

struct ProfileResult {
  std::array<Welford, 256> by_p0;  // timing grouped by plaintext byte 0
  uint64_t n = 0;
  int batch = 1;
};

using ProfileProgress = std::function<void(const ProfileResult&)>;

// Times encryptions with a random plaintext byte p0 (other bytes random),
// under `key`, and groups the timings by p0.
ProfileResult run_profile(Aes128& impl, const uint8_t key[16], bool evict, uint64_t n, int batch,
                          uint64_t seed, uint64_t stream_every = 0,
                          const ProfileProgress& progress = {});

struct GuessScores {
  std::array<double, 256> score{};  // correlation of the timing profile with each guess's model
  int best = 0;
};

// THE ATTACKER'S SIDE of the toy recovery. Uses only public information:
// the per-p0 mean timings and the public S-box. For each key-byte guess g
// it predicts which p0 values trigger the injected branch,
// L_g(p0) = [S(p0 XOR g) < 0x80], and scores g by the Pearson correlation
// between that prediction and the measured mean times.
GuessScores score_key_guesses(const ProfileResult& profile);

// Rank of `true_byte` among all guesses (1 = best).
int rank_of(const GuessScores& s, int true_byte);

} // namespace aes
