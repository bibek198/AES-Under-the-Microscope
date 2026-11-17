# AES Under the Microscope

**An experimental study of timing side-channel leakage in AES-128 on Apple M4.**

Five AES-128 implementations produce identical ciphertext. This project
measures whether their *running time* depends on the data, using the
fixed-vs-random Welch t-test (TVLA / dudect) with positive and negative
controls, and checks every conclusion against the generated assembly.

| Implementation | Strategy | Latency | Leakage, evicted cache (\|t\|, 10⁶ samples) |
|---|---|---|---|
| `ref` | textbook FIPS-197, 256 B S-box table | 169 ns | 0.06 |
| `ttable` | 4 × 1 KB T-tables | 36 ns | **18.8: leak detected** |
| `ct` | constant-time, S-box computed as affine(a²⁵⁴) | 2,559 ns | 1.05 |
| `armv8` | ARMv8 `AESE`/`AESMC` instructions | 7.2 ns | 1.10 |
| `openssl` | OpenSSL 3.6.1 EVP (hardware path) | 8.0 ns | 1.79 |

Controls: the injected secret-dependent branch gives \|t\| = 655 and the A/A
negative control gives \|t\| = 1.02. Full results are in
[results/full-20261117-0301/summary.md](results/full-20261117-0301/summary.md)
and the write-up is in [report/report.md](report/report.md).

> ⚠️ `ref` and `ttable` are **educational and not suitable for protecting
> real secrets**. The positive control is an **intentionally injected**
> vulnerability; it is not a weakness of AES. ECB mode is used only as a
> single-block measurement interface. The project makes no key-recovery
> claims against AES.

---

## Requirements

- macOS on Apple Silicon (developed on an M4, macOS 26.4.1)
- Apple Clang (Xcode command-line tools), CMake ≥ 3.20
- OpenSSL 3: `brew install openssl@3` (macOS ships LibreSSL without OpenSSL headers)
- Python 3.10+ for the analysis (`scripts/analyze.sh` creates `.venv` automatically)

## Quick start

```bash
scripts/build.sh                 # Release build: -O2 -mcpu=apple-m4
scripts/test.sh                  # correctness suite + ASan/UBSan pass
scripts/e2e.sh                   # end-to-end test of every module (CLI, pipeline, server, dashboard)
build/aes_project test           # FIPS-197 / SP 800-38A self-test
build/aes_project info           # platform, 24 MHz timer, OpenSSL path
scripts/demo.sh                  # interactive dashboard at http://127.0.0.1:8765
```

## Reproduce the experiments

```bash
scripts/collect.sh               # ~6 minutes: E1–E5, -O0 build, OPENSSL_armcap=0, assembly, analysis
scripts/collect.sh --quick       # ~1 minute, 10⁵ samples per test
```

Run on AC power with other apps closed, and leave the Mac alone while it
runs. Each run writes `results/<run_id>/`:

| File | Contents |
|---|---|
| `metadata.json` | CPU, caches, OS, compiler flags, OpenSSL path, timer, power state, git commit |
| `bench.jsonl` | latency and throughput |
| `samples_*.csv` | raw ticks per sample (gitignored; large) |
| `summary.md` / `summary.csv` / `summary.json` | all statistics and the H0–H4 verdicts |
| `figures/` | F1–F5 (PNG + SVG) |
| `dashboard.json` | replay data for the demo |

## Command-line interface

```
aes_project test | info
aes_project bench    [--impl X|all] [--quick]
aes_project leakage  [--impl X|all] [--cond hot|evicted|both] [--n N]
aes_project controls [--n N]
aes_project race     [--cond hot|evicted] [--n N]      # interleaved, for the dashboard
aes_project trace    --pt HEX --key HEX                 # every intermediate state
aes_project profile  --impl X --cond C [--n N]
aes_project recover  --target leaky|ct --key-byte XX    # toy recovery, injected branch only
aes_project all      [--quick] [--out DIR]
Global: --json (NDJSON) · --stream · --seed S · --batch B · --no-color
```

## Repository layout

```
include/, src/     AES implementations, measurement harness, CLI
tests/             known-answer, differential and control tests (ctest); e2e/ end-to-end suite
analysis/          statistics (Welch, crops, Mann–Whitney, KS, Holm) and figures
assembly/          generated listings + annotated inspection (README.md)
results/           recorded runs (summaries, figures, replay data)
report/            report.md and lab_notebook.md (dated record, including dead ends)
presentation/      slides.md (Marp), speaker_notes.md, dashboard screenshots
demo/              offline dashboard: stdlib Python server, vanilla JS, Liquid Glass UI, Chart.js vendored
scripts/           build, test, e2e, collect, analyze, asm, demo
```

## Method in one paragraph

Each sample times B back-to-back encryptions of one input, using
`mach_absolute_time()` (41.67 ns ticks; not a cycle counter). A coin flip
chooses a fixed (all-zero) or fresh random plaintext. Both classes are
prepared identically and interleaved randomly. Tests run with a hot cache
and with a 4 MB eviction before every encryption (B = 1). The primary
statistic, fixed before data collection, is Welch's t on all samples with
threshold |t| > 4.5. Cropped t, rank tests, effect sizes, Holm-adjusted
p-values and the minimum detectable difference are reported alongside it.

## Limitations

- 24 MHz timer: samples are batched, so single-encryption tests are quantised and weak at bounding non-detection.
- No core pinning on macOS (QoS hint only). One machine, one OS build, one compiler.
- In-process attacker model with full cache eviction. No cross-process or remote attack.
- In the hot-cache, long-batch regime, branch-free code with a data-dependent load was flagged (|t| ≈ 4.5–14). The mechanism is unexplained ([lab notebook](report/lab_notebook.md)), so hot-cache detections of table-based code are treated as inconclusive.
- Statistical detection is not exploitability; non-detection is not a proof of constant time.
- Live dashboard runs are illustrative (the browser competes for the CPU). Reported numbers come from recorded runs.

## Third-party code

`demo/web/vendor/chart.umd.min.js`: Chart.js v4.4.7, MIT licence.
