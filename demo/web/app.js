/* AES Under the Microscope — dashboard logic.
 * Every number on screen comes from the C++ binary: streamed LIVE through
 * demo/server.py, or REPLAYED from a recorded run's dashboard.json. */
"use strict";

// Count uncaught errors on <html data-js-errors> so automated tests can assert a clean page.
const noteError = () => { const d = document.documentElement.dataset; d.jsErrors = String(+(d.jsErrors || 0) + 1); };
addEventListener("error", noteError);
addEventListener("unhandledrejection", noteError);

/* ================================================================ helpers */
const $ = (s) => document.querySelector(s);
const $$ = (s) => [...document.querySelectorAll(s)];
const css = (v) => getComputedStyle(document.documentElement).getPropertyValue(v).trim();
const hex2 = (v) => v.toString(16).padStart(2, "0");
const bytesOf = (h) => h.match(/../g).map((b) => parseInt(b, 16));
const toHex = (bytes) => bytes.map(hex2).join("");
const isHex = (s, n) => new RegExp(`^[0-9a-f]{${n}}$`).test(s);
const THRESHOLD = 4.5;
const PANELS = ["explorer", "speed", "race", "heist", "heatmap", "compiler", "scorecard"];

const ENTITY = {
  pos_leaky:  { name: "Injected branch", c: "--c-leaky" },
  aa_control: { name: "A/A control", c: "--c-aa", dash: [8, 6] },
  ref:        { name: "Textbook", c: "--c-ref" },
  ttable:     { name: "T-table", c: "--c-ttable" },
  ct:         { name: "Constant-time", c: "--c-ct" },
  armv8:      { name: "Hardware AES", c: "--c-armv8" },
  openssl:    { name: "OpenSSL", c: "--c-openssl" },
};
const RACE = ["pos_leaky", "aa_control", "ttable", "ct", "armv8", "openssl"];
const SPEED = ["armv8", "openssl", "ttable", "ref", "ct"];

const REDUCED = new URLSearchParams(location.search).has("capture") || matchMedia("(prefers-reduced-motion: reduce)").matches;
const state = { dash: null, panel: "explorer", cond: "hot", target: "leaky", es: null, replayTimer: null };

async function getJSON(url) {
  const r = await fetch(url);
  const body = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(body.message || r.statusText);
  return body;
}

function toast(msg, ms = 3200) {
  const t = Object.assign(document.createElement("div"), { className: "toast glass", textContent: msg });
  $("#stage").appendChild(t);
  setTimeout(() => t.remove(), ms);
}

function setMode(live, text) {
  $("#mode").classList.toggle("live", live);
  $("#modeText").textContent = text;
}
const replayText = () => (state.dash ? `Replay · ${state.dash.run_dir}` : "No recorded run");

/* Slide a segmented control's glass thumb under its active button. */
function syncThumb(group) {
  const on = group.querySelector("button.on"), thumb = group.querySelector(".thumb");
  if (!on || !thumb || !on.offsetWidth) return;
  thumb.style.width = `${on.offsetWidth}px`;
  thumb.style.transform = `translateX(${on.offsetLeft}px)`;
}
function selectIn(group, btn) {
  group.querySelectorAll("button").forEach((b) => b.classList.toggle("on", b === btn));
  syncThumb(group);
}

function fitStage() {
  const s = Math.min(innerWidth / 1920, innerHeight / 1080);
  const st = $("#stage");
  st.style.transform = `scale(${s})`;
  st.style.left = `${(innerWidth - 1920 * s) / 2}px`;
  st.style.top = `${(innerHeight - 1080 * s) / 2}px`;
}

function showPanel(name) {
  state.panel = name;
  $$(".panel").forEach((p) => p.classList.toggle("on", p.id === `panel-${name}`));
  selectIn($("#tabs"), $(`#tabs button[data-panel="${name}"]`));
  requestAnimationFrame(() => $$(`#panel-${name} .seg-ctl`).forEach(syncThumb));
}

function stopStream() {
  if (state.es) { state.es.close(); state.es = null; fetch("/api/stop").catch(() => {}); }
  $("#raceLive").textContent = "Run live";
}

