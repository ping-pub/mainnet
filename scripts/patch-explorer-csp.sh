#!/usr/bin/env bash
set -euo pipefail

index_file="${1:-explorer/index.html}"

if [[ ! -f "$index_file" ]]; then
  echo "Explorer index file not found: $index_file" >&2
  exit 1
fi

add_csp_source() {
  local directive="$1"
  local source="$2"

  if grep -F "$source" "$index_file" >/dev/null; then
    return
  fi

  if ! grep -F "$directive" "$index_file" >/dev/null; then
    echo "CSP directive not found in $index_file: $directive" >&2
    exit 1
  fi

  perl -0pi -e "s#($directive[^;]*);#\$1 $source;#" "$index_file"
}

add_csp_source "script-src" "https://v1.slise.xyz"
add_csp_source "frame-src" "https://*.slise.xyz"
