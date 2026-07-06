#!/usr/bin/env bash
# init.sh — one-shot template initializer. Run once after cloning the template.
#
# Wipes the template's git history, starts a fresh repo on `main`, links the
# vendored skills, and installs pre-commit hooks. The interactive part of the
# bootstrap (project name, stack, license, …) stays with your coding agent —
# open the project and let it read BOOTSTRAP.md.
#
# Usage: ./init.sh [-y]
#   -y   skip the confirmation prompt

set -euo pipefail

if [[ ! -f BOOTSTRAP.md ]]; then
  echo "error: BOOTSTRAP.md not found — already bootstrapped, or not the template root" >&2
  exit 1
fi

if [[ "${1:-}" != "-y" ]]; then
  echo "This wipes the template's git history (rm -rf .git) and starts a fresh repo."
  read -r -p "Continue? [y/N] " answer
  case "$answer" in
    [yY]*) ;;
    *) echo "aborted"; exit 1 ;;
  esac
fi

echo "• wiping template git history"
rm -rf .git
git init -q -b main

echo "• linking vendored skills"
./scripts/skills-bootstrap.sh

if command -v pre-commit >/dev/null 2>&1; then
  echo "• installing pre-commit hooks"
  pre-commit install
else
  echo "• pre-commit not on PATH — run 'pre-commit install' later (ships in the nix devShell)"
fi

if command -v direnv >/dev/null 2>&1; then
  echo "• allowing direnv (.envrc → use flake)"
  direnv allow
else
  echo "• direnv not on PATH — enter the devShell with 'nix develop'"
fi

rm -- "$0"

cat <<'EOF'

✓ initialized — template history gone, fresh repo on `main`.

Next: open the project in Claude Code (or another coding agent) and let it
read BOOTSTRAP.md — it asks ~10 questions, fills the placeholders, seeds
decisions, and self-deletes.
EOF