/* ================================================================ 1 · Encrypt */
const STEP_TEXT = {
  input: "The 16 plaintext bytes fill the 4×4 state column by column.",
  AddRoundKey: "Each byte is XORed with the round key: addition in GF(2⁸).",
  SubBytes: "Each byte becomes S(byte) = affine(byte⁻¹ in GF(2⁸)). The only non-linear step.",
  ShiftRows: "Row r rotates left by r positions, spreading every column across all four.",
  MixColumns: "Each column is multiplied by a fixed MDS matrix over GF(2⁸): one byte affects four.",
};
const explorer = { trace: null, i: 0, timer: null };

function textToHex(txt) {
  const out = new Uint8Array(16).fill(0x20);
  out.set(new TextEncoder().encode(txt).slice(0, 16));
  return toHex([...out]);
}

function renderStep(i) {
  const t = explorer.trace;
  if (!t) return;
  explorer.i = Math.max(0, Math.min(t.steps.length - 1, i));
  const st = t.steps[explorer.i];
  const cur = st.state.match(/../g);
  const prev = explorer.i ? t.steps[explorer.i - 1].state.match(/../g) : cur;
  const cells = $("#matrix").children;
  for (let r = 0; r < 4; r++) for (let c = 0; c < 4; c++) {   // state is column-major: byte r + 4c
    const k = r + 4 * c, el = cells[r * 4 + c];
    el.textContent = cur[k];
    el.classList.toggle("changed", explorer.i > 0 && cur[k] !== prev[k]);
  }
  $("#stepRound").textContent = `Round ${st.round}`;
  $("#stepName").textContent = st.step === "input" ? "Input" : st.step;
  $("#stepDesc").textContent = STEP_TEXT[st.step] + (st.round === 10 && st.step === "ShiftRows" ? " The final round skips MixColumns." : "");
  $$("#track .ticks span").forEach((s, j) => { s.classList.toggle("on", j === explorer.i); s.classList.toggle("done", j < explorer.i); });
  $$("#rkList div").forEach((d, j) => d.classList.toggle("on", st.step === "AddRoundKey" && j === st.round));
}

function play(on) {
  clearInterval(explorer.timer);
  explorer.timer = null;
  $("#playBtn").textContent = on ? "Pause" : "Play";
  if (!on || !explorer.trace) return;
  if (explorer.i >= explorer.trace.steps.length - 1) renderStep(0);
  explorer.timer = setInterval(() => (explorer.i >= explorer.trace.steps.length - 1 ? play(false) : renderStep(explorer.i + 1)), 650);
}

function buildTrack(steps) {
  const byRound = {};
  steps.forEach((s, j) => (byRound[s.round] ||= []).push(j));
  $("#track").innerHTML = Object.entries(byRound).map(([r, js]) =>
    `<div class="grp"><div class="ticks">${js.map((j) => `<span data-j="${j}" title="${steps[j].step}"></span>`).join("")}</div><b>${r}</b></div>`).join("");
  $$("#track span").forEach((s) => (s.onclick = () => { play(false); renderStep(+s.dataset.j); }));
}

function readInputs() {
  const key = $("#keyHex").value.trim().toLowerCase();
  if (!isHex(key, 32)) { toast("The key must be 32 hex digits"); return null; }
  return { key, pt: textToHex($("#ptText").value) };
}

async function encrypt() {
  const inp = readInputs();
  if (!inp) return;
  try {
    const t = await getJSON(`/api/trace?pt=${inp.pt}&key=${inp.key}`);
    explorer.trace = t;
    $("#ptHex").textContent = t.plaintext;
    $("#ctHex").textContent = t.ciphertext;
    $("#rkList").innerHTML = t.round_keys.map((k, r) => `<div><b>k${r}</b>${k}</div>`).join("");
    buildTrack(t.steps);
    renderStep(0);
    play(true);
  } catch (e) { toast(`Encryption failed: ${e.message}`); }
}

async function avalanche() {
  const inp = readInputs();
  if (!inp) return;
  const bit = Math.floor(Math.random() * 128);
  const flipped = bytesOf(inp.pt);
  flipped[bit >> 3] ^= 0x80 >> (bit & 7);
  try {
    const [a, b] = await Promise.all([inp.pt, toHex(flipped)].map((pt) => getJSON(`/api/trace?pt=${pt}&key=${inp.key}`)));
    const ca = bytesOf(a.ciphertext), cb = bytesOf(b.ciphertext);
    let n = 0;
    [...$("#avGrid").children].forEach((cell, i) => {
      const d = ((ca[i >> 3] ^ cb[i >> 3]) >> (7 - (i & 7))) & 1;
      n += d;
      cell.classList.remove("flip");
      setTimeout(() => cell.classList.toggle("flip", !!d), REDUCED ? 0 : 5 * i);
    });
    $("#avPct").textContent = `${Math.round((100 * n) / 128)}%`;
    toast(`Plaintext bit ${bit} flipped: ${n} of 128 ciphertext bits changed`);
  } catch (e) { toast(`Encryption failed: ${e.message}`); }
}

