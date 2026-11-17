#!/usr/bin/env python3
"""Statistical analysis of an experiment run directory.

Usage:  python analysis/analyze.py results/<run_id>

Reads the raw samples written by `aes_project all` and produces, inside the
run directory:
    summary.csv     one row per (experiment, condition) with all statistics
    summary.json    same, plus hypothesis verdicts (used by the dashboard)
    summary.md      human-readable tables and the H0-H4 scorecard
    dashboard.json  compact data for the demo dashboard's replay mode
    figures/        F1-F5 as PNG (200 dpi) and SVG

Primary statistic (fixed before data collection): Welch's t on ALL samples,
threshold |t| > 4.5. Cropped variants (dudect-style percentiles) are reported
as secondary evidence and never replace the primary result silently.
"""
from __future__ import annotations

import json
import math
import sys
import warnings
from pathlib import Path

import numpy as np
import pandas as pd
from scipy import stats

THRESHOLD = 4.5
CROPS = (50, 90, 99)
BOOT_RESAMPLES = 300
BOOT_CAP = 200_000  # per class; subsampling makes the bootstrap CI conservative (wider)
RNG = np.random.default_rng(20261117)

IMPL_ORDER = ["pos_leaky", "pos_twin", "aa_control", "ref", "ttable", "ct", "armv8", "openssl", "openssl_armcap0"]


# ---------------------------------------------------------------------------
# Loading
# ---------------------------------------------------------------------------
def read_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    return [json.loads(line) for line in path.read_text().splitlines() if line.strip()]


def load_samples(path: Path, ns_per_tick: float) -> tuple[np.ndarray, np.ndarray, int]:
    """Returns (is_fixed bool array, ns-per-encryption array, batch B)."""
    df = pd.read_csv(path, dtype={"sample_idx": np.int64, "class": "category", "ticks": np.int64, "B": np.int64})
    if df.empty:
        raise ValueError(f"{path} contains no samples")
    if df["ticks"].min() < 0:
        raise ValueError(f"{path}: negative tick counts")
    batch = int(df["B"].iloc[0])
    is_fixed = (df["class"] == "fixed").to_numpy()
    ns = df["ticks"].to_numpy(dtype=np.float64) * ns_per_tick / batch
    return is_fixed, ns, batch


# ---------------------------------------------------------------------------
# Statistics
# ---------------------------------------------------------------------------
def welch(a: np.ndarray, b: np.ndarray) -> tuple[float, float, float]:
    """Welch's t = (mean_a - mean_b) / sqrt(s_a^2/n_a + s_b^2/n_b); returns (t, df, two-sided p)."""
    na, nb = len(a), len(b)
    va, vb = a.var(ddof=1), b.var(ddof=1)
    se2 = va / na + vb / nb
    if se2 == 0:
        return 0.0, float("nan"), 1.0
    t = (a.mean() - b.mean()) / math.sqrt(se2)
    df = se2**2 / ((va / na) ** 2 / (na - 1) + (vb / nb) ** 2 / (nb - 1))
    p = 2 * stats.t.sf(abs(t), df)
    return float(t), float(df), float(p)


def describe(x: np.ndarray) -> dict:
    return {
        "n": int(len(x)),
        "mean": float(x.mean()),
        "median": float(np.median(x)),
        "sd": float(x.std(ddof=1)),
        "min": float(x.min()),
        "max": float(x.max()),
        "p1": float(np.percentile(x, 1)),
        "p99": float(np.percentile(x, 99)),
    }


def mad(x: np.ndarray) -> float:
    return float(np.median(np.abs(x - np.median(x))) * 1.4826)


def bootstrap_median_diff(a: np.ndarray, b: np.ndarray) -> tuple[float, float]:
    a_s = a if len(a) <= BOOT_CAP else RNG.choice(a, BOOT_CAP, replace=False)
    b_s = b if len(b) <= BOOT_CAP else RNG.choice(b, BOOT_CAP, replace=False)
    diffs = np.empty(BOOT_RESAMPLES)
    for i in range(BOOT_RESAMPLES):
        diffs[i] = np.median(RNG.choice(a_s, len(a_s))) - np.median(RNG.choice(b_s, len(b_s)))
    lo, hi = np.percentile(diffs, [2.5, 97.5])
    return float(lo), float(hi)


