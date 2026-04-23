#!/usr/bin/env bash
set -eu

cd -- "$(dirname -- "${0}")"

# Check clang-format exists
if ! command -v clang-format >/dev/null 2>&1; then
  echo "clang-format not found"
  echo "Install:"
  echo "  Linux: sudo apt install clang-format"
  echo "  Mac: brew install llvm"
  echo "  Windows (Scoop): scoop install llvm"
  exit 1
fi

# Format files in-place
find ../ -type f \( -name "*.h" -o -name "*.cc" -o -name "*.cpp" \) \
  -exec clang-format -i {} +

# Check CRLF
if git grep --cached -I $'\r'; then
  echo "Do not use CRLF. Use LF."
  exit 1
fi