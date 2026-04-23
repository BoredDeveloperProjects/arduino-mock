#!/usr/bin/env bash
set -eu

cd -- "$(dirname -- "${0}")"

set +e
formatter_output="$(./codeformatter.sh 2>&1)"
formatter_exit_code=$?
set -e

printf '%s\n' "$formatter_output"

changed_count="$(printf '%s\n' "$formatter_output" | sed -n 's/^\[INFO\] clang-format changed \([0-9][0-9]*\) file(s)$/\1/p' | tail -n 1)"
if [ -z "$changed_count" ]; then
  changed_count=0
fi

echo "[INFO] Formatter changed $changed_count file(s) in this run"

if [ "$formatter_exit_code" -ne 0 ]; then
  exit "$formatter_exit_code"
fi

if ! git diff --quiet -- .; then
  echo
  echo "[ERROR] Formatting issues were found and auto-corrected ($changed_count file(s) changed)."
  echo "[INFO] The commit was stopped so you can review the formatting changes."
  echo "[INFO] Next steps:"
  echo "  1. Review the diff"
  echo "  2. Stage the updated files"
  echo "  3. Re-run the commit"
  echo
  echo "[INFO] Suggested commands:"
  echo "  git diff"
  echo "  git add ."
  echo '  git commit -m "your message"'
  echo
  echo "[INFO] Formatting diff:"
  git diff -- .
  exit 1
fi

echo "[INFO] Formatting OK ($changed_count file(s) changed)"

if git grep --cached -I $'\r'; then
  echo "Do not use CRLF. Use LF."
  exit 1
fi