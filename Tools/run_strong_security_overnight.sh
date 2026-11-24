#!/bin/zsh
set -u
SCRIPT_DIR=${0:A:h}
OUTPUT_DIR=${1:-"$SCRIPT_DIR/../SecurityResults/strong-overnight"}
mkdir -p "$OUTPUT_DIR"
python3 "$SCRIPT_DIR/build_strong_security_sweep.py" "$OUTPUT_DIR/bin" || exit 1
# Exit 2 means a leakage finding; exit 3 means the time limit stopped a trial.
# Both still produce a report. Repeating this command resumes completed trials.
caffeinate -i "$OUTPUT_DIR/bin/strong_security_sweep" --out "$OUTPUT_DIR" --fixtures 64 --hours 8 --challenge 32768 --confirm 16384 >> "$OUTPUT_DIR/run.log" 2>&1
RUN_STATUS=$?
if [[ -f "$OUTPUT_DIR/results.jsonl" ]]; then
  python3 "$SCRIPT_DIR/analyze_strong_security_sweep.py" "$OUTPUT_DIR"
fi
exit "$RUN_STATUS"