def cumulative_t(is_fixed: np.ndarray, x: np.ndarray, points: int = 160) -> tuple[list[int], list[float]]:
    """Welch t on the first k samples, for log-spaced k (the |t| vs N curve)."""
    f = is_fixed.astype(np.float64)
    r = 1.0 - f
    cf, cr = np.cumsum(f), np.cumsum(r)
    sf, sr = np.cumsum(x * f), np.cumsum(x * r)
    qf, qr = np.cumsum(x * x * f), np.cumsum(x * x * r)
    n = len(x)
    ks = np.unique(np.geomspace(200, n, points).astype(int))
    out_k, out_t = [], []
    for k in ks:
        i = k - 1
        nf, nr = cf[i], cr[i]
        if nf < 2 or nr < 2:
            continue
        mf, mr = sf[i] / nf, sr[i] / nr
        vf = max((qf[i] - nf * mf * mf) / (nf - 1), 0.0)
        vr = max((qr[i] - nr * mr * mr) / (nr - 1), 0.0)
        se = math.sqrt(vf / nf + vr / nr)
        out_k.append(int(k))
        out_t.append(float((mf - mr) / se) if se > 0 else 0.0)
    return out_k, out_t


def holm(pvals: list[float]) -> list[float]:
    m = len(pvals)
    order = np.argsort(pvals)
    adjusted = np.empty(m)
    running = 0.0
    for rank, idx in enumerate(order):
        running = max(running, (m - rank) * pvals[idx])
        adjusted[idx] = min(1.0, running)
    return adjusted.tolist()


def analyse_samples(label: str, cond: str, mode: str, is_fixed: np.ndarray, ns: np.ndarray, batch: int) -> dict:
    a, b = ns[is_fixed], ns[~is_fixed]
    t, df, p = welch(a, b)
    row = {
        "label": label, "cond": cond, "mode": mode, "batch": batch,
        "n": int(len(ns)), "t": t, "abs_t": abs(t), "df": df, "p": p,
        "leak": abs(t) > THRESHOLD,
    }
    for name, arr in (("fixed", a), ("random", b)):
        for k, v in describe(arr).items():
            row[f"{name}_{k}"] = v
    row["mean_diff_ns"] = row["fixed_mean"] - row["random_mean"]
    row["median_diff_ns"] = row["fixed_median"] - row["random_median"]
    pooled_sd = math.sqrt((a.var(ddof=1) + b.var(ddof=1)) / 2)
    row["cohens_d"] = row["mean_diff_ns"] / pooled_sd if pooled_sd > 0 else 0.0
    pooled_mad = (mad(a) + mad(b)) / 2
    row["robust_effect"] = row["median_diff_ns"] / pooled_mad if pooled_mad > 0 else 0.0
    row["median_diff_ci_lo"], row["median_diff_ci_hi"] = bootstrap_median_diff(a, b)
    row["mannwhitney_p"] = float(stats.mannwhitneyu(a, b, alternative="two-sided", method="asymptotic").pvalue)
    with warnings.catch_warnings(), np.errstate(all="ignore"):
        warnings.simplefilter("ignore", RuntimeWarning)  # SciPy's KS p-value series overflows harmlessly at huge n
        row["ks_p"] = float(stats.ks_2samp(a, b, method="asymp").pvalue)
    # Smallest mean difference this run could have detected at |t| = 4.5.
    row["min_detectable_ns"] = THRESHOLD * math.sqrt(a.var(ddof=1) / len(a) + b.var(ddof=1) / len(b))
    for c in CROPS:
        thr = np.percentile(ns, c)
        keep = ns <= thr
        tc, _, _ = welch(ns[keep & is_fixed], ns[keep & ~is_fixed])
        row[f"t_crop{c}"] = tc
    row["max_abs_t_crop"] = max(abs(row[f"t_crop{c}"]) for c in CROPS)
    return row


