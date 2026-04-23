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
changed_count=0
while IFS= read -r file; do
  [ -n "$file" ] || continue
  tmp_file="$(mktemp)"
  cp "$file" "$tmp_file"
  echo "[FORMAT] $file"
  clang-format -i "$file"
  if ! cmp -s "$file" "$tmp_file"; then
    changed_count=$((changed_count + 1))
  fi
  rm -f "$tmp_file"
done <<EOF
$files
EOF

echo "[INFO] clang-format changed $changed_count file(s)"

if git grep --cached -I $'\r'; then
  echo "Do not use CRLF. Use LF."
  exit 1
fi