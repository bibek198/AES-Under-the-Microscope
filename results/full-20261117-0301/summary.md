# Results summary: run `latest`

Apple M4 · macOS 26.4.1 · Apple LLVM 21.0.0 (clang-2100.0.123.102) · `-O2 -mcpu=apple-m4` · timer 41.667 ns/tick · power: AC Power · commit f12904b

Primary statistic: Welch's t on all samples, |t| > 4.5 ⇒ leakage detected. Cropped |t| (dudect-style, samples below the 50th/90th/99th pooled percentile) is secondary.

## Hypothesis scorecard

| ID | Hypothesis | Verdict | Evidence |
|---|---|---|---|
| H0 | Negative control (A/A) stays below \|t\| = 4.5 | ✔ supported | \|t\| = 1.02 at n = 1,000,000 |
| H1 | Positive control (injected branch) is detected | ✔ supported | \|t\| = 655.0; fixed 30.34 ns vs random 16.57 ns |
| H2 | T-table AES leaks under cache eviction | ✔ supported | evicted \|t\| = 18.79 (max cropped \|t\| = 71.81), mean diff +3.13 ns; hot \|t\| = 0.48 (hot-cache results are confounded, see notebook) |
| H3 | Constant-time software AES and ARMv8 AES show no detectable leakage | ✔ supported | largest \|t\| = 1.10 (armv8, evicted); smallest detectable difference ranged 0.006–227.5 ns/encryption across runs |
| H4 | OpenSSL behaviour depends on the selected code path | ✔ supported | latency 8.01 ns (default) vs 36.05 ns (OPENSSL_armcap=0), ×4.5 |

## Performance (E2)

| impl | latency ns/block (median) | sd | MB/s 4 KB | MB/s 1 MB |
|---|---|---|---|---|
| ref | 168.78 | 2.90 | 109.0 | 111.0 |
| ttable | 35.58 | 0.29 | 574.2 | 573.4 |
| ct | 2558.79 | 26.94 | 6.3 | 6.4 |
| armv8 | 7.24 | 0.26 | 20651.7 | 24190.5 |
| openssl | 8.01 | 0.07 | 19458.2 | 23129.1 |
| openssl_armcap0 | 36.05 | 0.48 | 554.7 | 559.1 |

## Leakage tests (E3–E5)

| experiment | cache | n | B | \|t\| | max cropped \|t\| | fixed mean ns | random mean ns | diff ns | Cohen's d | Holm p | min detectable ns | verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| pos_leaky | hot | 1,000,000 | 94 | 654.98 | 1012.66 | 30.341 | 16.575 | +13.767 | +1.3100 | < 1e-300 | 0.095 | **LEAK DETECTED** |
| pos_leaky@O0 | hot | 1,000,000 | 15 | 417.21 | 924.20 | 186.404 | 146.230 | +40.174 | +0.8344 | < 1e-300 | 0.433 | **LEAK DETECTED** |
| pos_twin | hot | 1,000,000 | 93 | 4.53 | 101.09 | 31.122 | 31.467 | -0.345 | -0.0091 | 8.99e-05 | 0.343 | **LEAK DETECTED** |
| pos_twin@O0 | hot | 1,000,000 | 14 | 1.38 | 2.24 | 188.480 | 188.737 | -0.258 | -0.0028 | 1.00e+00 | 0.842 | no evidence |
| aa_control | hot | 1,000,000 | 94 | 1.02 | 1.77 | 16.562 | 16.533 | +0.029 | +0.0020 | 1.00e+00 | 0.128 | no evidence |
| aa_control@O0 | hot | 1,000,000 | 15 | 0.72 | 1.37 | 145.470 | 145.405 | +0.065 | +0.0014 | 1.00e+00 | 0.410 | no evidence |
| ref | hot | 1,000,000 | 19 | 0.04 | 2.72 | 146.870 | 146.873 | -0.003 | -0.0001 | 1.00e+00 | 0.283 | no evidence |
| ref | evicted | 1,000,000 | 1 | 0.06 | 3.90 | 195.797 | 195.775 | +0.022 | +0.0001 | 1.00e+00 | 1.587 | no evidence |
| ttable | hot | 1,000,000 | 95 | 0.48 | 142.62 | 28.573 | 28.658 | -0.085 | -0.0010 | 1.00e+00 | 0.790 | no evidence |
| ttable | evicted | 1,000,000 | 1 | 18.79 | 71.81 | 84.100 | 80.966 | +3.134 | +0.0376 | 1.49e-77 | 0.751 | **LEAK DETECTED** |
| ttable@O0 | hot | 1,000,000 | 13 | 0.03 | 55.67 | 196.668 | 196.663 | +0.005 | +0.0001 | 1.00e+00 | 0.704 | no evidence |
| ct | hot | 1,000,000 | 1 | 0.85 | 0.68 | 2638.403 | 2640.258 | -1.856 | -0.0017 | 1.00e+00 | 9.822 | no evidence |
| ct | evicted | 1,000,000 | 1 | 1.05 | 0.97 | 2717.914 | 2664.968 | +52.946 | +0.0021 | 1.00e+00 | 227.532 | no evidence |
| armv8 | hot | 1,000,000 | 2286 | 0.55 | 1.02 | 1.229 | 1.228 | +0.001 | +0.0011 | 1.00e+00 | 0.006 | no evidence |
| armv8 | evicted | 1,000,000 | 1 | 1.10 | 0.33 | 36.204 | 41.717 | -5.513 | -0.0022 | 1.00e+00 | 22.632 | no evidence |
| openssl | hot | 1,000,000 | 409 | 1.19 | 1.32 | 6.967 | 6.982 | -0.015 | -0.0024 | 1.00e+00 | 0.056 | no evidence |
| openssl | evicted | 1,000,000 | 1 | 1.79 | 1.52 | 40.145 | 40.534 | -0.389 | -0.0036 | 9.63e-01 | 0.981 | no evidence |
| openssl_armcap0 | hot | 1,000,000 | 78 | 19.83 | 455.77 | 33.766 | 34.169 | -0.403 | -0.0397 | 2.94e-86 | 0.091 | **LEAK DETECTED** |
| openssl_armcap0 | evicted | 1,000,000 | 1 | 4.44 | 43.12 | 79.584 | 78.158 | +1.426 | +0.0089 | 1.29e-04 | 1.447 | no evidence |

