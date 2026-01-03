#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage:
  create_links.sh <folders_list.txt> [source_base_dir]

Creates symlinks in the CURRENT directory (pwd) for each folder name listed in folders_list.txt.

Defaults:
  - source_base_dir: directory that contains folders_list.txt

Notes:
  - Empty lines and lines starting with # are ignored.
  - If a destination name already exists, it will be skipped with a warning.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

LIST_FILE="${1:-}"
if [[ -z "$LIST_FILE" ]]; then
  usage
  exit 2
fi
if [[ ! -f "$LIST_FILE" ]]; then
  echo "ERROR: list file not found: $LIST_FILE" >&2
  exit 2
fi

LIST_DIR="$(cd "$(dirname "$LIST_FILE")" && pwd)"
SOURCE_BASE="${2:-$LIST_DIR}"
SOURCE_BASE="$(cd "$SOURCE_BASE" 2>/dev/null && pwd || true)"
if [[ -z "$SOURCE_BASE" ]]; then
  echo "ERROR: source_base_dir does not exist: ${2:-$LIST_DIR}" >&2
  exit 2
fi

DEST_DIR="$(pwd)"

trim() {
  local s="$1"
  # trim leading/trailing whitespace
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

fail_count=0
skip_count=0
ok_count=0

while IFS= read -r line || [[ -n "$line" ]]; do
  # Remove inline comments and trim
  line="${line%%#*}"
  name="$(trim "$line")"
  [[ -z "$name" ]] && continue

  src="$SOURCE_BASE/$name"
  dst="$DEST_DIR/$name"

  if [[ ! -d "$src" ]]; then
    echo "WARN: source folder not found, skipping: $src" >&2
    ((fail_count++)) || true
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "WARN: destination already exists, skipping: $dst" >&2
    ((skip_count++)) || true
    continue
  fi

  ln -s "$src" "$dst"
  echo "OK: $dst -> $src"
  ((ok_count++)) || true
done < "$LIST_FILE"

echo "Done. created=$ok_count skipped=$skip_count failed=$fail_count"
exit 0


