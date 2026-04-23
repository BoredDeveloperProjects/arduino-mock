#!/usr/bin/env bash
set -eu

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if ! command -v clang-format >/dev/null 2>&1; then
  echo "clang-format not found"
  echo "Install:"
  echo "  Linux: sudo apt install clang-format"
  echo "  Mac: brew install llvm"
  echo "  Windows (Scoop): scoop install llvm"
  exit 1
fi

files="$(git ls-files --cached --others --exclude-standard -- '*.h' '*.cc' '*.cpp')"

if [ -z "$files" ]; then
  echo "[INFO] No matching files found"
  exit 0
fi

echo "[INFO] Formatting files"
while IFS= read -r file; do
  [ -n "$file" ] || continue
  echo "[FORMAT] $file"
  clang-format -i "$file"
done <<EOF
$files
EOF

if git grep --cached -I $'\r'; then
  echo "Do not use CRLF. Use LF."
  exit 1
fi