// harness.cpp — measurement loops.
#include "harness.hpp"

#include <pthread.h>
#include <pthread/qos.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>
#include <random>
#include <stdexcept>

#include "compiler.hpp"
#include "timer.hpp"

namespace aes {

namespace {

// Ask macOS to run this thread on a performance core. macOS offers no hard
// CPU-affinity API; the QoS class is a strong hint, not a guarantee.
void prefer_performance_core() {
  static bool done = false;
  if (!done) {
    pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
    done = true;
  }
}

// 4 MB eviction buffer = 32x the M4 P-core L1D (128 KB).
constexpr size_t kEvictBytes = 4u << 20;
constexpr size_t kLine = 128;  // M4 cache line size (sysctl hw.cachelinesize)

uint8_t* evict_buffer() {
  static uint8_t* buf = [] {
    auto* b = new uint8_t[kEvictBytes];
    for (size_t i = 0; i < kEvictBytes; ++i) b[i] = static_cast<uint8_t>(i);
    return b;
  }();
  return buf;
}

void fill_random(std::mt19937_64& rng, uint8_t* p) {
  const uint64_t a = rng(), b = rng();
  std::memcpy(p, &a, 8);
  std::memcpy(p + 8, &b, 8);
}

inline uint64_t time_batch(const Aes128& impl, const uint8_t* in, uint8_t* out, int batch) {
  const uint64_t t0 = timer::now_ticks();
  for (int b = 0; b < batch; ++b) {
    impl.encrypt_block(in, out);
    clobber_memory();  // the result must be stored; the call cannot be skipped
  }
  return timer::now_ticks() - t0;
}

void warm_up(const Aes128& impl) {
  uint8_t in[16] = {}, out[16];
  for (int i = 0; i < 10000; ++i) {
    impl.encrypt_block(in, out);
    in[0] = out[0];
  }
  do_not_optimize(out);
}

} // namespace

double welch_t(const Welford& a, const Welford& b) {
  if (a.n < 2 || b.n < 2) return 0.0;
  const double se = std::sqrt(a.var() / static_cast<double>(a.n) + b.var() / static_cast<double>(b.n));
  if (se == 0.0) return 0.0;
  return (a.mean - b.mean) / se;
}

void evict_cache() {
  const uint8_t* buf = evict_buffer();
  uint64_t sum = 0;
  for (size_t i = 0; i < kEvictBytes; i += kLine) sum += buf[i];
  do_not_optimize(sum);
}

int calibrate_batch(Aes128& impl, double target_ns) {
  prefer_performance_core();
  uint8_t in[16] = {}, out[16];
  warm_up(impl);
  constexpr int kProbe = 4000;
  double best = 1e300;
  for (int rep = 0; rep < 5; ++rep) {
    const uint64_t t = time_batch(impl, in, out, kProbe);
    best = std::min(best, static_cast<double>(t) * timer::ns_per_tick() / kProbe);
  }
  const int b = static_cast<int>(std::ceil(target_ns / std::max(best, 0.05)));
  return std::clamp(b, 1, 8192);
}

struct LeakageRun::Rng {
  std::mt19937_64 gen;
};

LeakageRun::LeakageRun(const RunConfig& cfg, bool keep_samples) : cfg_(cfg), keep_(keep_samples) {
  prefer_performance_core();
  impl_ = make_impl(cfg.impl);
  if (!impl_) throw std::invalid_argument("unknown implementation: " + cfg.impl);
  impl_->set_key(kExperimentKey.data());
  rng_ = std::make_unique<Rng>(Rng{std::mt19937_64(cfg.seed)});
  res_.impl = cfg.impl;
  res_.cond = cfg.evict ? "evicted" : "hot";
  res_.mode = cfg.aa ? "random_vs_random" : "fixed_vs_random";
  res_.batch = cfg.batch > 0 ? cfg.batch : (cfg.evict ? 1 : calibrate_batch(*impl_));
  res_.ns_per_tick = timer::ns_per_tick();
  if (keep_) {
    classes_.reserve(cfg.n);
    ticks_.reserve(cfg.n);
  }
  warm_up(*impl_);
}

LeakageRun::~LeakageRun() = default;

void LeakageRun::step(uint64_t k) {
  constexpr uint64_t kCropWarm = 10000;  // samples used to fix the p90 crop threshold
  const Aes128& impl = *impl_;
  auto& rng = rng_->gen;
  LeakageResult& r = res_;
  alignas(16) uint8_t in[16], out[16], rnd[16];
  const uint64_t end = std::min(cfg_.n, r.n + k);
  const auto start = std::chrono::steady_clock::now();

  for (uint64_t i = r.n; i < end; ++i) {
    // Choose the class and the input OUTSIDE the timed region.
    // Both classes are prepared by exactly the same instructions: random
    // bytes are always generated, and the input buffer is always written by
    // one 16-byte copy from either the fixed or the random source, so the
    // two classes cannot differ in how their input reaches memory.
    const int cls = static_cast<int>(rng() & 1);  // 0 = fixed, 1 = random
    fill_random(rng, rnd);
    const uint8_t* src = (cls == 0 && !cfg_.aa) ? kFixedPlaintext.data() : rnd;
    std::memcpy(in, src, 16);
    clobber_memory();
    if (cfg_.evict) evict_cache();

    const uint64_t dt = time_batch(impl, in, out, r.batch);
    const double x = static_cast<double>(dt);
    (cls == 0 ? r.fixed : r.random).add(x);

    if (i < kCropWarm) {
      warm_.push_back(static_cast<uint32_t>(dt));
      if (i + 1 == kCropWarm) {
        std::vector<uint32_t> tmp = warm_;
        std::nth_element(tmp.begin(), tmp.begin() + tmp.size() * 9 / 10, tmp.end());
        r.crop_threshold = tmp[tmp.size() * 9 / 10];
      }
    } else if (x <= r.crop_threshold) {
      (cls == 0 ? r.fixed_crop : r.random_crop).add(x);
    }
    if (keep_) {
      classes_.push_back(static_cast<uint8_t>(cls));
      ticks_.push_back(static_cast<uint32_t>(std::min<uint64_t>(dt, UINT32_MAX)));
    }
  }
  do_not_optimize(out);
  r.n = end;
  elapsed_ += std::chrono::duration<double>(std::chrono::steady_clock::now() - start).count();
}

const LeakageResult& LeakageRun::result() {
  res_.t = welch_t(res_.fixed, res_.random);
  res_.t_crop = welch_t(res_.fixed_crop, res_.random_crop);
  res_.elapsed_s = elapsed_;
  return res_;
}

LeakageResult run_leakage(const RunConfig& cfg, const LeakageProgress& progress,
                          std::vector<uint8_t>* classes, std::vector<uint32_t>* ticks) {
  LeakageRun run(cfg, classes || ticks);
  const uint64_t chunk = cfg.stream_every ? cfg.stream_every : cfg.n;
  while (!run.finished()) {
    run.step(chunk);
    if (cfg.stream_every && progress) progress(run.result());
  }
  if (classes) *classes = run.classes();
  if (ticks) *ticks = run.ticks();
  return run.result();
}

ProfileResult run_profile(Aes128& impl, const uint8_t key[16], bool evict, uint64_t n, int batch,
                          uint64_t seed, uint64_t stream_every, const ProfileProgress& progress) {
  prefer_performance_core();
  impl.set_key(key);
  ProfileResult p;
  p.batch = batch > 0 ? batch : (evict ? 1 : calibrate_batch(impl));
  warm_up(impl);
  std::mt19937_64 rng(seed);
  uint8_t in[16], out[16];
  for (uint64_t i = 0; i < n; ++i) {
    fill_random(rng, in);  // in[0] = p0 is uniformly random
    if (evict) evict_cache();
    const uint64_t dt = time_batch(impl, in, out, p.batch);
    p.by_p0[in[0]].add(static_cast<double>(dt));
    if (stream_every && progress && (i + 1) % stream_every == 0) {
      p.n = i + 1;
      progress(p);
    }
  }
  do_not_optimize(out);
  p.n = n;
  return p;
}

GuessScores score_key_guesses(const ProfileResult& profile) {
  // Measured profile: mean time for each p0 (skip empty bins).
  std::array<double, 256> m{};
  std::array<bool, 256> have{};
  for (int p = 0; p < 256; ++p) {
    have[p] = profile.by_p0[p].n > 0;
    m[p] = profile.by_p0[p].mean;
  }
  GuessScores out;
  double best = -2.0;
  for (int g = 0; g < 256; ++g) {
    // Pearson correlation between m[p] and the 0/1 prediction L_g(p).
    double sx = 0, sy = 0, sxx = 0, syy = 0, sxy = 0, k = 0;
    for (int p = 0; p < 256; ++p) {
      if (!have[p]) continue;
      const double x = m[p];
      const double y = SBOX[p ^ g] < 0x80 ? 1.0 : 0.0;
      sx += x; sy += y; sxx += x * x; syy += y * y; sxy += x * y; k += 1;
    }
    double c = 0.0;
    const double vx = sxx - sx * sx / k, vy = syy - sy * sy / k;
    if (k > 2 && vx > 0 && vy > 0) c = (sxy - sx * sy / k) / std::sqrt(vx * vy);
    out.score[g] = c;
    if (c > best) {
      best = c;
      out.best = g;
    }
  }
  return out;
}

int rank_of(const GuessScores& s, int true_byte) {
  int rank = 1;
  for (int g = 0; g < 256; ++g)
    if (g != true_byte && s.score[g] > s.score[true_byte]) ++rank;
  return rank;
}

} // namespace aes
