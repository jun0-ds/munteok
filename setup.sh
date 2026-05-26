#!/usr/bin/env bash
set -euo pipefail

# munteok setup — scaffold a 문턱 substrate (안채) from a fork of this framework.
#
# What it does (framework-owned only):
#   1. Scaffolds private zone content placeholders into THIS repo (your 안채):
#      hearth/identity/{voice,position,relations}.md · desk/agenda/current.md · desk/diary.md
#   2. Installs the 4-zone definition (§munteok) as a marker block into ~/.claude/CLAUDE.md
#
# What it deliberately does NOT do (delegated — run those separately):
#   - memory / notes / device-sync         → bobusang setup.sh
#   - thinking discipline                   → sonmat (plugin install)
#   - device table (§env), per-instance paths, desk↔~/.claude symlink relocation → your call
#
# Idempotent: existing files are skipped; the marker block is updated in place.
# Override target for testing: MUNTEOK_CLAUDE_DIR=/tmp/foo bash setup.sh

ANCHAE_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${MUNTEOK_CLAUDE_DIR:-$HOME/.claude}"
TPL="$ANCHAE_DIR/templates"

echo "=== munteok setup ==="
echo ""

# 1. Detect device
HOSTNAME=$(hostname)
OS=$(uname -s)
if grep -qi microsoft /proc/version 2>/dev/null; then
  PLATFORM="WSL2"
elif [[ "$OS" == "Linux" ]]; then
  PLATFORM="Linux"
elif [[ "$OS" == "Darwin" ]]; then
  PLATFORM="macOS"
else
  PLATFORM="$OS"
fi
echo "Device:   $HOSTNAME ($PLATFORM)"
echo "안채:     $ANCHAE_DIR"
echo "claude:   $CLAUDE_DIR"
echo ""

if [[ ! -d "$TPL" ]]; then
  echo "✗ templates/ not found at $TPL — is this a munteok fork?"
  exit 1
fi

# --- helpers ---------------------------------------------------------------

copy_if_missing() {
  local src="$1" dst="$2"
  if [[ ! -f "$src" ]]; then
    echo "  skip: $(basename "$dst") (template $(basename "$src") missing)"
    return 0
  fi
  if [[ -f "$dst" ]]; then
    echo "  skip: ${dst#$ANCHAE_DIR/} (already exists)"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  created: ${dst#$ANCHAE_DIR/}"
  fi
}

# Install/update a marker-block section in a target file (bobusang pattern).
# Edits OUTSIDE markers are preserved; INSIDE markers get overwritten on update.
install_or_update_marker_block() {
  local file="$1" marker_id="$2" content_file="$3"
  local start_marker="<!-- ${marker_id}:start -->"
  local end_marker="<!-- ${marker_id}:end -->"

  if [[ ! -f "$file" ]]; then
    echo "  skip: ${marker_id} block (target ${file} not found)"
    return 0
  fi
  if [[ ! -f "$content_file" ]]; then
    echo "  skip: ${marker_id} block (content ${content_file} not found)"
    return 0
  fi

  if grep -qF "$start_marker" "$file"; then
    local tmpfile
    tmpfile=$(mktemp)
    awk -v start="$start_marker" -v end="$end_marker" -v cf="$content_file" '
      $0 == start { print; while ((getline line < cf) > 0) print line; close(cf); in_block=1; next }
      $0 == end   { in_block=0; print; next }
      !in_block   { print }
    ' "$file" > "$tmpfile"
    mv "$tmpfile" "$file"
    echo "  updated: ${marker_id} block in $(basename "$file")"
  else
    { printf '\n%s\n' "$start_marker"; cat "$content_file"; printf '%s\n' "$end_marker"; } >> "$file"
    echo "  installed: ${marker_id} block appended to $(basename "$file")"
  fi
}

# --- 2. Scaffold private zone placeholders (into this 안채) -----------------

echo "Scaffolding 안채 zone placeholders..."
copy_if_missing "$TPL/hearth-identity-voice.md"     "$ANCHAE_DIR/hearth/identity/voice.md"
copy_if_missing "$TPL/hearth-identity-position.md"  "$ANCHAE_DIR/hearth/identity/position.md"
copy_if_missing "$TPL/hearth-identity-relations.md" "$ANCHAE_DIR/hearth/identity/relations.md"
copy_if_missing "$TPL/desk-agenda-current.md"       "$ANCHAE_DIR/desk/agenda/current.md"
copy_if_missing "$TPL/desk-diary.md"                "$ANCHAE_DIR/desk/diary.md"
echo ""

# --- 3. Install 4-zone section into CLAUDE.md (marker block) ---------------

echo "Installing CLAUDE.md 4-zone section..."
if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
  install_or_update_marker_block "$CLAUDE_DIR/CLAUDE.md" "munteok:zones" "$TPL/claude-zones-section.md"
else
  echo "  ℹ $CLAUDE_DIR/CLAUDE.md not found — section install skipped."
  echo "    Create CLAUDE.md and re-run to auto-install."
fi
echo ""

# --- 4. Next steps ---------------------------------------------------------

echo "=== Setup complete ==="
echo ""
echo "Next:"
echo "  1. Fill in hearth/identity/{voice,position,relations}.md — who this instance is"
echo "  2. Seed desk/agenda/current.md with your live tracks"
echo "  3. Point your global CLAUDE.md naming/voice line at hearth/identity/voice.md (SoT)"
echo "  4. Delegated setup (run separately):"
echo "       • memory / notes / device-sync → bobusang setup.sh"
echo "       • thinking discipline          → install sonmat"
echo ""
echo "See README.md for the 4-zone model and the framework/안채 split."