## Robust checks

| experiment | cache | median diff ns [95% bootstrap CI] | robust effect | Mann–Whitney p | KS p |
|---|---|---|---|---|---|
| pos_leaky | hot | +26.152 [+2.660, +26.596] | +15.918 | < 1e-300 | < 1e-300 |
| pos_leaky@O0 | hot | +19.444 [+19.444, +32.431] | +0.497 | < 1e-300 | < 1e-300 |
| pos_twin | hot | -0.448 [-0.448, -0.448] | -0.674 | < 1e-300 | < 1e-300 |
| pos_twin@O0 | hot | +0.000 [+0.000, +0.000] | +0.000 | 1.25e-04 | 5.22e-03 |
| aa_control | hot | +23.493 [-23.493, +23.493] | +2.383 | 2.59e-01 | 5.15e-01 |
| aa_control@O0 | hot | +0.000 [-27.778, +30.556] | +0.000 | 7.47e-02 | 4.27e-01 |
| ref | hot | +2.193 [+0.000, +2.193] | +0.225 | 1.05e-02 | 3.00e-02 |
| ref | evicted | +0.000 [+0.000, +0.000] | +0.000 | 1.98e-04 | 1.63e-03 |
| ttable | hot | +0.000 [+0.000, +0.000] | +0.000 | < 1e-300 | < 1e-300 |
| ttable | evicted | +0.000 [+0.000, +0.000] | +0.000 | < 1e-300 | 1.41e-289 |
| ttable@O0 | hot | +0.000 [+0.000, +0.000] | +0.000 | < 1e-300 | < 1e-300 |
| ct | hot | +0.000 [+0.000, +0.000] | +0.000 | 4.94e-01 | 9.99e-01 |
| ct | evicted | +0.000 [+0.000, +0.000] | +0.000 | 5.16e-01 | 1.00e+00 |
| armv8 | hot | +0.000 [+0.000, +0.000] | +0.000 | 5.61e-01 | 9.96e-01 |
| armv8 | evicted | +0.000 [+0.000, +0.000] | +0.000 | 5.74e-01 | 1.00e+00 |
| openssl | hot | +0.000 [+0.000, +0.000] | +0.000 | 3.22e-01 | 3.85e-01 |
| openssl | evicted | +0.000 [+0.000, +0.000] | +0.000 | 9.49e-01 | 9.85e-01 |
| openssl_armcap0 | hot | -0.534 [-0.534, -0.534] | -1.349 | < 1e-300 | < 1e-300 |
| openssl_armcap0 | evicted | +0.000 [+0.000, +0.000] | +0.000 | < 1e-300 | 5.11e-200 |

Notes: timings are per encryption (sample ticks × ns/tick ÷ B). A detection says the two input classes have different timing distributions; it does not by itself identify the cause or show exploitability. Non-detection is bounded by the 'min detectable' column, not a proof of constant time.
