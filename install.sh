#!/usr/bin/env bash
# Install cursor-ios-rules into a Cursor project or user rules folder.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
RULES_SRC="$REPO_ROOT/rules"

usage() {
  cat <<'EOF'
Usage: ./install.sh [target]

Targets:
  project   Copy rules to ./.cursor/rules/ in the current directory (default)
  user      Copy rules to ~/.cursor/rules/ (applies across projects on this machine)
  link      Symlink rules into ./.cursor/rules/ (good for git submodules)

Examples:
  ./install.sh
  ./install.sh user
  cd ~/Developer/MyApp && /path/to/cursor-ios-rules/install.sh project
EOF
}

TARGET="${1:-project}"

if [[ ! -d "$RULES_SRC" ]]; then
  echo "error: rules/ not found at $RULES_SRC" >&2
  exit 1
fi

case "$TARGET" in
  project)
    DEST="$(pwd)/.cursor/rules"
    mkdir -p "$DEST"
    cp -v "$RULES_SRC"/*.mdc "$DEST/"
    echo ""
    echo "Installed $(ls -1 "$RULES_SRC"/*.mdc | wc -l | tr -d ' ') rules to $DEST"
    echo "Commit .cursor/rules/ with your project if you want the team to share them."
    ;;
  user)
    DEST="$HOME/.cursor/rules"
    mkdir -p "$DEST"
    cp -v "$RULES_SRC"/*.mdc "$DEST/"
    echo ""
    echo "Installed to $DEST (global on this machine)."
    echo "Tip: keep always-on rules lean. See README token budget section."
    ;;
  link)
    DEST="$(pwd)/.cursor/rules"
    mkdir -p "$DEST"
    for f in "$RULES_SRC"/*.mdc; do
      name="$(basename "$f")"
      ln -sf "$f" "$DEST/$name"
      echo "linked $DEST/$name -> $f"
    done
    echo ""
    echo "Symlinked rules into $DEST"
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    echo "error: unknown target '$TARGET'" >&2
    usage
    exit 1
    ;;
esac
