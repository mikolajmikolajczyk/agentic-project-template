# BOOTSTRAP.md

> **For the AI agent reading this:** This is a self-deleting bootstrap script. Follow it end-to-end during the user's first session in a freshly-cloned template. Once done, **delete this file** and commit (only with user's explicit go-ahead per the hard rules in `AGENTS.md`).

## What this template is

A project-management scaffold for solo, AI-assisted projects using **Radicle** as canonical forge + **radboard** label conventions for kanban + a `wiki/` knowledge tree designed for load-on-demand by coding agents. The template is **technology-agnostic** — you bring your own stack.

What you get out of the box:

- `AGENTS.md` / `CLAUDE.md` pointer table — tells agents which wiki file to load for which task
- `wiki/agents/*` — coding conventions, dev setup, commands, architecture, status, deferred, glossary
- `wiki/adr/` + `wiki/decisions/` — three-way decision capture (ADR vs decision log vs issue comment)
- `.agents/skillfile` + `scripts/skills-bootstrap.sh` — fetches `radicle` + `radboard` skills from [llm_skills](https://github.com/mikolajmikolajczyk/llm_skills) into `.agents/skills/` and symlinks them under `.claude/skills/` for Claude Code auto-trigger
- `.claude/hooks/session-start.sh` — prints branch + last 5 commits + in-progress issues + milestone snapshot at every session start
- `.pre-commit-config.yaml` — generic hooks (whitespace, yaml/json checks, markdownlint, shellcheck, gitleaks, GPG UID guard)
- `scripts/uid-guard.sh` — GPG signing-key UID safety check

## Procedure

### Step 0 — Install skills

Skills are not vendored — they're fetched from [llm_skills](https://github.com/mikolajmikolajczyk/llm_skills) at bootstrap so they're always fresh.

```sh
./scripts/skills-bootstrap.sh
```

This reads `.agents/skillfile`, clones llm_skills into a tempdir, runs `llm_skills.sh sync .` (installs into `.agents/skills/` as symlinks to the user's `~/.local/share/llm_skills/repos/` cache), and symlinks them under `.claude/skills/` for Claude Code auto-discovery.

Verify: `ls .agents/skills/` should show `radicle/` and `radboard/`, both with `SKILL.md` inside.

### Step 1 — Ask the user these questions (one batch)

Present all questions at once. Wait for answers before filling anything.

1. **Project name** (short, kebab-case ok) and **one-sentence description**.
2. **Primary stack / language** (Node+TS, Rust, Python, Go, Elixir, mixed, undecided, ...). Used to seed `.gitignore`, `dev-setup.md`, `commands.md`.
3. **License**: AGPL-3.0-or-later, MIT, Apache-2.0, proprietary, or "decide later".
4. **Forge model**: Radicle-only, Radicle + mirror (GitHub/GitLab/Codeberg), or other. (Default: Radicle-only.)
5. **First milestone label name + goal** (e.g. `milestone:m0-foundation` → "scaffold + first runnable thing"). Seeds the first Radicle issue.
6. **Any pre-existing architectural decisions?** (e.g. "monorepo with pnpm workspaces", "single binary", "no DB"). Each becomes an ADR (`wiki/adr/0001-*.md`, `0002-*.md`, ...).
7. **Commit convention**: Conventional Commits (default), gitmoji, custom, or none.
8. **Pre-commit language hooks now or later?** If now: which (eslint, ruff, cargo fmt, ...). If later: leave `.pre-commit-config.yaml` generic-only.
9. **Toolchain pinning via Nix flake + direnv?** (**recommended** — reproducible devShell, no global installs, auto-activates on `cd`). If yes: scaffold `flake.nix` for the stack from Q2 and switch `.envrc` to `use flake`. If no: leave `.envrc` empty and note alternative (mise / asdf / rustup / nvm / system) in `dev-setup.md`.
10. **Maintainer name** for `AGENTS.md` "Code ownership" section.

### Step 2 — Fill placeholders

Search the repo for `<TBD` and `<PROJECT_NAME>`. Replace using the answers. Files known to contain placeholders:

- `AGENTS.md` — project name, description, dev loop snippet, code ownership
- `CLAUDE.md` — project name
- `README.md` — **overwrite entirely** (current contents describe the template itself; replace with project README: title from Q1, one-line description, minimal "Getting started" for the chosen stack from Q2, license section from Q3). Don't keep the template's "Contributing via Radicle / RID rad:zVjxxNV4b1xBphQA78dNtTLQKtic" section — that's about the template repo, not your project. Your project gets its own RID after `rad init` in Step 5.
- `wiki/index.md` — title
- `wiki/agents/index.md` — title
- `wiki/user/index.md` — title
- `wiki/agents/conventions.md` — append "Stack-specific" section from answers (Q2)
- `wiki/agents/commands.md` — fill with build/test/run commands for the chosen stack (Q2)
- `wiki/agents/dev-setup.md` — toolchain section from Q2; if Q9=yes, add an explicit "This project uses Nix flake + direnv" line at the top of "Stack-specific toolchain" so agents know to run `nix develop` / trust direnv auto-activation
- `flake.nix` — create only if Q9=yes; minimal `devShell` with packages for the chosen stack (Q2)
- `.envrc` — if Q9=yes, set contents to `use flake`
- `wiki/agents/architecture.md` — minimal seed; user fleshes out later
- `.gitignore` — append stack-specific ignores (Q2): `node_modules/ dist/` or `target/` or `__pycache__/ .venv/` etc.

### Step 3 — Seed ADRs from pre-existing decisions

For each item in Q6, write `wiki/adr/0001-*.md`, `0002-*.md`, ... using the format described in `wiki/adr/README.md`. Number sequentially. If user picked AGPL/MIT/etc. in Q3, write a license ADR too.

### Step 4 — Replace LICENSE file

**First delete the inherited `LICENSE`** — the template ships MIT for the template itself, NOT for projects bootstrapped from it. Leaving it would silently make every new project MIT against the user's will.

```sh
rm LICENSE
```

Then, based on Q3, drop the canonical license text into a fresh `LICENSE`. Skip the recreate step if user picked "decide later" — leave the file deleted.

### Step 5 — Set up Radicle (only if user confirms)

```sh
rad init --name <project-name> --description "<one-liner>" --default-branch main --private  # or --public
```

Then create the first issue from Q5:

```sh
rad issue open --title "<goal from Q5>" --label "<milestone label from Q5>" --label "priority:high"
```

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
- radicle + radboard skills wired
- wiki/ knowledge tree (agents/, adr/, decisions/, skills/, user/)
- generic pre-commit hooks + GPG UID guard
- ADR-0001..N seeded from bootstrap answers
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
