#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage:
  delete_links.sh <folders_list.txt>

Deletes symlinks (only symlinks) from the CURRENT directory (pwd) for each folder name listed in folders_list.txt.

Notes:
  - Empty lines and lines starting with # are ignored.
  - If a path exists but is NOT a symlink, it will be skipped with a warning (for safety).
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

DEST_DIR="$(pwd)"

trim() {
  local s="$1"
  # trim leading/trailing whitespace
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

del_count=0
skip_count=0

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  name="$(trim "$line")"
  [[ -z "$name" ]] && continue

  dst="$DEST_DIR/$name"

  if [[ -L "$dst" ]]; then
    rm -f -- "$dst"
    echo "OK: removed symlink: $dst"
    ((del_count++)) || true
    continue
  fi

  if [[ -e "$dst" ]]; then
    echo "WARN: exists but is not a symlink, skipping: $dst" >&2
    ((skip_count++)) || true
    continue
  fi

  # doesn't exist - ignore
done < "$LIST_FILE"

echo "Done. removed=$del_count skipped=$skip_count"
exit 0


