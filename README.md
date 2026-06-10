# agentic-project-template

Technology-agnostic scaffold for solo, AI-assisted projects. Stands up a new repo with:

- **[Radicle](https://radicle.xyz)** as canonical forge — issues + patches via `rad`
- **[radboard](https://github.com/mikolajmikolajczyk/llm_skills/tree/master/radboard)** label conventions for kanban (`state:*`, `priority:*`, `milestone:*`, ...)
- `AGENTS.md` / `CLAUDE.md` pointer table — agents know which `wiki/` file to load for which task (no full-tree dumps into context)
- `BOOTSTRAP.md` self-deleting first-run script — ~10 questions, fills placeholders, seeds ADRs, kicks off the first Radicle issue
- `wiki/{agents,adr,decisions,user}` knowledge tree — sized for load-on-demand
- `scripts/skills-bootstrap.sh` — fetches `radicle` + `radboard` skills from [llm_skills](https://github.com/mikolajmikolajczyk/llm_skills) into `.agents/skills/` and mirrors them into `.claude/skills/` for Claude Code auto-trigger
- Generic pre-commit hooks (whitespace, YAML/JSON checks, markdownlint, shellcheck, gitleaks) + GPG signing-key UID guard
- `.claude/hooks/session-start.sh` — branch + last commits + in-progress Radicle issues at every session start

## Quick start

```sh
git clone git@github.com:mikolajmikolajczyk/agentic-project-template.git my-project
cd my-project
rm -rf .git && git init && git branch -m main

# Then open the project in Claude Code (or another agent) and let it read BOOTSTRAP.md.
# The agent will run ./scripts/skills-bootstrap.sh, ask you ~10 questions,
# fill placeholders, seed ADRs, and self-delete BOOTSTRAP.md.
```

## Contributing

This template is **mirrored to GitHub for visibility only** — canonical forge is Radicle.

```
rad:zVjxxNV4b1xBphQA78dNtTLQKtic
```

```sh
rad clone rad:zVjxxNV4b1xBphQA78dNtTLQKtic
rad issue list --all
git push rad HEAD:refs/patches    # submit a patch
```

GitHub Pull Requests are **not** monitored. Open an issue on Radicle or send a patch.

## License

<TBD: not yet decided for this template repo>
