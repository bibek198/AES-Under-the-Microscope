# Demo checklist and script

## 30 minutes before

- [ ] Charger connected
- [ ] Low Power Mode **off**
- [ ] Do Not Disturb **on**
- [ ] Close every other app (browsers, chat, Spotlight indexing finished)
- [ ] Display mirroring tested on the room projector; browser zoom 100%
- [ ] `scripts/e2e.sh` passes (every module checked)
- [ ] `scripts/demo.sh --preflight` prints **ALL GO**
- [ ] Wi-Fi **off** (the demo is fully offline)
- [ ] `demo/backup.mov` (screen recording of a good rehearsal) is on the desktop

## Start

```bash
scripts/demo.sh        # starts the server, opens http://127.0.0.1:8765
```

Press **F** for fullscreen. Use **T** if the projector washes out the dark theme.

## Script (5 minutes)

| Time | Key | Do | Say |
|---|---|---|---|
| 0:00 | terminal | `build/aes_project test` | "The official FIPS-197 ciphertext, reproduced exactly." |
| 0:20 | `1` **Encrypt** | Ask the professor for 16 characters → type them → **Enter** | "Your text, going through all 10 rounds, straight from our C++ code." |
| 0:40 | | Click **Flip one bit** | "One bit in, about half of the 128 bits out. That's the avalanche effect." |
| 0:50 | `2` **Speed** | Click **Measure now** | "Same output, very different cost. Hardware AES is hundreds of times faster than our safe software version." |
| 1:30 | `3` **Leakage** | **Space** (hot cache) | "The red line is our deliberately leaky control. It shoots into the leakage zone within seconds. The A/A control stays flat. That's the harness working." |
| 2:15 | | Click **Cache flushed**, then **Space** | "Now we flush the cache before every encryption. Watch the T-table line." (Live is noisy. If it is inconclusive, press **R** and show the recorded run: \|t\| = 18.8.) |
| 3:00 | `4` **Attack** | Ask the professor to type a secret byte (hidden) → **Run attack** | "The attacker sees only timings… and recovers your byte." |
| 3:30 | | Click **Constant-time** → **Run attack** | "Same attack against the constant-time version: noise. That's why constant-time code matters. And remember: this leak existed only because we injected it." |
| 4:00 | `6` **Assembly** | | "Source isn't what runs. The branch survives as `tbnz` at -O2. The twin uses a mask." |
| 4:30 | `7` **Verdict** | | "Every hypothesis we wrote down in advance, judged by the recorded data. And the limits: detection isn't exploitation, and non-detection isn't proof." |

## If something goes wrong

| Problem | Fallback |
|---|---|
| Live chart misbehaves or is too noisy | Press **R** (replay of the recorded run, clearly labelled REPLAY) |
| Key recovery stream fails | It automatically replays the recorded attack |
| Browser or server problem | `scripts/demo.sh --terminal` (same steps in the terminal) |
| Laptop problem | Play `demo/backup.mov` |
