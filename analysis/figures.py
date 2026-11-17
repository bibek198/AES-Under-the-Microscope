"""Figures F1-F5 for the report (PNG 200 dpi + SVG).

Colour rules: every implementation keeps one fixed colour in every figure
(colour follows the entity). Hues come from a validated colour-blind-safe
categorical palette; text stays in neutral ink; identity is never conveyed
by colour alone (legends and direct labels are always present).
"""
from __future__ import annotations

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
import pandas as pd  # noqa: E402

SURFACE = "#fcfcfb"
INK = "#0b0b0b"
INK2 = "#52514e"
GRID = "#e4e3de"
THRESH = "#52514e"

COLORS = {
    "ref": "#2a78d6",          # blue
    "ttable": "#eb6834",       # orange
    "ct": "#1baf7a",           # aqua
    "armv8": "#eda100",        # yellow
    "openssl": "#e87ba4",      # magenta
    "openssl_armcap0": "#008300",  # green
    "pos_twin": "#6250d6",     # violet
    "pos_leaky": "#e34948",    # red
    "aa_control": "#8a8984",   # neutral grey (control)
}
NAMES = {
    "ref": "ref (textbook)", "ttable": "ttable (T-tables)", "ct": "ct (constant-time SW)",
    "armv8": "armv8 (hardware AES)", "openssl": "OpenSSL", "openssl_armcap0": "OpenSSL, armcap=0",
    "pos_twin": "positive-control twin (branch-free)", "pos_leaky": "positive control (injected branch)",
    "aa_control": "A/A negative control",
}
CLASS_COLORS = {"fixed": "#2a78d6", "random": "#eb6834"}


def _style():
    plt.rcParams.update({
        "figure.facecolor": SURFACE, "axes.facecolor": SURFACE, "savefig.facecolor": SURFACE,
        "axes.edgecolor": GRID, "axes.labelcolor": INK2, "xtick.color": INK2, "ytick.color": INK2,
        "text.color": INK, "axes.grid": True, "grid.color": GRID, "grid.linewidth": 0.8,
        "axes.spines.top": False, "axes.spines.right": False, "font.size": 10,
        "axes.titlesize": 11, "axes.titleweight": "bold", "axes.titlelocation": "left",
        "legend.frameon": False, "lines.linewidth": 2,
    })


def _save(fig, out: Path, name: str):
    out.mkdir(parents=True, exist_ok=True)
    fig.savefig(out / f"{name}.png", dpi=200, bbox_inches="tight")
    fig.savefig(out / f"{name}.svg", bbox_inches="tight")
    plt.close(fig)


def _base(label: str) -> str:
    return label.split("@")[0]


# F1 ------------------------------------------------------------------------
def fig_performance(out: Path, bench: dict):
    order = [k for k in ["ct", "ref", "ttable", "openssl_armcap0", "openssl", "armv8"] if k in bench]
    if not order:
        return
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 3.4), sharey=True)
    y = np.arange(len(order))
    for i, k in enumerate(order):
        b = bench[k]
        c = COLORS.get(k, INK2)
        ax1.errorbar(b["latency_ns_median"], i, xerr=b["latency_ns_sd"], fmt="o", ms=8, color=c,
                     ecolor=INK2, elinewidth=1, capsize=3, mec=SURFACE, mew=2)
        ax1.annotate(f"{b['latency_ns_median']:.1f}", (b["latency_ns_median"], i), xytext=(8, 6),
                     textcoords="offset points", color=INK2, fontsize=9)
        ax2.plot(b["throughput_1m_MBps"], i, "o", ms=8, color=c, mec=SURFACE, mew=2)
        ax2.annotate(f"{b['throughput_1m_MBps']:,.0f}", (b["throughput_1m_MBps"], i), xytext=(8, 6),
                     textcoords="offset points", color=INK2, fontsize=9)
    ax1.set_xscale("log"); ax2.set_xscale("log")
    ax1.set_yticks(y, [NAMES.get(k, k) for k in order])
    ax1.set_xlabel("latency per block (ns, log scale) — lower is faster")
    ax2.set_xlabel("bulk throughput, 1 MB buffer (MB/s, log scale)")
    ax1.set_title("F1a  Single-block latency")
    ax2.set_title("F1b  Throughput")
    ax1.grid(axis="y", visible=False); ax2.grid(axis="y", visible=False)
    _save(fig, out, "F1_performance")


