# Speaker notes (Beamer deck, `slides.pdf`, 23 slides)

Target: about 15 minutes. Slides 1–11 take about 6 minutes, the live demo
about 5 minutes, and slides 13–23 about 4 minutes. The older Marp deck is
kept as `slides-marp.*`.

---

### 1. Title (15 s)
"ChronoLeak, in two parts: a finished experimental study of AES timing, and the research plan it led to."

### 2. Same cipher, same output, different timing? (45 s)
- Attackers break implementations, not AES. Kocher 1996; Bernstein, Osvik/Shamir/Tromer for AES caches.
- The code that runs is what the compiler produced, on a CPU with its own predictors.
- Read the question box.

### 3. Two parts (30 s)
- Part I is done: five implementations, harness, dashboard. Part II is a plan, with no results claimed.

### 4. AES-128 in one picture (50 s)
- State, 11 round keys, 10 rounds, no MixColumns in the last one because it is linear.
- GF(2⁸): "Hold on to a²⁵⁴. Our constant-time version computes the S-box with it instead of a lookup."

### 5. Timing side channels and the test (50 s)
- A branch costs time only when taken; a table address depends on the secret and the cache remembers addresses.
- Fixed vs random, Welch t, 4.5. "It tells us *whether* timing depends on data, not how, and not exploitability."

### 6. Literature review (60 s)
- Walk the table top to bottom: classic attacks → the test → constant-time AES → Apple predictors → compiler work in C → tools → Rust.
- The highlighted rows (Breaking Bad, Fun with Flags) are why Part II exists: compilers break constant-time C, but nobody has measured Rust's own mechanisms.

### 7. Part I divider (5 s)

### 8. Five implementations (40 s)
- Leaky to hardware. Safety in software costs 2.5 µs versus 7 ns.
- "The positive control is ours, injected on purpose. It is not a flaw in AES."

### 9. What we built (40 s)
- One binary, 10 commands; refuses to measure until the self-test passes.
- Python recomputes every statistic independently. "The dashboard you'll see is driven live by that binary."

### 10. The dashboard (15 s)
- Point at the four views you're about to demo.

### 11. Methodology (45 s)
- 10⁶ samples, hot and evicted. Hypotheses written before collecting data.
- "Two controls make this science rather than a demo."

### 12. Live demo (5 min): follow `demo/CHECKLIST.md`

### 13. Results: leakage (60 s)
- F2: the positive control rises in a straight line, which is what a real leak looks like. The controls stay flat.
- "T-table is quiet in a hot loop, because 4 KB fits in a 128 KB cache. Flush the cache and it leaks: 3 ns out of 81."

### 14. Performance and compiler (30 s)
- Hardware AES is 353× faster than our safe software and quiet. The injected branch is detected at -O0 and -O2.

### 15. Under the hood (40 s)
- "The branch survives as `tbnz`; the constant-time S-box has zero branches and zero table lookups."
- OpenSSL caught with a debugger: hardware by default, portable C when detection is off.

### 16. Verdicts, unexpected result, limits (60 s)
- All five hypotheses supported.
- Be upfront: "Our branch-free control got flagged under one specific condition. We tested the obvious explanations and report it as unexplained. That's why our cache conclusions rest on the evicted runs."
- Detection ≠ exploitation; non-detection ≠ proof.

### 17. Part II divider (5 s)

### 18. From Part I to Part II (45 s)
- "Constant-time belongs to machine code. Compilers breaking it is known for C. Rust has its own mechanisms that nobody has measured."
- Name them: `subtle::Choice` and its barrier, the Choice → bool boundary, Rust build settings.

### 19. Research questions and design (50 s)
- RQ3, binary violation versus measurable leakage, is the centre.
- Two stages: screen many builds cheaply, measure the flagged ones plus a random unflagged sample to estimate what the screen misses.

### 20. Platforms, software, roadmap (30 s)
- Bare-metal Linux is the primary platform because the Mac has no cycle counter or core pinning (lesson from Part I).
- Decision gates with outcomes fixed in advance.

### 21. Conclusions (30 s)
- Read the two take-aways: use hardware AES, and verify it's selected; constant-time is a property of machine code on a CPU.

### 22. References and tools (10 s)
- Leave up during questions. Mention that ChatGPT was used, and how.

### 23. Thank you / questions

---

## Likely viva questions (short answers)

- **Why the threshold 4.5?** The TVLA convention, roughly p < 10⁻⁵ two-sided:
  strict enough for millions of samples and many tests.
- **Why is T-table quiet when the cache is hot?** All 4 KB of tables stay in
  the 128 KB L1D, so there are no misses whose timing depends on the index.
- **Why didn't `ref` leak?** Its 256-byte S-box is two 128-byte cache lines,
  which are almost always cached.
- **Why is hardware AES constant-time?** The S-box is inside the AES unit:
  there is no memory lookup and the instructions are designed with fixed latency.
- **What does DIT do?** It is the ARMv8.4 Data-Independent Timing bit. When set,
  specified instructions must take data-independent time. Apple recommends
  enabling it for cryptographic code.
- **How does the toy recovery work?** Group timings by plaintext byte p0;
  for each guess g, predict which p0 values trigger the branch,
  S(p0 ⊕ g) < 0x80; correlate prediction with measured time; best guess wins.
- **Why does it fail on `ct`?** Its time does not depend on S(p0 ⊕ k), so
  all 256 correlations are noise.
- **What does Welch's t *not* tell you?** Not how to exploit the leak, not
  which bits leak, not that a non-detected implementation is constant-time.
