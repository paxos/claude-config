#!/usr/bin/env bash
# Bootstrap script for Patrick's Claude Code config.
#
# What it does (idempotent — safe to re-run):
#   Symlinks personal config files from this repo into ~/.claude/.
#
# Plugin marketplace registration and plugin enablement are NOT handled
# here — they live in settings.json (extraKnownMarketplaces + enabledPlugins),
# which gets symlinked in by this script. Restart Claude Code after first
# run so it re-reads settings.json.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

link() {
  local rel_path="$1"
  local source="$REPO_DIR/$rel_path"
  local target="$CLAUDE_DIR/$rel_path"

  if [ ! -e "$source" ]; then
    echo "$rel_path: missing in repo, skipping"
    return
  fi

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ]; then
    echo "$rel_path: already linked"
  elif [ -e "$target" ]; then
    echo "$rel_path: backing up existing file to $target.bak"
    mv "$target" "$target.bak"
    ln -s "$source" "$target"
    echo "$rel_path: linked"
  else
    ln -s "$source" "$target"
    echo "$rel_path: linked"
  fi
}

link "CLAUDE.md"
link "settings.json"

echo
echo "Done. Restart Claude Code to pick up settings changes."