async function loadSelftest() {
  const el = $("#selftest");
  try {
    const sum = (await getJSON("/api/selftest")).find((r) => r.type === "selftest_summary");
    el.innerHTML = sum.ok
      ? `<b class="ok">✓</b> ${sum.checks} known-answer checks pass`
      : `<b class="bad">✕</b> Self-test failed: measurements are disabled`;
  } catch { el.textContent = "Self-test unavailable"; }
}

/* ================================================================ 2 · Speed */
const LOG_MIN = 0, LOG_MAX = 4;  // 1 ns .. 10 µs
const logPos = (ns) => (100 * (Math.log10(ns) - LOG_MIN)) / (LOG_MAX - LOG_MIN);
const fmtNs = (ns) => (ns >= 1000 ? `${(ns / 1000).toFixed(2)}<small>µs</small>` : `${ns.toFixed(1)}<small>ns</small>`);

function buildSpeed() {
  $("#speedRows").innerHTML = SPEED.map((k) => `
    <div class="speed-row" data-k="${k}">
      <div class="who"><i style="background:var(${ENTITY[k].c})"></i>${ENTITY[k].name}</div>
      <div class="lane"><div class="bead" style="background:var(${ENTITY[k].c})"></div></div>
      <div class="num">–</div>
    </div>`).join("");
  $("#speedScale").innerHTML = ["1 ns", "10 ns", "100 ns", "1 µs", "10 µs"]
    .map((l, i) => `<span style="left:${i * 25}%">${l}</span>`).join("") + "<em>← faster · log scale · slower →</em>";
}

function renderSpeed(bench, live) {
  const by = Object.fromEntries(bench.map((b) => [b.impl, b]));
  SPEED.forEach((k, i) => {
    const b = by[k], row = $(`.speed-row[data-k="${k}"]`);
    if (!b) return;
    const bead = row.querySelector(".bead");
    bead.style.left = "100%";
    setTimeout(() => (bead.style.left = `${logPos(b.latency_ns_median)}%`), REDUCED ? 0 : 80 + 130 * i);
    row.querySelector(".num").innerHTML = `${b.latency_ns_median.toFixed(1)} ns<small>${Math.round(b.throughput_1m_MBps).toLocaleString()} MB/s</small>`;
  });
  const present = SPEED.filter((k) => by[k]).map((k) => by[k]);
  const fast = present.reduce((a, b) => (b.latency_ns_median < a.latency_ns_median ? b : a));
  const slow = present.reduce((a, b) => (b.latency_ns_median > a.latency_ns_median ? b : a));
  $("#statFast").innerHTML = fmtNs(fast.latency_ns_median);
  $("#statFastL").textContent = `Fastest: ${ENTITY[fast.impl].name}`;
  $("#statSlow").innerHTML = fmtNs(slow.latency_ns_median);
  $("#statSlowL").textContent = `Slowest: ${ENTITY[slow.impl].name}`;
  if (by.armv8 && by.ct) $("#statRatio").innerHTML = `${Math.round(by.ct.latency_ns_median / by.armv8.latency_ns_median)}<small>× faster</small>`;
  $("#speedSource").textContent = live ? "Latency per block · measured just now" : "Latency per block · recorded run";
}

async function measureSpeed() {
  const btn = $("#benchBtn");
  btn.disabled = true;
  btn.textContent = "Measuring…";
  try {
    renderSpeed((await getJSON("/api/bench")).filter((r) => r.type === "bench"), true);
    setMode(true, "Live · this Mac");
  } catch (e) { toast(`Benchmark failed: ${e.message}`); }
  btn.disabled = false;
  btn.textContent = "Measure now";
}

/* ================================================================ charts */
let raceChart, guessChart, rankChart;

