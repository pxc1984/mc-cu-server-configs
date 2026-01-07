#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage:
  delete_folders.sh <folders_list.txt> [--force]

Deletes folders/files from the CURRENT directory (pwd) for each name listed in folders_list.txt.

Options:
  --force    Skip confirmation prompt

⚠️  WARNING: This performs RECURSIVE deletion!

Notes:
  - Empty lines and lines starting with # are ignored.
  - Without --force, will ask for confirmation before deletion.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

LIST_FILE="${1:-}"
FORCE="${2:-}"

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
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# Collect items to delete
items_to_delete=()
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  name="$(trim "$line")"
  [[ -z "$name" ]] && continue

  dst="$DEST_DIR/$name"
  
  if [[ -e "$dst" || -L "$dst" ]]; then
    items_to_delete+=("$dst")
  fi
done < "$LIST_FILE"

# Check if anything to delete
if [[ ${#items_to_delete[@]} -eq 0 ]]; then
  echo "Nothing to delete."
  exit 0
fi

# Show what will be deleted
echo "The following items will be DELETED:"
printf '  %s\n' "${items_to_delete[@]}"
echo ""
echo "Total: ${#items_to_delete[@]} items in directory: $DEST_DIR"

# Ask for confirmation unless --force
if [[ "$FORCE" != "--force" ]]; then
  read -p "Continue? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# Perform deletion
del_count=0
for dst in "${items_to_delete[@]}"; do
  rm -rf -- "$dst"
  echo "OK: removed: $dst"
  ((del_count++)) || true
done

echo "Done. removed=$del_count"
exit 0