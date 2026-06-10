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

## Radicle

See [`../skills/radicle.md`](../skills/radicle.md) for the canonical CLI cheat-sheet. Most-used:

```sh
rad issue list --all
rad issue list --label state:in-progress
rad issue show <hex7>
rad issue open --title "<x>" --label "milestone:<m>" --label "priority:<p>"
rad issue label <hex7> -a state:in-progress
rad issue state --solved <hex7>
git push rad HEAD:refs/patches
```