# ---------------------------------------------------------------------------
# Hypotheses (rules fixed in advance; see report §6)
# ---------------------------------------------------------------------------
def verdicts(rows: dict[tuple[str, str], dict], bench: dict, armcap0: dict | None) -> list[dict]:
    def get(label, cond):
        return rows.get((label, cond))

    out = []
    aa = get("aa_control", "hot")
    if aa:
        out.append({"id": "H0", "title": "Negative control (A/A) stays below |t| = 4.5",
                    "verdict": "supported" if not aa["leak"] else "not supported",
                    "evidence": f"|t| = {aa['abs_t']:.2f} at n = {aa['n']:,}"})
    pos = get("pos_leaky", "hot")
    if pos:
        out.append({"id": "H1", "title": "Positive control (injected branch) is detected",
                    "verdict": "supported" if pos["leak"] else "not supported",
                    "evidence": f"|t| = {pos['abs_t']:.1f}; fixed {pos['fixed_mean']:.2f} ns vs random {pos['random_mean']:.2f} ns"})
    tt_e, tt_h = get("ttable", "evicted"), get("ttable", "hot")
    if tt_e:
        if tt_e["leak"]:
            v = "supported"
        elif tt_e["max_abs_t_crop"] > THRESHOLD:
            v = "inconclusive"
        else:
            v = "not supported"
        hot_txt = f"; hot |t| = {tt_h['abs_t']:.2f} (hot-cache results are confounded, see notebook)" if tt_h else ""
        out.append({"id": "H2", "title": "T-table AES leaks under cache eviction",
                    "verdict": v,
                    "evidence": f"evicted |t| = {tt_e['abs_t']:.2f} (max cropped |t| = {tt_e['max_abs_t_crop']:.2f}), "
                                f"mean diff {tt_e['mean_diff_ns']:+.2f} ns{hot_txt}"})
    ct_arm = [r for (lab, _), r in rows.items() if lab in ("ct", "armv8")]
    if ct_arm:
        worst = max(ct_arm, key=lambda r: r["abs_t"])
        out.append({"id": "H3", "title": "Constant-time software AES and ARMv8 AES show no detectable leakage",
                    "verdict": "supported" if not any(r["leak"] for r in ct_arm) else "not supported",
                    "evidence": f"largest |t| = {worst['abs_t']:.2f} ({worst['label']}, {worst['cond']}); "
                                f"smallest detectable difference ranged {min(r['min_detectable_ns'] for r in ct_arm):.3f}"
                                f"–{max(r['min_detectable_ns'] for r in ct_arm):.1f} ns/encryption across runs"})
    if "openssl" in bench and armcap0 and "openssl_armcap0" in armcap0.get("bench", {}):
        hw = bench["openssl"]["latency_ns_median"]
        sw = armcap0["bench"]["openssl_armcap0"]["latency_ns_median"]
        ratio = sw / hw
        out.append({"id": "H4", "title": "OpenSSL behaviour depends on the selected code path",
                    "verdict": "supported" if ratio > 2 or ratio < 0.5 else "not supported",
                    "evidence": f"latency {hw:.2f} ns (default) vs {sw:.2f} ns (OPENSSL_armcap=0), ×{ratio:.1f}"})
    else:
        out.append({"id": "H4", "title": "OpenSSL behaviour depends on the selected code path",
                    "verdict": "inconclusive", "evidence": "OPENSSL_armcap=0 run not present in this run directory"})
    return out


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def analyse_dir(run: Path, ns_per_tick: float, suffix: str = "") -> tuple[dict, dict]:
    rows, curves = {}, {}
    for csv in sorted(run.glob("samples_*.csv")):
        stem = csv.stem[len("samples_"):]
        label, cond = stem.rsplit("_", 1)
        label += suffix
        mode = "random_vs_random" if label.startswith("aa_") else "fixed_vs_random"
        is_fixed, ns, batch = load_samples(csv, ns_per_tick)
        rows[(label, cond)] = analyse_samples(label, cond, mode, is_fixed, ns, batch)
        k, t = cumulative_t(is_fixed, ns)
        curves[f"{label}|{cond}"] = {"n": k, "t": t}
        print(f"  {label:<18} {cond:<8} n={len(ns):>9,}  |t|={abs(rows[(label, cond)]['t']):8.2f}")
    return rows, curves


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 1
    run = Path(sys.argv[1])
    meta_path = run / "metadata.json"
    if not meta_path.exists():
        print(f"error: {meta_path} not found; is this a run directory?")
        return 1
    meta = json.loads(meta_path.read_text())
    ns_per_tick = float(meta["platform"]["ns_per_tick"])
    print(f"Analysing {run}  (ns per tick = {ns_per_tick:.4f})")

    rows, curves = analyse_dir(run, ns_per_tick)
    if not rows:
        print("error: no samples_*.csv files found; nothing to analyse (no results are invented)")
        return 1

    # Optional sub-runs: -O0 build (E5) and OPENSSL_armcap=0 (H4).
    extra = {}
    for sub, suffix in (("O0", "@O0"), ("armcap0", "")):
        d = run / sub
        if d.is_dir() and (d / "metadata.json").exists():
            r2, c2 = analyse_dir(d, ns_per_tick, suffix)
            if sub == "armcap0":
                r2 = {(lab.replace("openssl", "openssl_armcap0"), cond): {**v, "label": lab.replace("openssl", "openssl_armcap0")}
                      for (lab, cond), v in r2.items()}
                c2 = {key.replace("openssl", "openssl_armcap0"): v for key, v in c2.items()}
            rows.update(r2)
            curves.update(c2)
            extra[sub] = {"bench": {}}
            for b in read_jsonl(d / "bench.jsonl"):
                name = b["impl"] + ("_armcap0" if sub == "armcap0" else "@O0")
                extra[sub]["bench"][name] = {**b, "impl": name}

    # Holm correction across all tests in this run.
    keys = list(rows)
    for key, adj in zip(keys, holm([rows[k]["p"] for k in keys])):
        rows[key]["p_holm"] = adj

    bench = {b["impl"]: b for b in read_jsonl(run / "bench.jsonl")}
    for sub in extra.values():
        bench.update(sub["bench"])
    hyps = verdicts(rows, bench, extra.get("armcap0"))

    def sort_key(k):
        lab, cond = k
        base = lab.split("@")[0]
        return (IMPL_ORDER.index(base) if base in IMPL_ORDER else 99, "@" in lab, cond != "hot")

    ordered = [rows[k] for k in sorted(rows, key=sort_key)]
    pd.DataFrame(ordered).to_csv(run / "summary.csv", index=False)

    profiles = {}
    for p in run.glob("profile_*.json"):
        d = json.loads(p.read_text())
        profiles[f"{d['impl']}|{d['cond']}"] = {"mean_ns": d["mean_ns_by_p0"], "count": d["count_by_p0"], "n": d["n"]}
    recover = {}
    for p in run.glob("recover_*.json"):
        d = json.loads(p.read_text())
        recover[d["target"]] = {"true_byte": d["true_byte"], "n_trace": d["n_trace"], "rank_trace": d["rank_trace"],
                                "scores": d["final"]["scores"], "best_guess": d["final"]["best_guess"]}

    summary = {"run": run.name, "threshold": THRESHOLD, "metadata": meta, "hypotheses": hyps,
               "results": ordered, "bench": list(bench.values())}
    (run / "summary.json").write_text(json.dumps(summary, indent=1, default=float))
    dashboard = {"run": run.name, "metadata": meta["platform"], "threshold": THRESHOLD,
                 "bench": list(bench.values()), "curves": curves,
                 "final": [{k: r[k] for k in ("label", "cond", "n", "t", "batch", "fixed_mean", "random_mean",
                                               "mean_diff_ns", "max_abs_t_crop", "leak")} for r in ordered],
                 "profiles": profiles, "recover": recover, "hypotheses": hyps}
    (run / "dashboard.json").write_text(json.dumps(dashboard, default=float))
    write_markdown(run, meta, ordered, bench, hyps)

    from figures import make_all  # local module
    make_all(run, ordered, curves, bench, profiles)
    print(f"Wrote summary.csv, summary.json, summary.md, dashboard.json and figures/ in {run}")
    return 0


