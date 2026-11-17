#!/usr/bin/env python3
"""Local bridge between the dashboard (browser) and the C++ binary.

    python3 demo/server.py [--port 8765] [--run results/<id>]

* Standard library only; binds to 127.0.0.1 (never exposed on the network).
* The binary is always started with a fixed argument list (no shell), and
  every user-supplied value is validated (hex strings, enums, integers).
* Streaming endpoints use Server-Sent Events: each NDJSON line printed by the
  binary is forwarded unchanged as one event.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import threading
from http import HTTPStatus
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "demo" / "web"
BINARY = ROOT / "build" / "aes_project"
RESULTS = ROOT / "results"

HEX32 = re.compile(r"^[0-9a-fA-F]{32}$")
HEX2 = re.compile(r"^[0-9a-fA-F]{2}$")
RUN_ID = re.compile(r"^[A-Za-z0-9._-]{1,64}$")

_current = {"proc": None}
_lock = threading.Lock()


def resolve_run(run_id: str | None) -> Path | None:
    if run_id:
        if not RUN_ID.match(run_id):
            return None
        p = RESULTS / run_id
        return p if (p / "dashboard.json").exists() else None
    latest = RESULTS / "latest"
    if (latest / "dashboard.json").exists():
        return latest.resolve()
    runs = sorted((p for p in RESULTS.iterdir() if (p / "dashboard.json").exists()),
                  key=lambda p: p.stat().st_mtime, reverse=True) if RESULTS.exists() else []
    return runs[0] if runs else None


def extract_function(asm_path: Path, symbol: str) -> list[str]:
    """Returns the instructions of one function from a clang .s listing."""
    if not asm_path.exists():
        return []
    out, inside = [], False
    for line in asm_path.read_text().splitlines():
        if line.startswith(symbol + ":"):
            inside = True
            continue
        if inside:
            s = line.strip()
            if s.startswith(".cfi_endproc") or (s.startswith(".globl") and out):
                break
            if not s or s.startswith(";") or s.startswith(".cfi") or s.startswith(".p2align") or s.startswith("Lfunc_end"):
                continue
            out.append(line.split(";")[0].rstrip().replace("\t", "    "))
    return out


def source_snippet(path: Path, start_marker: str, end_marker: str) -> list[str]:
    lines = path.read_text().splitlines()
    out, inside = [], False
    for line in lines:
        if start_marker in line:
            inside = True
        if inside:
            out.append(line)
            if line.rstrip() == end_marker and len(out) > 1:
                break
    return out


class Handler(SimpleHTTPRequestHandler):
    server_version = "AESMicroscope/1.0"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB), **kwargs)

    def log_message(self, fmt, *args):  # quieter console: log API calls and errors only
        first = args[0] if args else ""
        if not isinstance(first, str) or "/api/" in first:
            sys.stderr.write("  " + (fmt % args) + "\n")

    # ------------------------------------------------------------------ helpers
    def send_json(self, obj, status=HTTPStatus.OK):
        body = json.dumps(obj).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def bad(self, msg):
        self.send_json({"type": "error", "message": msg}, HTTPStatus.BAD_REQUEST)

    def run_lines(self, args: list[str], timeout=120) -> list[dict]:
        proc = subprocess.run([str(BINARY), *args, "--json"], capture_output=True, text=True, timeout=timeout)
        return [json.loads(l) for l in proc.stdout.splitlines() if l.strip()]

    def stream(self, args: list[str]):
        """Run the binary and forward each NDJSON line as a Server-Sent Event."""
        with _lock:  # only one measurement at a time: concurrent runs would disturb each other
            prev = _current["proc"]
            if prev and prev.poll() is None:
                prev.kill()
            proc = subprocess.Popen([str(BINARY), *args, "--json"], stdout=subprocess.PIPE,
                                    stderr=subprocess.DEVNULL, text=True, bufsize=1)
            _current["proc"] = proc
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Connection", "keep-alive")
        self.end_headers()
        try:
            for line in proc.stdout:
                if line.strip():
                    self.wfile.write(f"data: {line.strip()}\n\n".encode())
                    self.wfile.flush()
            self.wfile.write(b"event: end\ndata: {}\n\n")
            self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError):
            pass  # browser went away: stop measuring
        finally:
            if proc.poll() is None:
                proc.kill()

    # ------------------------------------------------------------------ routes
    def do_GET(self):  # noqa: N802
        url = urlparse(self.path)
        q = {k: v[0] for k, v in parse_qs(url.query).items()}
        path = url.path
        if not path.startswith("/api/"):
            return super().do_GET()
        if not BINARY.exists():
            return self.send_json({"type": "error", "message": "binary not built: run scripts/build.sh"},
                                  HTTPStatus.SERVICE_UNAVAILABLE)
        try:
            if path == "/api/selftest":
                return self.send_json(self.run_lines(["test"]))
            if path == "/api/bench":
                return self.send_json(self.run_lines(["bench", "--quick"]))
            if path == "/api/trace":
                pt, key = q.get("pt", ""), q.get("key", "")
                if not (HEX32.match(pt) and HEX32.match(key)):
                    return self.bad("pt and key must be 32 hex digits")
                return self.send_json(self.run_lines(["trace", "--pt", pt, "--key", key])[0])
            if path == "/api/stream/race":
                cond = q.get("cond", "hot")
                if cond not in ("hot", "evicted"):
                    return self.bad("cond must be hot or evicted")
                n, every = ("300000", "5000") if cond == "hot" else ("80000", "2000")
                seed = q.get("seed", "1")
                if not seed.isdigit() or len(seed) > 9:
                    seed = "1"
                return self.stream(["race", "--cond", cond, "--n", n, "--every", every, "--seed", seed])
            if path == "/api/stream/recover":
                target, kb = q.get("target", "leaky"), q.get("key", "")
                if target not in ("leaky", "ct") or not HEX2.match(kb):
                    return self.bad("target must be leaky|ct and key a 2-digit hex byte")
                n = "60000" if target == "leaky" else "150000"
                return self.stream(["recover", "--target", target, "--key-byte", kb, "--n", n, "--stream"])
            if path == "/api/stop":
                with _lock:
                    p = _current["proc"]
                    if p and p.poll() is None:
                        p.kill()
                return self.send_json({"stopped": True})
            if path == "/api/dashboard":
                run = resolve_run(q.get("run"))
                if not run:
                    return self.send_json({"type": "error", "message": "no analysed run found: run scripts/collect.sh"},
                                          HTTPStatus.NOT_FOUND)
                data = json.loads((run / "dashboard.json").read_text())
                data["run_dir"] = run.name
                return self.send_json(data)
            if path == "/api/asm":
                asm = ROOT / "assembly"
                return self.send_json({
                    "source": source_snippet(ROOT / "src" / "controls.cpp", "uint32_t leaky_gate", "}"),
                    "twin_source": source_snippet(ROOT / "src" / "controls.cpp", "uint32_t twin_gate", "}"),
                    "O0": extract_function(asm / "controls_O0.s", "__ZN3aes10leaky_gateEh"),
                    "O2": extract_function(asm / "controls_O2.s", "__ZN3aes10leaky_gateEh"),
                    "twin_O2": extract_function(asm / "controls_O2.s", "__ZN3aes9twin_gateEh"),
                })
            return self.bad("unknown endpoint")
        except subprocess.TimeoutExpired:
            return self.send_json({"type": "error", "message": "measurement timed out"}, HTTPStatus.GATEWAY_TIMEOUT)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=8765)
    args = ap.parse_args()
    srv = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    srv.daemon_threads = True
    print(f"AES Under the Microscope dashboard: http://127.0.0.1:{args.port}  (Ctrl-C to stop)")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        p = _current["proc"]
        if p and p.poll() is None:
            p.kill()


if __name__ == "__main__":
    main()
