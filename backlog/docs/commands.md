# Commands

Everyday commands for this project. Keep this file **flat and copy-pasteable** — agents and humans both grep it.

## Build / run / test

<TBD: stack-specific, filled at bootstrap. Examples:

```sh
# Node + Vite
pnpm install
pnpm dev          # dev server
pnpm build        # production build
pnpm test         # vitest run

# Rust
cargo build
cargo run
cargo test
cargo clippy --all-targets --all-features -- -D warnings

# Python (uv)
uv sync
uv run pytest
uv run ruff check
```
>

## Typecheck / lint / format

<TBD: filled at bootstrap>

## Pre-commit

```sh
pre-commit install                                  # one-time, per clone
pre-commit run --all-files                          # run active hooks
pre-commit run --all-files --hook-stage manual      # run staged-as-manual hooks too
```

## Backlog.md

See the [`backlog` skill](../../.agents/skills/backlog/SKILL.md) and `backlog instructions overview`
for the canonical cheat-sheet. Most-used:

```sh
backlog task create "<title>" -d "<desc>" --ac "<criterion>"
backlog task list --plain                       # AI-friendly view
backlog task list -s "In Progress" --plain
backlog task <id> --plain                        # show one task
backlog task edit <id> -s "In Progress" --plan "<approach>"
backlog task edit <id> --check-ac 1 --notes "<progress>"
backlog task edit <id> -s Done
backlog board                                    # interactive kanban
backlog browser                                  # web UI
backlog doc create "<title>"                      # → docs/doc-N - Title.md
backlog decision create "<title>"                 # → decisions/decision-N - Title.md
backlog config                                   # view/edit config.yml
```
