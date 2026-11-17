# Speaker notes

Target: about 13 minutes in total. Slides 1–6 take about 5 minutes, the live
demo about 5 minutes, and slides 8–11 about 3 minutes.

---

### 1. Title (20 s)

"AES has survived 25 years of cryptanalysis. But attackers rarely break the
maths; they break the implementation. Today: five implementations that
produce exactly the same ciphertext. Do they take the same time?"

### 2. AES-128 in one picture (40 s)

- State is 4×4 bytes, column-major.
- 10 rounds. Round 10 drops MixColumns because it is linear and could just be
  peeled off; it adds no security there.
- "Everything we measure later is validated against the official vectors.
  A side-channel study on broken crypto would be worthless."

### 3. GF(2⁸) (60 s)

- Irreducible polynomial means every non-zero byte has an inverse.
- The S-box is the only non-linear step: inverse, then affine map.
- "Hold on to a²⁵⁴. Our constant-time version computes the S-box with that
  formula instead of looking it up, and that's the defence."
- MixColumns: an MDS matrix, so one byte change spreads to a whole column.

### 4. Timing side channels (50 s)

- A branch costs time only when it is taken. A table lookup's address
  depends on the secret, and the cache remembers addresses.
- "Recent Apple-specific research shows the CPU's own predictors can leak
  even when the source code looks safe. That comes back later."

### 5. Five implementations (40 s)

- From the most leaky to hardware.
- Note the cost of safety in software: 2.5 µs versus 7 ns.
- All agree on 100,000 random inputs.

### 6. Methodology (60 s)

- Coin flip per sample; fixed vs random; Welch t; threshold 4.5.
- "Two controls make this science rather than a demo. The A/A control shows
  we don't raise false alarms. The injected branch shows we can detect a
  real leak. The injected branch is ours. It is not a flaw in AES."
- Hypotheses were written down before collecting data.

### 7. Live demo (5 min): see `demo/CHECKLIST.md` for the script

### 8. Results (60 s)

- Point at F2: the positive control rises in a straight line, which is what
  a real leak looks like. The controls stay flat.
- "T-table is quiet in a hot loop, because 4 KB fits easily in a 128 KB cache.
  Flush the cache and it leaks: 3 nanoseconds out of 81."
- OpenSSL is quiet by default. Its fallback is flagged, with an asterisk
  explained on the next slides.

### 9. Under the hood (45 s)

- "We checked that the compiler kept our intentions: the branch survives as
  `tbnz`; the constant-time S-box has zero branches and zero table lookups."
- "We caught OpenSSL with a debugger: hardware by default, and portable C
  when detection is disabled."

### 10. Limitations (45 s)

- Be upfront about the unexplained effect. "Our branch-free control got
  flagged under one specific condition. We tested five explanations and
  ruled most out. We report it as unexplained, and it's why we base our
  cache conclusions on the evicted runs."
- Detection ≠ exploitation. Non-detection ≠ proof.

### 11. Conclusions (30 s)

- Read the scorecard. Two take-aways. Questions.

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