function axis(title, extra = {}) {
  return {
    grid: { color: css("--hairline") }, border: { display: false },
    ticks: { color: css("--label-3"), font: { size: 15 }, ...extra.ticks },
    title: { display: !!title, text: title, color: css("--label-2"), font: { size: 16, weight: 600 } },
    ...extra.scale,
  };
}
// Log axes: draw ticks (and gridlines) only at the given values.
const fixedTicks = (values) => ({ afterBuildTicks: (ax) => { ax.ticks = values.filter((v) => v >= ax.min && v <= ax.max).map((value) => ({ value })); } });

const thresholdPlugin = {
  id: "threshold",
  beforeDatasetsDraw(chart) {
    const { ctx, chartArea: a, scales: { y } } = chart;
    const yT = y.getPixelForValue(THRESHOLD);
    ctx.save();
    ctx.fillStyle = css("--red") + "1f";
    ctx.fillRect(a.left, a.top, a.right - a.left, yT - a.top);
    ctx.strokeStyle = css("--red");
    ctx.globalAlpha = 0.8;
    ctx.setLineDash([8, 6]);
    ctx.lineWidth = 2;
    ctx.beginPath(); ctx.moveTo(a.left, yT); ctx.lineTo(a.right, yT); ctx.stroke();
    ctx.globalAlpha = 1;
    ctx.fillStyle = css("--label-2");
    ctx.font = "600 15px -apple-system, sans-serif";
    ctx.fillText("Leakage threshold  |t| = 4.5", a.left + 14, yT - 10);
    ctx.restore();
  },
};

function makeCharts() {
  Chart.defaults.font.family = "-apple-system, BlinkMacSystemFont, sans-serif";
  Chart.defaults.animation = false;
  [raceChart, guessChart, rankChart].forEach((c) => c?.destroy());
  const tooltip = { backgroundColor: css("--glass-strong"), titleColor: css("--label"), bodyColor: css("--label"), padding: 12, cornerRadius: 12, borderColor: css("--hairline"), borderWidth: 1 };

  raceChart = new Chart($("#raceChart"), {
    type: "line",
    data: { datasets: RACE.map((k) => ({ key: k, label: ENTITY[k].name, data: [], borderColor: css(ENTITY[k].c), backgroundColor: css(ENTITY[k].c),
      borderWidth: 3, borderDash: ENTITY[k].dash || [], pointRadius: 0, tension: 0.15 })) },
    options: {
      maintainAspectRatio: false, parsing: false, normalized: true,
      interaction: { mode: "nearest", axis: "x", intersect: false },
      layout: { padding: { top: 8, right: 8 } },
      scales: {
        x: axis("Samples per implementation", { scale: { type: "logarithmic", min: 200, max: 1e6, ...fixedTicks([1e3, 1e4, 1e5, 1e6]) }, ticks: { maxRotation: 0, callback: (v) => Number(v).toLocaleString() } }),
        y: axis("", { scale: { type: "logarithmic", min: 0.05, max: 1000, ...fixedTicks([0.1, 1, 10, 100, 1000]) }, ticks: { callback: (v) => String(v) } }),
      },
      plugins: {
        legend: { position: "bottom", labels: { color: css("--label-2"), font: { size: 15 }, boxWidth: 22, boxHeight: 4, padding: 18 } },
        tooltip: { ...tooltip, callbacks: { label: (c) => ` ${c.dataset.label}: |t| ${c.parsed.y.toFixed(2)} at ${c.parsed.x.toLocaleString()}` } },
      },
    },
    plugins: [thresholdPlugin],
  });

  guessChart = new Chart($("#guessChart"), {
    type: "bar",
    data: { labels: [...Array(256).keys()].map((g) => `0x${hex2(g)}`),
            datasets: [{ data: new Array(256).fill(0), backgroundColor: css("--label-3"), borderRadius: 2, categoryPercentage: 1, barPercentage: 0.75 }] },
    options: {
      maintainAspectRatio: false, animation: { duration: 220 },
      scales: {
        x: axis("Key-byte guess", { ticks: { maxRotation: 0, autoSkip: true, maxTicksLimit: 17 } }),
        y: axis("Correlation with timing", { scale: { min: -0.4, max: 1.05 }, ticks: { stepSize: 0.2, callback: (v) => (v > 1.01 ? "" : Number(v).toFixed(1)) } }),
      },
      plugins: { legend: { display: false }, tooltip: { ...tooltip, callbacks: { label: (c) => ` score ${c.parsed.y.toFixed(3)}` } } },
    },
  });

  rankChart = new Chart($("#rankChart"), {
    type: "line",
    data: { datasets: [{ data: [], borderColor: css("--blue"), borderWidth: 3, pointRadius: 0, tension: 0.1 }] },
    options: {
      maintainAspectRatio: false, parsing: false,
      scales: {
        x: axis("", { scale: { type: "linear" }, ticks: { maxTicksLimit: 5, callback: (v) => `${v / 1000}k` } }),
        y: axis("", { scale: { type: "logarithmic", reverse: true, min: 1, max: 256, ...fixedTicks([1, 16, 256]) }, ticks: { callback: (v) => String(v) } }),
      },
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
    },
  });
}

