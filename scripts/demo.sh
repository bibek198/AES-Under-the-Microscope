#!/usr/bin/env bash
# One-command demo.
#   scripts/demo.sh              build if needed, start the dashboard, open the browser
#   scripts/demo.sh --preflight  GO / NO-GO checks only
#   scripts/demo.sh --terminal   fallback: terminal-only demo (no browser)
set -uo pipefail
cd "$(dirname "$0")/.."
PORT=8765
G=$'\033[32m'; R=$'\033[31m'; Y=$'\033[33m'; B=$'\033[1m'; X=$'\033[0m'
FAIL=0
check() { # check "label" command...
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then printf "  ${G}GO${X}     %s\n" "$label"
  else printf "  ${R}NO-GO${X}  %s\n" "$label"; FAIL=1; fi
}
warn() { printf "  ${Y}WARN${X}   %s\n" "$1"; }

preflight() {
  echo "${B}Preflight${X}"
  check "binary built (build/aes_project)" test -x build/aes_project
  check "correctness self-test passes" build/aes_project test --json
  check "Chart.js vendored (offline)" test -s demo/web/vendor/chart.umd.min.js
  check "recorded run with dashboard.json" test -s results/latest/dashboard.json
  check "assembly listings present" test -s assembly/controls_O2.s
  check "port $PORT free" bash -c "! lsof -iTCP:$PORT -sTCP:LISTEN"
  check "python3 available" command -v python3
  if pmset -g batt | grep -q "AC Power"; then printf "  ${G}GO${X}     on AC power\n"; else warn "on battery: plug in the charger"; fi
  if pmset -g | grep -q "lowpowermode *1"; then warn "Low Power Mode is ON: turn it off"; else printf "  ${G}GO${X}     Low Power Mode off\n"; fi
  if networksetup -getairportpower en0 2>/dev/null | grep -q "On"; then warn "Wi-Fi is on (fine, but the demo is designed to run offline)"; fi
  if [[ $FAIL -eq 0 ]]; then echo "${G}${B}ALL GO${X}"; else echo "${R}${B}NO-GO: fix the items above${X}"; fi
  return $FAIL
}

terminal_demo() {
  local P="build/aes_project"
  pause() { read -r -p $'\n  [Enter] next step...' _; }
  clear; $P info; pause
  clear; $P test; pause
  clear; $P bench --quick; pause
  clear; $P race --cond hot --n 100000; pause
  clear; $P recover --target leaky --key-byte 3c; pause
  clear; $P recover --target ct --key-byte 3c --n 100000; pause
  clear; sed -n '1,20p' results/latest/summary.md
}

case "${1:-}" in
  --preflight) preflight; exit $? ;;
  --terminal) [[ -x build/aes_project ]] || scripts/build.sh; terminal_demo; exit 0 ;;
esac

[[ -x build/aes_project ]] || scripts/build.sh
[[ -s assembly/controls_O2.s ]] || scripts/asm.sh
preflight || { echo "Continuing anyway (fallbacks: R = replay, scripts/demo.sh --terminal)."; }
python3 demo/server.py --port "$PORT" &
SERVER=$!
trap 'kill $SERVER 2>/dev/null' EXIT INT TERM
sleep 1
open "http://127.0.0.1:$PORT"
echo "Dashboard running at http://127.0.0.1:$PORT. Press F in the browser for fullscreen, Ctrl-C here to stop."
caffeinate -d -w $SERVER
