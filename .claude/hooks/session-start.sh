#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Prints a quick orientation snapshot so the agent doesn't burn tokens
# rediscovering project state.

set -u

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" 2>/dev/null || exit 0

print_section() {
  printf '\n--- %s ---\n' "$1"
}

print_section "branch + last 5 commits"
git log --format="%h %s" -5 2>/dev/null || echo "(no git)"

print_section "in-progress tasks (backlog)"
if command -v backlog >/dev/null 2>&1; then
  out=$(backlog task list -s "In Progress" --plain 2>/dev/null | head -10)
  if [ -n "$out" ]; then
    echo "$out"
  else
    echo "(none — nothing In Progress)"
  fi
else
  echo "(backlog not on PATH — run 'nix develop' or install Backlog.md)"
fi

print_section "to-do snapshot"
if command -v backlog >/dev/null 2>&1; then
  # --plain is the non-interactive view; never launch the TUI board from a hook.
  out=$(backlog task list -s "To Do" --plain 2>/dev/null | head -10)
  if [ -n "$out" ]; then
    echo "$out"
  else
    echo "(none — nothing in To Do)"
  fi
fi

print_section "load order reminder"
cat <<'EOF'
1. AGENTS.md (root) → conventions + pointer table
2. backlog/docs/working-on-tasks.md → if picking up a task
3. backlog task <id> --plain → recent notes on the active task
4. Read only the backlog/docs/*.md files relevant to the task
EOF

exit 0
