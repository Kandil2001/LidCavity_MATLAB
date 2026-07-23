#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-single}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MATLAB_BIN="${MATLAB_BIN:-matlab}"

case "$MODE" in
  single|quick|medium|grid|re1000|full) ;;
  *)
    echo "Unknown mode: $MODE" >&2
    echo "Use: single, quick, medium, grid, re1000, or full" >&2
    exit 2
    ;;
esac

if ! command -v "$MATLAB_BIN" >/dev/null 2>&1; then
  echo "MATLAB executable not found: $MATLAB_BIN" >&2
  echo "Load the MATLAB module or set MATLAB_BIN to its executable." >&2
  exit 127
fi

mkdir -p "$ROOT/logs"
LOG="$ROOT/logs/matlab_${MODE}_$(date +%Y%m%d_%H%M%S).log"

echo "Project: $ROOT"
echo "Mode: $MODE"
echo "Log: $LOG"

"$MATLAB_BIN" -batch "cd('$ROOT'); run_mode('$MODE');" 2>&1 | tee "$LOG"
