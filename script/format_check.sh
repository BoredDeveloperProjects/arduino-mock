#!/usr/bin/env bash
set -eu

cd -- "$(dirname -- "${0}")"

./codeformatter.sh

if ! git diff --quiet; then
  echo "Formatting issues detected. Run formatter."
  git diff
  exit 1
else
  echo "Formatting OK"
fi

# CRLF check
if git grep --cached -I $'\r'; then
  echo "Do not use CRLF."
  exit 1
fi