/* ================================================================ 3 · Leakage */
function verdictOf(t) {
  const a = Math.abs(t);
  if (a > THRESHOLD) return ["leak", "Leak detected"];
  if (a > 3) return ["warn", "Approaching"];
  return ["", "No evidence"];
}

function buildBadges() {
  $("#badges").innerHTML = RACE.map((k) => `
    <div class="list-row" data-k="${k}">
      <span class="sw" style="background:var(${ENTITY[k].c})"></span><span>${ENTITY[k].name}</span>
      <span class="val">–</span><span class="tag">Waiting</span>
    </div>`).join("");
}

function updateBadge(k, t) {
  const row = $(`#badges [data-k="${k}"]`);
  if (!row) return;
  const [cls, text] = verdictOf(t), tag = row.querySelector(".tag");
  if (tag.dataset.cls !== cls) {
    tag.className = `tag ${cls}`;
    tag.dataset.cls = cls;
    void tag.offsetWidth;
    tag.classList.add("pop");
  }
  tag.textContent = text;
  row.querySelector(".val").textContent = `|t| ${Math.abs(t).toFixed(2)}`;
}

function resetRace(minN, maxN) {
  clearInterval(state.replayTimer);
  raceChart.data.datasets.forEach((d) => (d.data = []));
  Object.assign(raceChart.options.scales.x, { min: minN, max: maxN });
  raceChart.update();
  buildBadges();
  $("#raceN").textContent = "0";
}

let drawQueued = false;
function drawRaceSoon() {
  if (drawQueued) return;
  drawQueued = true;
  requestAnimationFrame(() => { drawQueued = false; raceChart.update("none"); });
}

function raceLive() {
  if (state.es) return stopStream();
  const hot = state.cond === "hot";
  resetRace(hot ? 5000 : 2000, hot ? 300000 : 80000);
  setMode(true, "Live · illustrative");
  const es = new EventSource(`/api/stream/race?cond=${state.cond}`);
  state.es = es;
  $("#raceLive").textContent = "Stop";
  es.onmessage = (ev) => {
    const m = JSON.parse(ev.data);
    if (m.type === "error") { toast(m.message); return stopStream(); }
    if (m.type !== "tstat") return;
    raceChart.data.datasets.find((d) => d.key === m.label)?.data.push({ x: m.n, y: Math.max(Math.abs(m.t), 0.05) });
    updateBadge(m.label, m.t);
    $("#raceN").textContent = m.n.toLocaleString();
    drawRaceSoon();
  };
  es.addEventListener("end", () => { stopStream(); toast("Live run complete"); });
  es.onerror = () => { if (state.es) { stopStream(); toast("Live stream unavailable: press R to replay the recorded run"); } };
}

function raceReplay() {
  stopStream();
  if (!state.dash) return toast("No recorded run yet: run scripts/collect.sh");
  const curves = RACE.map((k) => ({ k, c: state.dash.curves[`${k}|${state.cond}`] })).filter((x) => x.c);
  if (!curves.length) return toast(`The recorded run has no ${state.cond}-cache data`);
  const maxN = Math.max(...curves.map((x) => x.c.n.at(-1)));
  resetRace(200, maxN);
  setMode(false, replayText());
  const frames = REDUCED ? 1 : 110;
  let f = 0;
  state.replayTimer = setInterval(() => {
    f++;
    const nNow = f >= frames ? Infinity : Math.exp(Math.log(200) + (Math.log(maxN / 200) * f) / frames);
    curves.forEach(({ k, c }) => {
      const pts = [];
      for (let i = 0; i < c.n.length && c.n[i] <= nNow; i++) pts.push({ x: c.n[i], y: Math.max(Math.abs(c.t[i]), 0.05) });
      raceChart.data.datasets.find((d) => d.key === k).data = pts;
      if (pts.length) updateBadge(k, c.t[pts.length - 1]);
    });
    $("#raceN").textContent = (f >= frames ? maxN : Math.round(nNow)).toLocaleString();
    raceChart.update("none");
    if (f >= frames) clearInterval(state.replayTimer);
  }, 70);
}

