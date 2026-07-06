# BOOTSTRAP.md

> **For the AI agent reading this:** This is a self-deleting bootstrap script. Follow it end-to-end during the user's first session in a freshly-cloned template. Once done, **delete this file** and commit (only with user's explicit go-ahead per the hard rules in `AGENTS.md`).

## What this template is

A **local-first**, project-management scaffold for solo, AI-assisted projects using
**[Backlog.md](https://github.com/MrLesk/Backlog.md)** as the task tracker (tasks, docs, and
decisions as committed markdown under `backlog/`) + a load-on-demand knowledge tree for coding
agents. Forge-agnostic — any git remote is an optional mirror. The template is
**technology-agnostic** — you bring your own stack.

What you get out of the box:

- `AGENTS.md` / `CLAUDE.md` pointer table — tells agents which `backlog/docs/` file to load for which task
- `backlog/docs/*` — coding conventions, dev setup, commands, architecture, status, deferred, glossary, working-on-tasks
- `backlog/decisions/` + `backlog/docs/decisions.md` — two-way decision capture (`backlog decision` vs task note)
- `backlog/config.yml` — Backlog.md config (statuses `To Do`/`In Progress`/`Done`, task prefix, definition-of-done)
- `.agents/skills/backlog/` + `scripts/skills-bootstrap.sh` — the **vendored** `backlog` skill (committed, no fetch), symlinked under `.claude/skills/` for Claude Code auto-trigger
- `flake.nix` + `.envrc` — reproducible devShell that always ships `backlog`, `pre-commit`, `git`
- `.claude/hooks/session-start.sh` — prints branch + last 5 commits + in-progress tasks + to-do snapshot at every session start
- `.pre-commit-config.yaml` — generic hooks (whitespace, yaml/json checks, markdownlint, shellcheck, gitleaks, GPG UID guard)
- `scripts/uid-guard.sh` — GPG signing-key UID safety check

## Procedure

### Step 0 — Link skills

Skills are **vendored** (committed under `.agents/skills/`). This step only symlinks them into
`.claude/skills/` so Claude Code can auto-trigger them — no network.

```sh
./scripts/skills-bootstrap.sh
```

Verify: `ls .agents/skills/backlog/SKILL.md` exists, and `ls -l .claude/skills/backlog` shows a
symlink into it.

### Step 1 — Ask the user these questions (one batch)

Present all questions at once. Wait for answers before filling anything.

1. **Project name** (short, kebab-case ok) and **one-sentence description**.
2. **Primary stack / language** (Node+TS, Rust, Python, Go, Elixir, mixed, undecided, ...). Used to seed `.gitignore`, `dev-setup.md`, `commands.md`.
3. **License**: AGPL-3.0-or-later, MIT, Apache-2.0, proprietary, or "decide later".
4. **Git remote (optional)**: GitHub, GitLab, Codeberg, Radicle, or none. Tasks are local either way — the remote is just a mirror. (Default: none.)
5. **First task title + goal** (e.g. "scaffold + first runnable thing"). Seeds the first Backlog.md task in `To Do`.
6. **Any pre-existing architectural decisions?** (e.g. "monorepo with pnpm workspaces", "single binary", "no DB"). Each becomes a `backlog decision` (`backlog/decisions/decision-1 - *.md`, ...).
7. **Commit convention**: Conventional Commits (default), gitmoji, custom, or none.
8. **Pre-commit language hooks now or later?** If now: which (eslint, ruff, cargo fmt, ...). If later: leave `.pre-commit-config.yaml` generic-only.
9. **Extra stack packages in the Nix devShell?** The repo already ships a `flake.nix` whose devShell includes `backlog`, `pre-commit`, and `git`, and `.envrc` is already `use flake`. If yes: add the stack toolchain (Q2) to the marked `# stack packages` block in `flake.nix`. (Prefer not to use Nix at all? You can, but the `backlog` CLI then needs installing another way — see `backlog/docs/dev-setup.md`.)
10. **Maintainer name** for `AGENTS.md` "Code ownership" section.