def fmt_p(p: float) -> str:
    return "< 1e-300" if p == 0 else f"{p:.2e}"


def write_markdown(run: Path, meta: dict, rows: list[dict], bench: dict, hyps: list[dict]) -> None:
    plat = meta["platform"]
    L = [f"# Results summary: run `{run.name}`", "",
         f"{plat['cpu']} · {plat['os']} · {plat['compiler']} · `{plat['opt_flags']} {plat['cpu_flags']}` · "
         f"timer {plat['ns_per_tick']:.3f} ns/tick · power: {plat['power_source']} · commit {plat['git_commit']}", "",
         "Primary statistic: Welch's t on all samples, |t| > 4.5 ⇒ leakage detected. "
         "Cropped |t| (dudect-style, samples below the 50th/90th/99th pooled percentile) is secondary.", "",
         "## Hypothesis scorecard", "", "| ID | Hypothesis | Verdict | Evidence |", "|---|---|---|---|"]
    icon = {"supported": "✔ supported", "not supported": "✘ not supported", "inconclusive": "? inconclusive"}
    for h in hyps:
        esc = lambda txt: txt.replace("|", "\\|")
        L.append(f"| {h['id']} | {esc(h['title'])} | {icon[h['verdict']]} | {esc(h['evidence'])} |")
    L += ["", "## Performance (E2)", "", "| impl | latency ns/block (median) | sd | MB/s 4 KB | MB/s 1 MB |", "|---|---|---|---|---|"]
    for name, b in bench.items():
        L.append(f"| {name} | {b['latency_ns_median']:.2f} | {b['latency_ns_sd']:.2f} | "
                 f"{b['throughput_4k_MBps']:.1f} | {b['throughput_1m_MBps']:.1f} |")
    L += ["", "## Leakage tests (E3–E5)", "",
          "| experiment | cache | n | B | \\|t\\| | max cropped \\|t\\| | fixed mean ns | random mean ns | diff ns | Cohen's d | Holm p | min detectable ns | verdict |",
          "|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for r in rows:
        v = "**LEAK DETECTED**" if r["leak"] else "no evidence"
        L.append(f"| {r['label']} | {r['cond']} | {r['n']:,} | {r['batch']} | {r['abs_t']:.2f} | {r['max_abs_t_crop']:.2f} | "
                 f"{r['fixed_mean']:.3f} | {r['random_mean']:.3f} | {r['mean_diff_ns']:+.3f} | {r['cohens_d']:+.4f} | "
                 f"{fmt_p(r['p_holm'])} | {r['min_detectable_ns']:.3f} | {v} |")
    L += ["", "## Robust checks", "", "| experiment | cache | median diff ns [95% bootstrap CI] | robust effect | Mann–Whitney p | KS p |",
          "|---|---|---|---|---|---|"]
    for r in rows:
        L.append(f"| {r['label']} | {r['cond']} | {r['median_diff_ns']:+.3f} [{r['median_diff_ci_lo']:+.3f}, {r['median_diff_ci_hi']:+.3f}] | "
                 f"{r['robust_effect']:+.3f} | {fmt_p(r['mannwhitney_p'])} | {fmt_p(r['ks_p'])} |")
    L += ["", "Notes: timings are per encryption (sample ticks × ns/tick ÷ B). A detection says the two input classes "
          "have different timing distributions; it does not by itself identify the cause or show exploitability. "
          "Non-detection is bounded by the 'min detectable' column, not a proof of constant time.", ""]
    (run / "summary.md").write_text("\n".join(L))


if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).parent))
    sys.exit(main())