/* ================================================================ 4 · Attack */
function resetHeist() {
  guessChart.data.datasets[0].data = new Array(256).fill(0);
  guessChart.data.datasets[0].backgroundColor = css("--label-3");
  guessChart.update();
  rankChart.data.datasets[0].data = [];
  rankChart.update();
  $("#heistN").textContent = "0";
  $("#reveal").className = "reveal";
  $("#reveal").textContent = "Listening to timings…";
}

function showGuesses(m, reveal) {
  $("#heistN").textContent = m.n.toLocaleString();
  rankChart.data.datasets[0].data.push({ x: m.n, y: m.true_rank });
  rankChart.update("none");
  const ds = guessChart.data.datasets[0];
  ds.data = m.scores;
  ds.backgroundColor = m.scores.map((_, g) => (reveal && g === m.true_byte ? css("--red") : g === m.best_guess ? css("--blue") : css("--label-3")));
  guessChart.update();
  const el = $("#reveal");
  if (!reveal) { el.innerHTML = `Best guess so far<span class="big">0x${hex2(m.best_guess)}</span>`; return; }
  const hit = m.best_guess === m.true_byte;
  el.className = `reveal ${hit ? "found" : "miss"}`;
  el.innerHTML = hit
    ? `<span class="big">0x${hex2(m.true_byte).toUpperCase()} ✓</span>Recovered from timing alone`
    : `<span class="big">Not found</span>The secret was 0x${hex2(m.true_byte).toUpperCase()}, ranked ${m.true_rank} of 256`;
}

function heistRun() {
  stopStream();
  const kb = $("#secretByte").value.trim().toLowerCase();
  if (!isHex(kb, 2)) return toast("Type the secret as two hex digits, e.g. a7");
  resetHeist();
  setMode(true, state.target === "leaky" ? "Live · injected leak" : "Live · constant-time");
  const es = new EventSource(`/api/stream/recover?target=${state.target}&key=${kb}`);
  state.es = es;
  es.onmessage = (ev) => {
    const m = JSON.parse(ev.data);
    if (m.type === "error") { toast(m.message); return stopStream(); }
    if (m.type === "recover" || m.type === "recover_result") showGuesses(m, m.type === "recover_result");
  };
  es.addEventListener("end", () => { es.close(); state.es = null; });
  es.onerror = () => { if (state.es) { es.close(); state.es = null; heistReplay(); } };
}

function heistReplay() {
  const rec = state.dash?.recover?.[state.target];
  if (!rec) return toast("No recorded attack available");
  toast("Live attack unavailable: replaying the recorded run");
  setMode(false, replayText());
  resetHeist();
  let i = REDUCED ? rec.n_trace.length : 0;
  if (REDUCED) rec.n_trace.forEach((n, j) => rankChart.data.datasets[0].data.push({ x: n, y: rec.rank_trace[j] }));
  const timer = setInterval(() => {
    if (i < rec.n_trace.length) {
      $("#heistN").textContent = rec.n_trace[i].toLocaleString();
      rankChart.data.datasets[0].data.push({ x: rec.n_trace[i], y: rec.rank_trace[i] });
      rankChart.update("none");
      i++;
      return;
    }
    clearInterval(timer);
    rankChart.data.datasets[0].data.pop();
    showGuesses({ n: rec.n_trace.at(-1), true_rank: rec.rank_trace.at(-1), scores: rec.scores, best_guess: rec.best_guess, true_byte: rec.true_byte }, true);
  }, 80);
}

/* ================================================================ 5 · Profile */
// Parse a CSS colour (hex or rgba) into [r, g, b, a] using the browser itself.
function parseColour(c) {
  const probe = document.createElement("i");
  probe.style.color = c;
  document.body.appendChild(probe);
  const v = getComputedStyle(probe).color.match(/[\d.]+/g).map(Number);
  probe.remove();
  return [v[0], v[1], v[2], v[3] ?? 1];
}
const mix = (p, q, t) => `rgba(${p.map((v, i) => (i < 3 ? Math.round(v + (q[i] - v) * t) : (v + (q[i] - v) * t).toFixed(3))).join(",")})`;