# F2 ------------------------------------------------------------------------
def fig_t_vs_n(out: Path, curves: dict):
    conds = [c for c in ("hot", "evicted") if any(k.endswith("|" + c) for k in curves)]
    if not conds:
        return
    fig, axes = plt.subplots(1, len(conds), figsize=(6.2 * len(conds), 4.4), sharey=True, squeeze=False)
    for ax, cond in zip(axes[0], conds):
        keys = [k for k in curves if k.endswith("|" + cond) and "@" not in k]
        keys.sort(key=lambda k: list(COLORS).index(k.split("|")[0]) if k.split("|")[0] in COLORS else 99)
        ends = []
        for k in keys:
            label = k.split("|")[0]
            n = np.array(curves[k]["n"]); t = np.maximum(np.abs(np.array(curves[k]["t"])), 0.03)
            ls = "--" if label == "aa_control" else "-"
            ax.plot(n, t, ls, lw=1.7, color=COLORS.get(label, INK2), label=NAMES.get(label, label))
            ends.append([np.log10(t[-1]), label, n[-1]])
        # Direct end labels, nudged apart (in log space) so they never overlap.
        ends.sort()
        for i in range(1, len(ends)):
            ends[i][0] = max(ends[i][0], ends[i - 1][0] + 0.12)
        for y, label, x in ends:
            ax.annotate(label, (x, 10 ** y), xytext=(5, 0), textcoords="offset points",
                        color=INK2, fontsize=8, va="center")
        ax.axhline(4.5, color=THRESH, lw=1.2, ls=(0, (4, 3)))
        ax.text(ax.get_xlim()[0] if False else 220, 5.2, "|t| = 4.5 threshold", color=INK2, fontsize=8)
        ax.set_xscale("log"); ax.set_yscale("log")
        ax.set_ylim(0.03, None)
        ax.set_xlabel("number of samples N (log)")
        ax.set_title(f"F2  Evidence vs samples — {cond} cache")
    axes[0][0].set_ylabel("|Welch t| (log)")
    handles, labels = [], []
    for ax in axes[0]:
        for h, l in zip(*ax.get_legend_handles_labels()):
            if l not in labels:
                handles.append(h); labels.append(l)
    fig.tight_layout(rect=(0, 0.1, 1, 1))
    fig.legend(handles, labels, loc="lower center", ncol=3, fontsize=8, bbox_to_anchor=(0.5, 0.0))
    _save(fig, out, "F2_t_vs_n")


# F3 ------------------------------------------------------------------------
def fig_ecdf(out: Path, run: Path, rows: list[dict], ns_per_tick: float):
    wanted = [("pos_leaky", "hot"), ("pos_twin", "hot"), ("ttable", "evicted"), ("ct", "evicted")]
    present = [(l, c) for l, c in wanted if (run / f"samples_{l}_{c}.csv").exists()]
    if not present:
        return
    fig, axes = plt.subplots(1, len(present), figsize=(3.6 * len(present), 3.3), squeeze=False)
    for ax, (label, cond) in zip(axes[0], present):
        df = pd.read_csv(run / f"samples_{label}_{cond}.csv")
        ns = df["ticks"].to_numpy(float) * ns_per_tick / df["B"].iloc[0]
        lo, hi = np.percentile(ns, [0.5, 99.5])
        for cls in ("fixed", "random"):
            x = np.sort(ns[(df["class"] == cls).to_numpy()])
            y = np.arange(1, len(x) + 1) / len(x)
            ax.step(x, y, where="post", color=CLASS_COLORS[cls], label=cls)
        r = next((r for r in rows if r["label"] == label and r["cond"] == cond), None)
        title = f"{label} · {cond}"
        if r:
            title += f"\n|t| = {r['abs_t']:.1f}"
        ax.set_title(title, fontsize=10)
        ax.set_xlim(lo, hi)
        ax.set_xlabel("ns per encryption")
    axes[0][0].set_ylabel("cumulative fraction")
    axes[0][0].legend(loc="lower right")
    fig.suptitle("F3  Timing distributions: fixed vs random input class", x=0.01, ha="left",
                 fontweight="bold", fontsize=11)
    fig.tight_layout()
    _save(fig, out, "F3_ecdf")