### Step 2 — Fill placeholders

Search the repo for `<TBD` and `<PROJECT_NAME>`. Replace using the answers. Files known to contain placeholders:

- `AGENTS.md` — project name, description, dev loop snippet, code ownership
- `CLAUDE.md` — project name
- `backlog/config.yml` — set `project_name` from Q1 (edit the file directly; `backlog config` opens the interactive flow)
- `README.md` — **overwrite entirely** (current contents describe the template itself; replace with project README: title from Q1, one-line description, minimal "Getting started" for the chosen stack from Q2, license section from Q3). Drop the template's "Contributing" section — that's about the template repo, not your project.
- `backlog/docs/readme.md` — title / intro
- `backlog/docs/user/index.md` — title
- `backlog/docs/conventions.md` — append "Stack-specific" section from answers (Q2)
- `backlog/docs/commands.md` — fill with build/test/run commands for the chosen stack (Q2)
- `backlog/docs/dev-setup.md` — toolchain section from Q2; note the flake already ships `backlog`
- `flake.nix` — add the Q2 stack packages to the marked `# stack packages` block
- `backlog/docs/architecture.md` — minimal seed; user fleshes out later
- `.gitignore` — append stack-specific ignores (Q2): `node_modules/ dist/` or `target/` or `__pycache__/ .venv/` etc.

### Step 3 — Record pre-existing decisions

For each item in Q6, run `backlog decision create "<summary>"` and fill the generated
`backlog/decisions/decision-N - *.md` using the format described in `backlog/docs/decisions.md`. If
the user picked AGPL/MIT/etc. in Q3, record a license decision too.

### Step 4 — Replace LICENSE file

**First delete the inherited `LICENSE`** — the template ships MIT for the template itself, NOT for projects bootstrapped from it. Leaving it would silently make every new project MIT against the user's will.

```sh
rm LICENSE
```

Then, based on Q3, drop the canonical license text into a fresh `LICENSE`. Skip the recreate step if user picked "decide later" — leave the file deleted.

### Step 5 — Initialize Backlog.md state

The `backlog/` scaffold (config, folders) already ships committed — no interactive `backlog init`
needed. Set the project name and create the first task from Q5:

```sh
backlog config set project_name "<project-name>"      # or edit backlog/config.yml
backlog task create "<goal from Q5>" --priority high
```

(Optional, only if the user wants a remote from Q4: `git remote add origin <url>` — tasks stay
local regardless.)

### Step 6 — (Optional) language-specific pre-commit hooks

If Q8 = "now": append the hooks to `.pre-commit-config.yaml`. Pattern for language-system hooks (use as a model):

```yaml
- id: <toolname>
  name: <toolname>
  language: system
  entry: <command>
  files: '<regex>'        # or pass_filenames: false
  stages: [manual]        # flip to [pre-commit] once baseline is clean
```

Suggested defaults per stack: Node+TS → prettier, eslint, tsc --noEmit, knip, madge --circular. Rust → cargo fmt --check, cargo clippy, cargo deny. Python → ruff check, ruff format --check, mypy. Nix → nixfmt, statix, deadnix. Cross-stack security → trivy fs.

### Step 7 — Initial commit

**Stop and ask the user** before committing. Suggested message:

```
chore: bootstrap from agentic-project-template

- pointer-table AGENTS.md / CLAUDE.md
- Backlog.md task tracker + vendored backlog skill
- backlog/ knowledge tree (docs/, decisions/)
- generic pre-commit hooks + GPG UID guard
- decision-1..N recorded from bootstrap answers
```

### Step 8 — Self-delete

```sh
rm BOOTSTRAP.md
```

Then commit the deletion (or fold it into Step 7).

## Notes

- **Don't invent answers.** If user dodges a question, leave the `<TBD>` placeholder and note in the session summary which ones still need filling.
- **One commit at the end, not per step.** Bootstrap is a single logical change.
- **The pointer table in `AGENTS.md` is the load map.** Don't dump every file into context at session start in future sessions — that's what the table prevents.