function renderHeatmap(grid, title, prof, label) {
  grid.innerHTML = "";
  if (!prof) { title.textContent = `${label} · not in recorded run`; return; }
  const m = prof.mean_ns.map((v) => (v === null ? NaN : v));
  const valid = m.filter((v) => !isNaN(v)).sort((a, b) => a - b);
  const centre = valid[valid.length >> 1];                    // median bin: robust to outlier bins
  const dev = m.map((v) => v - centre);
  const abs = dev.filter((v) => !isNaN(v)).map(Math.abs).sort((a, b) => a - b);
  const lim = abs[Math.floor(abs.length * 0.98)] || 1;
  const [hot, mid, cold] = ["--hm-hot", "--hm-mid", "--hm-cold"].map((v) => parseColour(css(v)));
  dev.forEach((d, p0) => {
    const t = Math.max(-1, Math.min(1, d / lim));
    const cell = document.createElement("div");
    cell.style.background = isNaN(d) ? mix(mid, mid, 0) : mix(mid, t > 0 ? hot : cold, Math.abs(t));
    cell.title = `byte 0x${hex2(p0)}: ${d >= 0 ? "+" : ""}${d.toFixed(2)} ns vs median`;
    grid.appendChild(cell);
  });
  title.textContent = `${label} · ${prof.n.toLocaleString()} samples`;
  $("#hmPerCell").textContent = `≈ ${Math.round(prof.n / 256).toLocaleString()}`;
}

function renderHeatmaps() {
  const p = state.dash?.profiles || {};
  renderHeatmap($("#hmA"), $("#hmTitleA"), p["ttable|evicted"], "T-table");
  renderHeatmap($("#hmB"), $("#hmTitleB"), p["ct|evicted"], "Constant-time");
}

/* ================================================================ 6 · Assembly */
const SECRET_BRANCH = /\b(tbnz|tbz|b\.(ge|lt|hs|lo|gt|le|hi|ls))\b/;
const MASK_OPS = /\b(bic|csel|neg)\b/;
function codeHTML(lines, mark) {
  return lines.map((l) => {
    const esc = l.replace(/&/g, "&amp;").replace(/</g, "&lt;");
    const cls = mark(l);
    return cls ? `<span class="${cls}">${esc}</span>` : esc;
  }).join("\n");
}
const markSource = (l) => (/if \(s < 0x80\)/.test(l) ? "hl" : /mask/.test(l) ? "ok" : "");

function tagFor(el, label) {
  const r = state.dash?.final?.find((x) => x.label === label && x.cond === "hot");
  if (!r) { el.textContent = "no data"; el.className = "tag mini"; return; }
  el.textContent = `|t| ${Math.abs(r.t).toFixed(2)}`;
  el.className = `tag mini ${verdictOf(r.t)[0]}`;
}

async function loadAssembly() {
  try {
    const a = await getJSON("/api/asm");
    $("#srcCode").innerHTML = codeHTML(a.source, markSource);
    $("#twinCode").innerHTML = codeHTML(a.twin_source, markSource);
    $("#o0Code").innerHTML = codeHTML(a.O0, (l) => (SECRET_BRANCH.test(l) ? "hl" : ""));
    $("#o2Code").innerHTML = codeHTML(a.O2, (l) => (SECRET_BRANCH.test(l) ? "hl" : ""));
    $("#twinAsm").innerHTML = codeHTML(a.twin_O2.slice(0, 11), (l) => (MASK_OPS.test(l) ? "ok" : ""));
  } catch (e) { $("#srcCode").textContent = `Assembly unavailable (${e.message}): run scripts/asm.sh`; }
  tagFor($("#o0Badge"), "pos_leaky@O0");
  tagFor($("#o2Badge"), "pos_leaky");
  tagFor($("#twinBadge"), "pos_twin");
}

