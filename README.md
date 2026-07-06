# agentic-project-template

Technology-agnostic, **local-first** scaffold for solo, AI-assisted projects. Stands up a new repo
with:

- **[Backlog.md](https://github.com/MrLesk/Backlog.md)** as the task tracker — tasks, docs, and
  decisions are plain markdown committed under `backlog/`. No external issue tracker; the `backlog`
  CLI ships in the Nix devShell.
- **Forge-agnostic git** — plain branches merged locally. A git remote
  (GitHub / GitLab / Codeberg / Radicle / none) is an *optional* mirror, not a tracker.
- `AGENTS.md` / `CLAUDE.md` pointer table — agents know which `backlog/docs/` file to load for which
  task (no full-tree dumps into context).
- `BOOTSTRAP.md` self-deleting first-run script — ~10 questions, fills placeholders, seeds
  decisions, creates the first Backlog.md task.
- `backlog/` knowledge tree — `docs/` (agent + user docs) and `decisions/` (architecture/tech
  records), sized for load-on-demand.
- **Vendored** `backlog` skill (`.agents/skills/backlog/`) — committed, no network fetch; symlinked
  into `.claude/skills/` for Claude Code auto-trigger by `scripts/skills-bootstrap.sh`.
- Generic pre-commit hooks (whitespace, YAML/JSON checks, markdownlint, shellcheck, gitleaks) +
  GPG signing-key UID guard.
- `.claude/hooks/session-start.sh` — branch + last commits + in-progress tasks + board snapshot at
  every session start.
- `flake.nix` + `.envrc` (`use flake`) — reproducible devShell that always includes `backlog`,
  `pre-commit`, and `git`; stack packages are added at bootstrap.

## Quick start

```sh
git clone git@github.com:mikolajmikolajczyk/agentic-project-template.git my-project
cd my-project
rm -rf .git && git init && git branch -m main

# Then open the project in Claude Code (or another agent) and let it read BOOTSTRAP.md.
# The agent will run ./scripts/skills-bootstrap.sh, ask you ~10 questions,
# fill placeholders, seed decisions, and self-delete BOOTSTRAP.md.
```

## Contributing

This template is developed in the open. It's forge-agnostic — clone it, branch, and send changes
through whichever remote hosts it.

## License

MIT — see [`LICENSE`](LICENSE). It's a scaffold with sensible defaults, nothing novel; do whatever
you want with it.
