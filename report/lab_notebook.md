# Lab notebook

Dated record of experiments and observations, including the ones that did
not go as expected. Numbers are copied from real program output on the
development machine (Apple M4, macOS 26.4.1, Apple Clang 21, `-O2 -mcpu=apple-m4`).

---

## 2026-11-17: Correctness gate

`ctest`: 3/3 suites pass.

- `test_vectors`: 63 checks. All 7 variants (5 implementations + 2 control
  variants) reproduce FIPS-197 C.1, FIPS-197 B, and SP 800-38A F.1.1 blocks 1–4.
  Appendix B intermediate states (round 1 after each step) and Appendix A.1
  round keys match. GF(2⁸): {57}·{83}={c1}, {57}·{13}={fe}, a·a⁻¹=1 for all
  a≠0. The computed S-box equals the table. The S-box has no fixed or
  opposite-fixed points.
- `test_differential`: 100,000 random (key, plaintext) pairs, all variants
  agree. The bulk `encrypt_blocks` path matches block-by-block encryption.
- `test_controls`: `leaky_gate(s) == twin_gate(s)` for all 256 s. The trace
  ciphertext equals every implementation's output (200 random cases).

## 2026-11-17: Timer

`mach_timebase_info` = 125/3 → **41.667 ns per tick (24.00 MHz)**, as
expected for Apple Silicon. Samples therefore time batches of B encryptions.

## 2026-11-17: First benchmark (`bench --quick`)

| impl | latency ns/block | MB/s (1 MB) |
|---|---|---|
| ref | 151.9 | 114 |
| ttable | 32.2 | 612 |
| ct | 2353 | 6.8 |
| armv8 | 7.18 | 24,889 |
| openssl | 7.60 | 23,919 |

OpenSSL's speed matches the hardware path. The constant-time software
version is about 73× slower than T-tables: the price of computing the S-box.

## 2026-11-17: Controls (N = 10⁵, hot)

| run | \|t\| | verdict |
|---|---|---|
| pos_leaky (injected branch) | 204.6 | leak detected (as designed) |
| aa_control (random vs random) | 0.54 | no evidence (as designed) |
| pos_twin (branch-free twin) | 11.8 | **flagged: unexpected** |

The harness detects a real leak and does not raise a false alarm on A/A.
The branch-free twin was **not** expected to be flagged.

### Investigating the twin (time-boxed)

The difference is small but consistent: fixed ≈ 28.1 ns vs random ≈ 28.4 ns
per operation (about 0.3 ns, roughly 1%).

1. **Assembly check.** `leaky_gate` compiles to `tbnz w0, #7` (a real
   secret-dependent branch). `twin_gate` is branch-free (`bic`/`neg`/`and`/`orr`).
   `control_workload` is a fixed 64-iteration `madd` loop. So the source-level
   intent survived compilation.
2. **Components in isolation** (micro-benchmark, s passed in a register):
   `twin_gate`, `control_workload`, and the `SBOX[s]` load each give \|t\| < 1.3,
   with DIT off and on. `leaky_gate` gives \|t\| = 154 (DIT off) and 293 (DIT on).
3. **Hypothesis: input-preparation artefact** (fixed input written with one
   16-byte copy, random input with two 8-byte stores, giving different
   store-to-load forwarding). The harness was changed so both classes are
   written identically. **Not supported:** the twin was still flagged
   (\|t\| = 8.4–12.1 over three seeds). The uniform preparation was kept
   anyway, because it removes a possible confound.
4. **Hypothesis: the specific fixed plaintext.** Fixed = zeros / 5a…5a /
   mixed bytes / a value with s ≥ 0x80 all give \|t\| ≈ 6.6–14 for the twin.
   **Not supported.** Over the same four inputs, `armv8` alone gives \|t\| ≤ 0.35.
5. **Batch-size dependence** (real binary, N = 2×10⁵):

   | B | pos_twin \|t\| | armv8 \|t\| |
   |---|---|---|
   | 1 | 0.09 | 0.66 |
   | 10 | 1.06 | 1.19 |
   | 94 | 14.26 | 0.21 |
   | 400 | 8.71 | 1.26 |

   The effect appears only with long batches of repeated identical input.
6. **Load-value / load-address prediction.** Recent work reports load value
   prediction (FLOP) and load address prediction (SLAP) on recent Apple cores.
   Micro-benchmarks separating a data-dependent *address* from a
   data-dependent *value* gave \|t\| < 2.1 in every case, with DIT off and on.
   **Not reproduced in isolation.** The full pipeline in a standalone program
   (direct calls, no virtual dispatch) gave only \|t\| ≈ 2.4 at B = 94.

**Status: unexplained.** It is a small, reproducible fixed-vs-random
difference (~0.3 ns/op) in branch-free code that performs a data-dependent
table load, seen only with long same-input batches. It is sensitive to code
structure, absent at B ≤ 10, and never seen in `armv8`.

**Consequences for the study:**

- In the hot, long-batch regime, the fixed-vs-random test on this platform
  can flag code that has no secret-dependent branch. A detection of about
  this size must not be read as cache leakage on its own.
- `ttable` (hot) gives \|t\| ≈ 9–13 with a ≈ 0.2 ns/op difference, which is
  the same order as the twin's artefact. The hot-cache T-table result is
  therefore treated as **inconclusive** about cache leakage. The evicted
  condition is the meaningful cache test.
- This is a concrete case of the spec's warning that statistical detection is
  not the same as a specific, explained leak.

## 2026-11-17: Toy key recovery

- Target = injected leaky branch, secret byte 0xa7: recovered at the first
  checkpoint (n = 2,500), correlation score 1.000.
- Target = `ct`: across 3 secrets × 2 seeds at n = 3×10⁵, the true byte's
  score has z between −1.05 and +0.33 relative to all 256 guesses, which is
  consistent with noise. (One early run showed the true byte ranked last for
  a stretch; repeated runs show this was chance.) **Not recovered.**

## 2026-11-17: OpenSSL code path (H4)

`bench --impl openssl --quick`: 8.69 ns/block, 24,128 MB/s (default) vs
35.04 ns/block, 581 MB/s with `OPENSSL_armcap=0`.

Debugger breakpoints on `aes_v8_encrypt`, `aes_v8_ecb_encrypt`,
`vpaes_encrypt`, and `AES_encrypt`:

- default → stops in `aes_v8_ecb_encrypt` (hardware instructions)
- `OPENSSL_armcap=0` → stops in `AES_encrypt` (portable C, not `vpaes`)

## 2026-11-17: Assembly checks

See `assembly/README.md`. Summary:

- `ref`: 32 secret-indexed `ldrb` loads. `ttable`: 32 secret-indexed `ldr` loads.
- `ct` `sbox8`: 917 instructions, 0 branches, 0 indexed loads.
- `armv8`: 60 `aese`, 54 `aesmc`.
- `leaky_gate` at `-O2` = `tbnz w0, #7` plus a tail call (the branch survives). At `-O0` = `subs` + `b.ge`.
