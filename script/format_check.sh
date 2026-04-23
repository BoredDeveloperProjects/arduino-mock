#!/usr/bin/env bash
set -eu

cd -- "$(dirname -- "${0}")"

./codeformatter.sh

if ! git diff --quiet -- .; then
  echo
  echo "[ERROR] Formatting issues were found and auto-corrected."
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

echo "[INFO] Formatting OK"

if git grep --cached -I $'\r'; then
  echo "Do not use CRLF. Use LF."
  exit 1
fi

exit 0