# F4 ------------------------------------------------------------------------
def fig_compiler(out: Path, rows: list[dict]):
    pairs = []
    for label in ("pos_leaky", "pos_twin", "ttable"):
        o2 = next((r for r in rows if r["label"] == label and r["cond"] == "hot"), None)
        o0 = next((r for r in rows if r["label"] == f"{label}@O0" and r["cond"] == "hot"), None)
        if o2 and o0:
            pairs.append((label, o0["abs_t"], o2["abs_t"]))
    if not pairs:
        return
    fig, ax = plt.subplots(figsize=(6.5, 3))
    for i, (label, t0, t2) in enumerate(pairs):
        ax.plot([t0, t2], [i, i], color=GRID, lw=3, zorder=1)
        ax.plot(t0, i, "o", ms=9, color="#8a8984", mec=SURFACE, mew=2, zorder=2, label="-O0" if i == 0 else None)
        ax.plot(t2, i, "o", ms=9, color=COLORS[label], mec=SURFACE, mew=2, zorder=3, label="-O2" if i == 0 else None)
    ax.axvline(4.5, color=THRESH, lw=1.2, ls=(0, (4, 3)))
    ax.set_xscale("log")
    ax.set_yticks(range(len(pairs)), [NAMES[p[0]] for p in pairs])
    ax.set_xlabel("|Welch t| (log), hot cache")
    ax.set_title("F4  Same source, two compilations: -O0 vs -O2")
    ax.legend(loc="lower right")
    ax.grid(axis="y", visible=False)
    _save(fig, out, "F4_compiler")


# F5 ------------------------------------------------------------------------
def fig_profiles(out: Path, profiles: dict):
    keys = [k for k in ("ttable|evicted", "ct|evicted") if k in profiles]
    if not keys:
        return
    fig, axes = plt.subplots(1, len(keys), figsize=(5.2 * len(keys), 4.6), squeeze=False)
    from matplotlib.colors import LinearSegmentedColormap
    cmap = LinearSegmentedColormap.from_list("div", ["#1c5cab", "#86b6ef", "#f0efec", "#ef9b99", "#b8302f"])
    for ax, k in zip(axes[0], keys):
        m = np.array(profiles[k]["mean_ns"], dtype=float)
        # Centre on the median bin: a few outlier-dominated bins must not shift the whole map.
        dev = (m - np.nanmedian(m)).reshape(16, 16)
        lim = np.nanpercentile(np.abs(dev), 98)
        im = ax.imshow(dev, cmap=cmap, vmin=-lim, vmax=lim)
        ax.set_xticks(range(16), [f"{i:x}" for i in range(16)])
        ax.set_yticks(range(16), [f"{i:x}" for i in range(16)])
        ax.set_xlabel("low nibble of p0"); ax.set_ylabel("high nibble of p0")
        ax.grid(False)
        impl, cond = k.split("|")
        ax.set_title(f"{impl} · {cond}  (n = {profiles[k]['n']:,})", fontsize=10)
        cb = fig.colorbar(im, ax=ax, shrink=0.8)
        cb.set_label("bin mean − median of bin means (ns)", color=INK2)
    fig.suptitle("F5  Mean encryption time by plaintext byte p0", x=0.01, ha="left", fontweight="bold", fontsize=11)
    fig.tight_layout()
    _save(fig, out, "F5_profile")


def make_all(run: Path, rows: list[dict], curves: dict, bench: dict, profiles: dict):
    import json
    _style()
    ns_per_tick = json.loads((run / "metadata.json").read_text())["platform"]["ns_per_tick"]
    out = run / "figures"
    fig_performance(out, bench)
    fig_t_vs_n(out, curves)
    fig_ecdf(out, run, rows, ns_per_tick)
    fig_compiler(out, rows)
    fig_profiles(out, profiles)
