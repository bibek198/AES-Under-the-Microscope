#!/usr/bin/env python3
"""End-to-end test of every module of AES Under the Microscope.

    python3 tests/e2e/run_e2e.py            # ~2 minutes
    python3 tests/e2e/run_e2e.py --full     # also runs scripts/collect.sh --quick (~4 more minutes)

Layers covered (each check prints PASS/FAIL; exit code 1 on any failure):
  1. build + unit tests (ctest)
  2. CLI: every command, JSON output, and error handling
  3. pipeline: quick `all` run, OpenSSL fallback run, statistical analysis, figures
  4. server: static files, every API endpoint, input validation, SSE streams
  5. dashboard: every panel rendered in headless Chrome, DOM content, JS errors, both themes
  6. scripts: asm.sh, demo.sh --preflight (and collect.sh --quick with --full)
Uses only the Python standard library (plus the project's .venv for the analysis step).
"""
from __future__ import annotations

import json
import os
import re
import shutil
import socket
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / "build" / "aes_project"
VENV_PY = ROOT / ".venv" / "bin" / "python"
CHROME = Path("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
FIPS_CT = "69c4e0d86a7b0430d8cdb78070b4c55a"

results: list[tuple[str, str, bool, str]] = []
section = ""


def check(name: str, ok: bool, detail: str = "") -> bool:
    results.append((section, name, bool(ok), detail))
    mark = "\033[32mPASS\033[0m" if ok else "\033[31mFAIL\033[0m"
    print(f"  {mark}  {name}" + (f"  \033[2m({detail})\033[0m" if detail and not ok else ""))
    return ok


def begin(title: str):
    global section
    section = title
    print(f"\n\033[1m{title}\033[0m")


def run(args, timeout=300, env=None, cwd=ROOT):
    return subprocess.run(args, capture_output=True, text=True, timeout=timeout, cwd=cwd,
                          env={**os.environ, **(env or {})})


def cli(*args, timeout=300, env=None):
    return run([str(BIN), *args], timeout=timeout, env=env)


def ndjson(text: str) -> list[dict]:
    return [json.loads(line) for line in text.splitlines() if line.strip()]


# --------------------------------------------------------------------------- 1
def test_build():
    begin("1. Build and unit tests")
    r = run(["scripts/build.sh"], timeout=600)
    check("scripts/build.sh succeeds", r.returncode == 0, r.stderr[-300:])
    check("build has no compiler warnings", "warning:" not in (r.stdout + r.stderr))
    r = run(["ctest", "--output-on-failure"], cwd=ROOT / "build", timeout=600)
    check("ctest: all unit tests pass", r.returncode == 0 and "100% tests passed" in r.stdout, r.stdout[-300:])


# --------------------------------------------------------------------------- 2
def test_cli():
    begin("2. Command-line interface")
    r = cli("test", "--json")
    recs = ndjson(r.stdout)
    summary = next((x for x in recs if x["type"] == "selftest_summary"), {})
    check("test: self-test passes", r.returncode == 0 and summary.get("ok") is True)
    check("test: 43 checks (7 variants x 6 vectors + cross-check)", summary.get("checks") == 43, str(summary))
    check("test: human output shows FIPS-197 ciphertext", FIPS_CT in cli("test", "--no-color").stdout)

    info = ndjson(cli("info", "--json").stdout)[0]["metadata"]
    check("info: timer is 24 MHz (41.667 ns/tick)", abs(info["ns_per_tick"] - 41.6667) < 0.01, str(info["ns_per_tick"]))
    check("info: reports CPU, OpenSSL and build flags", all(info.get(k) for k in ("cpu", "openssl_version", "opt_flags")))

    t = ndjson(cli("trace", "--pt", "00112233445566778899aabbccddeeff", "--key", "000102030405060708090a0b0c0d0e0f", "--json").stdout)[0]
    check("trace: ciphertext equals FIPS-197 C.1", t["ciphertext"] == FIPS_CT)
    check("trace: 41 steps and 11 round keys", len(t["steps"]) == 41 and len(t["round_keys"]) == 11)
    check("trace: last step equals ciphertext", t["steps"][-1]["state"] == t["ciphertext"])

    bench = [x for x in ndjson(cli("bench", "--quick", "--json").stdout) if x["type"] == "bench"]
    names = {b["impl"] for b in bench}
    check("bench: all 5 implementations measured", names == {"ref", "ttable", "ct", "armv8", "openssl"}, str(names))
    by = {b["impl"]: b for b in bench}
    if len(by) == 5:
        check("bench: hardware AES faster than T-table faster than constant-time",
              by["armv8"]["latency_ns_median"] < by["ttable"]["latency_ns_median"] < by["ct"]["latency_ns_median"])

    lk = ndjson(cli("leakage", "--impl", "pos_leaky,armv8", "--cond", "hot", "--n", "30000", "--json").stdout)
    final = {x["impl"]: x for x in lk if x["type"] == "leakage"}
    check("leakage: positive control detected (|t| > 4.5)", abs(final.get("pos_leaky", {}).get("t", 0)) > 4.5)
    check("leakage: records carry n, batch and class means",
          all(k in final.get("armv8", {}) for k in ("n", "batch", "mean_fixed_ns", "mean_random_ns", "t_crop")))
    st = ndjson(cli("leakage", "--impl", "ct", "--cond", "evicted", "--n", "6000", "--stream", "--every", "2000", "--json").stdout)
    check("leakage --stream: progress records every 2000 samples", [x["n"] for x in st if x["type"] == "tstat"] == [2000, 4000, 6000])

    ctl = ndjson(cli("controls", "--n", "20000", "--json").stdout)
    labels = {x["label"] for x in ctl if x["type"] == "leakage"}
    check("controls: positive, twin and A/A all run", labels == {"pos_leaky", "pos_twin", "aa_control"}, str(labels))

    race = ndjson(cli("race", "--n", "10000", "--every", "5000", "--json").stdout)
    tst = [x for x in race if x["type"] == "tstat"]
    check("race: 6 implementations interleaved, 2 updates each", len(tst) == 12 and len({x["label"] for x in tst}) == 6)
    check("race: ends with a done record", race and race[-1]["type"] == "done")

    prof = ndjson(cli("profile", "--impl", "ttable", "--cond", "hot", "--n", "20000", "--json").stdout)[0]
    check("profile: 256 bins whose counts sum to n", len(prof["mean_ns_by_p0"]) == 256 and sum(prof["count_by_p0"]) == 20000)

    rec = ndjson(cli("recover", "--target", "leaky", "--key-byte", "a7", "--n", "20000", "--stream", "--json").stdout)
    fin = rec[-1] if rec else {}
    check("recover: toy attack finds the injected secret 0xa7", fin.get("type") == "recover_result" and fin.get("best_guess") == 0xA7)
    check("recover: 256 scores reported", len(fin.get("scores", [])) == 256)

    # Error handling
    for args, why in ((["bogus"], "unknown command"), (["leakage", "--impl", "nope"], "unknown implementation"),
                      (["leakage", "--n", "abc"], "non-numeric --n"), (["trace", "--pt", "zz", "--key", "00"], "bad hex"),
                      (["recover", "--key-byte", "1ff"], "key byte out of range"), (["recover", "--target", "x", "--key-byte", "01"], "bad target"),
                      (["bench", "--frobnicate"], "unknown option")):
        r = cli(*args)
        check(f"error: {why} → non-zero exit with message", r.returncode != 0 and (r.stderr.strip() or r.stdout.strip()))
    check("help: usage text", "Usage: aes_project" in cli("help").stdout)


# --------------------------------------------------------------------------- 3
def test_pipeline(tmp: Path) -> Path:
    begin("3. Experiment pipeline and analysis")
    run_dir = tmp / "run"
    r = cli("all", "--quick", "--out", str(run_dir), "--no-color", timeout=900)
    check("all --quick completes", r.returncode == 0, r.stderr[-300:])
    expected = ["metadata.json", "selftest.jsonl", "bench.jsonl", "leakage.jsonl", "recover_leaky.json", "recover_ct.json",
                "profile_ttable_evicted.json", "profile_ct_evicted.json"]
    missing = [f for f in expected if not (run_dir / f).exists()]
    check("all: every output file written", not missing, ", ".join(missing))
    csvs = sorted(p.name for p in run_dir.glob("samples_*.csv"))
    check("all: 13 raw sample files (3 controls + 5 impls x 2 conditions)", len(csvs) == 13, str(len(csvs)))
    head = (run_dir / "samples_ttable_hot.csv").read_text().splitlines()
    check("samples CSV: header and 100,000 rows", head[0] == "sample_idx,class,ticks,B" and len(head) == 100001)
    meta = json.loads((run_dir / "metadata.json").read_text())
    check("metadata: platform recorded", meta["platform"]["cpu"] and meta["quick"] is True)

    r = cli("bench", "--impl", "openssl", "--quick", "--out", str(run_dir / "armcap0"), env={"OPENSSL_armcap": "0"})
    r2 = cli("leakage", "--impl", "openssl", "--n", "20000", "--out", str(run_dir / "armcap0"), env={"OPENSSL_armcap": "0"})
    check("OPENSSL_armcap=0 sub-run completes", r.returncode == 0 and r2.returncode == 0)

    py = str(VENV_PY if VENV_PY.exists() else sys.executable)
    r = run([py, "analysis/analyze.py", str(run_dir)], timeout=900)
    check("analysis completes", r.returncode == 0, r.stderr[-400:])
    for f in ("summary.csv", "summary.json", "summary.md", "dashboard.json"):
        check(f"analysis: {f} written", (run_dir / f).exists())
    figs = sorted(p.name for p in (run_dir / "figures").glob("*.png"))
    check("analysis: figures F1, F2, F3, F5 rendered", {"F1_performance.png", "F2_t_vs_n.png", "F3_ecdf.png", "F5_profile.png"} <= set(figs), str(figs))
    summ = json.loads((run_dir / "summary.json").read_text())
    hyp = {h["id"]: h["verdict"] for h in summ["hypotheses"]}
    check("analysis: hypotheses H0-H4 all judged", set(hyp) == {"H0", "H1", "H2", "H3", "H4"}, str(hyp))
    check("analysis: H1 (positive control) supported", hyp.get("H1") == "supported")
    check("analysis: H4 supported (OpenSSL fallback is slower)", hyp.get("H4") == "supported", str(hyp.get("H4")))
    dash = json.loads((run_dir / "dashboard.json").read_text())
    check("dashboard.json: curves, profiles, recovery, bench",
          dash["curves"] and "ttable|evicted" in dash["profiles"] and set(dash["recover"]) == {"leaky", "ct"} and len(dash["bench"]) == 6)
    row = next(r for r in summ["results"] if r["label"] == "pos_leaky")
    check("analysis: Welch t matches the C++ online statistic",
          abs(row["t"] - next(x["t"] for x in ndjson((run_dir / "leakage.jsonl").read_text()) if x["label"] == "pos_leaky")) < 1e-6 * max(1, abs(row["t"])))

    r = run([py, "analysis/analyze.py", str(tmp / "does-not-exist")])
    check("analysis: missing run directory → clean error", r.returncode == 1 and "not found" in r.stdout)
    empty = tmp / "empty"
    empty.mkdir()
    shutil.copy(run_dir / "metadata.json", empty)
    r = run([py, "analysis/analyze.py", str(empty)])
    check("analysis: no samples → refuses to invent results", r.returncode == 1 and "nothing to analyse" in r.stdout)
    return run_dir


# --------------------------------------------------------------------------- 4
def free_port() -> int:
    with socket.socket() as s:
        s.bind(("127.0.0.1", 0))
        return s.getsockname()[1]


def http(port, path, timeout=60):
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{port}{path}", timeout=timeout) as r:
            return r.status, r.headers.get("Content-Type", ""), r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("Content-Type", ""), e.read()
    except (ConnectionError, OSError) as e:  # dropped connection = server bug
        return 0, "", str(e).encode()


def sse(port, path, timeout=240) -> list[dict]:
    events = []
    with urllib.request.urlopen(f"http://127.0.0.1:{port}{path}", timeout=timeout) as r:
        for raw in r:
            line = raw.decode().rstrip("\n")
            if line.startswith("event: end"):
                break
            if line.startswith("data: "):
                events.append(json.loads(line[6:]))
    return events


def test_server(port: int):
    begin("4. Dashboard server")
    for path, ctype in (("/", "text/html"), ("/app.js", "javascript"), ("/style.css", "text/css"), ("/vendor/chart.umd.min.js", "javascript")):
        code, ct, body = http(port, path)
        check(f"GET {path} → 200 {ctype}", code == 200 and ctype in ct and body)
    html = http(port, "/")[2].decode()
    check("index.html references no external URLs (offline)", not re.search(r'(src|href)="https?://', html))
    code, _, _ = http(port, "/../server.py")
    check("static: path traversal is not served", code == 404)

    code, _, body = http(port, "/api/selftest")
    check("/api/selftest: passes", code == 200 and any(r.get("type") == "selftest_summary" and r["ok"] for r in json.loads(body)))
    code, _, body = http(port, "/api/trace?pt=00112233445566778899aabbccddeeff&key=000102030405060708090a0b0c0d0e0f")
    check("/api/trace: FIPS-197 ciphertext", code == 200 and json.loads(body)["ciphertext"] == FIPS_CT)
    for q in ("pt=zz&key=00", "pt=00112233445566778899aabbccddeeff", "pt=00112233445566778899aabbccddeeff;ls&key=000102030405060708090a0b0c0d0e0f"):
        code, _, _ = http(port, f"/api/trace?{q}")
        check(f"/api/trace rejects invalid input ({q[:24]}…)", code == 400)
    code, _, body = http(port, "/api/bench", timeout=120)
    check("/api/bench: 5 live measurements", code == 200 and len([r for r in json.loads(body) if r["type"] == "bench"]) == 5)
    code, _, body = http(port, "/api/dashboard")
    check("/api/dashboard: recorded run served", code == 200 and "hypotheses" in json.loads(body))
    check("/api/dashboard rejects bad run id", http(port, "/api/dashboard?run=../../etc")[0] == 404)
    check("/api/dashboard unknown run → 404", http(port, "/api/dashboard?run=no-such-run")[0] == 404)
    code, _, body = http(port, "/api/asm")
    asm = json.loads(body) if code == 200 else {}
    check("/api/asm: -O2 keeps the secret branch (tbnz)", any("tbnz" in l for l in asm.get("O2", [])))
    check("/api/asm: source and twin extracted", any("if (s < 0x80)" in l for l in asm.get("source", [])) and asm.get("twin_O2"))
    for path in ("/api/stream/race?cond=warm", "/api/stream/recover?target=leaky&key=zz", "/api/stream/recover?target=evil&key=01", "/api/nope"):
        check(f"{path} → 400", http(port, path)[0] == 400)

    ev = sse(port, "/api/stream/recover?target=leaky&key=5e")
    fin = next((e for e in ev if e["type"] == "recover_result"), {})
    check("SSE recover: progress events then recovery of 0x5e", len(ev) > 5 and fin.get("best_guess") == 0x5E)
    ev = sse(port, "/api/stream/race?cond=hot")
    tst = [e for e in ev if e["type"] == "tstat"]
    check("SSE race: all 6 implementations stream progress", len({e["label"] for e in tst}) == 6 and len(tst) >= 60, str(len(tst)))
    lk = {e["label"]: e for e in ev if e["type"] == "leakage"}
    check("SSE race: positive control flagged live", abs(lk.get("pos_leaky", {}).get("t", 0)) > 4.5)
    check("/api/stop responds", json.loads(http(port, "/api/stop")[2]).get("stopped") is True)


# --------------------------------------------------------------------------- 5
def dump_dom(port, query_hash: str) -> str:
    profile = tempfile.mkdtemp(prefix="e2e-chrome-")
    try:
        r = subprocess.run([str(CHROME), "--headless=new", "--disable-gpu", "--window-size=1920,1080", f"--user-data-dir={profile}",
                            "--virtual-time-budget=12000", "--dump-dom", f"http://127.0.0.1:{port}/{query_hash}"],
                           capture_output=True, text=True, timeout=120)
        return r.stdout
    finally:
        shutil.rmtree(profile, ignore_errors=True)


def test_dashboard(port: int):
    begin("5. Dashboard UI (headless Chrome)")
    if not CHROME.exists():
        check("Google Chrome available for UI tests", False, "install Chrome to run the UI layer")
        return
    cases = {
        "explorer": ("?capture#explorer-avalanche", [(r'id="ctHex">[0-9a-f]{32}<', "ciphertext shown"),
                                                       (r'43 known-answer checks pass', "self-test shown"),
                                                       (r'id="avPct"[^>]*>\d+%<', "avalanche percentage"),
                                                       (r'(class="changed".*){1,}', "changed bytes highlighted")]),
        "speed": ("?capture#speed", [(r'id="statRatio">\d+<small>', "speed-up ratio"), (r'(class="num">[\d.]+ ns.*){5}', "5 latencies")]),
        "race": ("?capture#race-replay", [(r'id="raceN">[\d,]+<', "sample counter"), (r'class="tag leak', "leak verdict rendered"),
                                           (r'(class="list-row".*){6}', "6 verdict rows")]),
        "heist": ("?capture#heist-replay", [(r'class="reveal found"', "recorded secret recovered"), (r'Recovered from timing alone', "reveal text")]),
        "heatmap": ("?capture#heatmap", [(r'id="hmPerCell">≈ [\d,]+<', "samples per cell"), (r'samples</span>', "titles with sample counts")]),
        "compiler": ("?capture#compiler", [(r'<span class="hl">\s*tbnz', "secret branch highlighted"), (r'class="tag mini leak"', "|t| badges")]),
        "scorecard": ("?capture#scorecard", [(r'(class="score-row".*){5}', "5 hypotheses"), (r'Supported', "verdicts")]),
        "light theme": ("?capture&theme=light#race-replay", [(r'data-theme="light"', "light theme applied")]),
    }
    for panel, (url, patterns) in cases.items():
        dom = dump_dom(port, url)
        flat = dom.replace("\n", " ")
        m = re.search(r'data-js-errors="(\d+)"', flat)
        check(f"{panel}: page loads without JavaScript errors", bool(dom) and not m, f"errors={m.group(1) if m else 0}")
        target = re.search(r'<section class="panel on" id="panel-(\w+)"', flat)
        if panel != "light theme":
            check(f"{panel}: correct panel is active", target is not None and panel.startswith(target.group(1)[:4]), target.group(1) if target else "none")
        for pat, what in patterns:
            check(f"{panel}: {what}", re.search(pat, flat) is not None)


# --------------------------------------------------------------------------- 6
def test_scripts(full: bool):
    begin("6. Scripts")
    r = run(["scripts/asm.sh"], timeout=300)
    check("asm.sh: listings generated", r.returncode == 0 and (ROOT / "assembly/controls_O2.s").exists())
    check("asm.sh: OpenSSL hardware instructions counted", "aese  instructions:" in (ROOT / "assembly/openssl_symbols.txt").read_text())
    r = run(["scripts/demo.sh", "--preflight"], timeout=120)
    check("demo.sh --preflight: ALL GO", r.returncode == 0 and "ALL GO" in r.stdout, r.stdout[-300:])
    if full:
        r = run(["scripts/test.sh"], timeout=1800)
        check("test.sh: unit tests + AddressSanitizer/UBSan build", r.returncode == 0 and r.stdout.count("100% tests passed") == 2, r.stdout[-300:])
        latest = ROOT / "results" / "latest"
        previous = os.readlink(latest) if latest.is_symlink() else None
        out = ROOT / "results" / "e2e-collect"
        try:
            r = run(["scripts/collect.sh", "--quick"], timeout=1800, env={"RUN_ID": "e2e-collect"})
            check("collect.sh --quick: full pipeline", r.returncode == 0, r.stdout[-400:])
            check("collect.sh: -O0 and armcap=0 sub-runs analysed",
                  (out / "O0" / "leakage.jsonl").exists() and (out / "armcap0" / "bench.jsonl").exists() and (out / "summary.md").exists())
        finally:  # never leave the demo pointing at a test run
            if previous:
                latest.unlink(missing_ok=True)
                latest.symlink_to(previous)
            if out.is_dir() and out.name == "e2e-collect":
                shutil.rmtree(out)


def main():
    full = "--full" in sys.argv
    t0 = time.time()
    tmp = Path(tempfile.mkdtemp(prefix="aes-e2e-"))
    server = None
    try:
        test_build()
        if not BIN.exists():
            print("binary missing: stopping")
            return 1
        test_cli()
        test_pipeline(tmp)
        port = free_port()
        server = subprocess.Popen([sys.executable, "demo/server.py", "--port", str(port)], cwd=ROOT,
                                  stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for _ in range(50):
            try:
                socket.create_connection(("127.0.0.1", port), timeout=0.2).close()
                break
            except OSError:
                time.sleep(0.1)
        test_server(port)
        test_dashboard(port)
        test_scripts(full)
    finally:
        if server:
            server.terminate()
        shutil.rmtree(tmp, ignore_errors=True)

    failed = [r for r in results if not r[2]]
    print(f"\n\033[1m{len(results) - len(failed)}/{len(results)} checks passed in {time.time() - t0:.0f} s\033[0m")
    for sec, name, _, detail in failed:
        print(f"  \033[31mFAIL\033[0m [{sec}] {name}  {detail}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