/* ================================================================ 7 · Verdict */
function renderVerdict() {
  const hs = state.dash?.hypotheses || [];
  const label = { supported: ["ok", "✓ Supported"], "not supported": ["leak", "✕ Not supported"], inconclusive: ["warn", "? Inconclusive"] };
  $("#scores").innerHTML = hs.length ? hs.map((h) => `
    <div class="score-row">
      <div class="hid">${h.id}</div>
      <div><div class="t">${h.title}</div><div class="e">${h.evidence}</div></div>
      <span class="tag ${label[h.verdict][0]}">${label[h.verdict][1]}</span>
    </div>`).join("") : `<div class="score-row"><div></div><div class="t">No analysed run found: run scripts/collect.sh</div><div></div></div>`;
  const m = state.dash?.metadata;
  $("#runInfo").textContent = m ? `${state.dash.run_dir} · ${m.cpu} · ${m.os} · ${m.opt_flags}` : "";
}

/* ================================================================ boot */
function applyTheme(theme) {
  document.documentElement.dataset.theme = theme;
  try { localStorage.setItem("aes-theme", theme); } catch { /* storage may be unavailable */ }
  makeCharts();
  buildBadges();
  renderHeatmaps();
}

function bindControls() {
  $$("#tabs button").forEach((b) => (b.onclick = () => showPanel(b.dataset.panel)));
  $("#encryptBtn").onclick = encrypt;
  $("#flipBtn").onclick = avalanche;
  $("#playBtn").onclick = () => play(!explorer.timer);
  $("#ptText").onkeydown = (e) => e.key === "Enter" && encrypt();
  $("#benchBtn").onclick = measureSpeed;
  $("#raceLive").onclick = raceLive;
  $("#raceReplay").onclick = raceReplay;
  $("#heistBtn").onclick = heistRun;
  $("#secretByte").onkeydown = (e) => e.key === "Enter" && heistRun();
  $("#themeBtn").onclick = () => applyTheme(document.documentElement.dataset.theme === "dark" ? "light" : "dark");
  $$("#condSeg button").forEach((b) => (b.onclick = () => { selectIn($("#condSeg"), b); state.cond = b.dataset.cond; stopStream(); resetRace(200, 1e6); }));
  $$("#targetSeg button").forEach((b) => (b.onclick = () => { selectIn($("#targetSeg"), b); state.target = b.dataset.target; }));

  document.addEventListener("keydown", (e) => {
    if (e.target.tagName === "INPUT") return;
    const k = e.key.toLowerCase();
    if (k >= "1" && k <= "7") showPanel(PANELS[+k - 1]);
    else if (k === " ") {
      e.preventDefault();
      ({ race: raceLive, heist: heistRun, explorer: () => play(!explorer.timer) })[state.panel]?.();
    } else if (k === "r") { showPanel("race"); raceReplay(); }
    else if (k === "l") { showPanel("race"); if (!state.es) raceLive(); }
    else if (k === "t") $("#themeBtn").click();
    else if (k === "f") document.fullscreenElement ? document.exitFullscreen() : document.documentElement.requestFullscreen();
    else if (state.panel === "explorer" && (k === "arrowright" || k === "arrowleft")) { play(false); renderStep(explorer.i + (k === "arrowright" ? 1 : -1)); }
  });
  addEventListener("resize", () => { fitStage(); syncThumb($("#tabs")); });
}

async function boot() {
  let theme = "dark";
  try { theme = localStorage.getItem("aes-theme") || "dark"; } catch { /* ignore */ }
  document.documentElement.dataset.theme = new URLSearchParams(location.search).get("theme") || theme;
  if (REDUCED) document.documentElement.classList.add("reduced-motion");
  fitStage();
  $("#matrix").innerHTML = "<div></div>".repeat(16);
  $("#avGrid").innerHTML = "<div></div>".repeat(128);
  buildSpeed();
  makeCharts();
  buildBadges();
  bindControls();
  showPanel("explorer");

  try {
    state.dash = await getJSON("/api/dashboard");
    renderSpeed(state.dash.bench, false);
    renderHeatmaps();
  } catch (e) { toast(`No recorded run: ${e.message}`); }
  renderVerdict();
  setMode(false, replayText());
  loadSelftest();
  loadAssembly();
  await encrypt();

  // Deep links for rehearsal and screenshots: #race, #race-replay, #heist-replay, #explorer-avalanche …
  const [panel, action] = location.hash.slice(1).split("-");
  if (PANELS.includes(panel)) showPanel(panel);
  ({ "race-replay": raceReplay, "heist-replay": heistReplay, "explorer-avalanche": avalanche })[`${panel}-${action}`]?.();
  if (REDUCED) { play(false); renderStep(Math.min(13, explorer.trace?.steps.length - 1 || 0)); }
}

boot();
