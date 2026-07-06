# AGENTS.md — <PROJECT_NAME>

Repo-specific notes for coding agents (Claude Code, Cursor, Aider, Copilot, …). Generic software-engineering advice is out of scope.

> **CLAUDE.md** at repo root is `@AGENTS.md` plus Claude-only overrides. Other agents read this file directly.

## ⚠️ First-time setup

If `BOOTSTRAP.md` still exists in repo root, this project hasn't been bootstrapped yet. **Read `BOOTSTRAP.md` first** and follow its instructions before doing anything else. It will walk the user through ~10 questions, fill the `<TBD>` placeholders in this file and across `backlog/`, then delete itself.

## What this is

<TBD: one-paragraph project description — filled at bootstrap>

## Where things live

| Need | Path | When to load |
|------|------|--------------|
| **Source of truth for roadmap, tasks, backlog** | Backlog.md — `backlog task list --plain` | Always. **Don't read roadmaps from markdown.** |
| Current repo shape, data flow, file map | [`backlog/docs/architecture.md`](backlog/docs/architecture.md) | When making structural changes or unfamiliar with module layout |
| Coding conventions, file naming, commit style, comment policy | [`backlog/docs/conventions.md`](backlog/docs/conventions.md) | Before writing or modifying code |
| Feature status (what works, what's in flight, what's broken) | [`backlog/docs/status.md`](backlog/docs/status.md) | When user asks "does X work?" or you're picking up work |
| Common dev commands (build, test, run, typecheck, lint) | [`backlog/docs/commands.md`](backlog/docs/commands.md) | When running build/test/dev loops |
| Tooling (devShell, direnv, pre-commit, static analysis) | [`backlog/docs/dev-setup.md`](backlog/docs/dev-setup.md) | When fixing tooling, adding hooks, or onboarding |
| Working on tasks (statuses, branch naming, session handoff) | [`backlog/docs/working-on-tasks.md`](backlog/docs/working-on-tasks.md) | Before picking up a task |
| Where to capture decisions (`backlog decision` vs task note) | [`backlog/docs/decisions.md`](backlog/docs/decisions.md) + `backlog decision list` | When making a non-trivial decision |
| Project glossary / domain terminology | [`backlog/docs/glossary.md`](backlog/docs/glossary.md) | When you hit an unfamiliar term |
| Things deliberately deferred — do NOT implement unprompted | [`backlog/docs/deferred.md`](backlog/docs/deferred.md) | Before adding features that "seem missing" |
| Backlog skill (`backlog` CLI + task/doc/decision workflow) | [`.agents/skills/backlog/SKILL.md`](.agents/skills/backlog/SKILL.md) | Auto-loaded by the backlog skill trigger; also when driving `backlog` manually |

> **Skills location.** Canonical: `.agents/skills/<name>/` (agent-agnostic, **vendored/committed**). `.claude/skills/` are symlinks created by `scripts/skills-bootstrap.sh` so Claude Code can auto-trigger them. Skills are not fetched from anywhere — to refresh the symlinks (e.g. after adding a skill), re-run `scripts/skills-bootstrap.sh`.

## Load-on-demand rule

Don't read every wiki file at session start. Pick the file matching the task — they are sized to be loaded individually. The table above tells you *when* to load *what*.

## Session handoff

When ending a session mid-task, record what's done, what's next, and any blocker on the active task:

```sh
backlog task edit <id> --notes "Session pause $(date -I). Done: <X>. Next: <Y>. Blocker: <Z|none>."
```

When starting a session, read the most-recently-touched in-progress task (`backlog task list -s "In Progress" --plain`, then `backlog task <id> --plain`) before doing anything else. Local, versioned in-repo, agent-agnostic.

Details: [`backlog/docs/working-on-tasks.md`](backlog/docs/working-on-tasks.md).

## Working on tasks

This repo tracks work **locally** with [Backlog.md](https://github.com/MrLesk/Backlog.md) — tasks are markdown under `backlog/`, no external tracker. Read [`.agents/skills/backlog/SKILL.md`](.agents/skills/backlog/SKILL.md) (and run `backlog instructions overview`) before driving `backlog`. It's **forge-agnostic**: git is plain branches merged into the default branch; a remote (GitHub/GitLab/Codeberg/Radicle/none) is an optional mirror, not an issue tracker.

## Quick dev loop

<TBD: stack-specific commands — filled at bootstrap. Full list in `backlog/docs/commands.md`.>

## Hard rules (don't violate)

- **Never commit without explicit user request.** Even mid-task, after accepting a plan, stop and ask. Acceptance of plan ≠ acceptance of commit.
- **Don't add features, refactor, or introduce abstractions beyond what the task requires.** Bug fix = bug fix, not surrounding cleanup.
- **Don't pre-empt later milestones.** If a task is scoped to a later milestone (Backlog.md label/milestone), don't half-implement it during earlier work.
- **All project docs live under `backlog/docs/`.** That's the single knowledge tree (tasks, docs, and decisions all live under `backlog/`).

## Code ownership

<TBD: maintainer name / decider — filled at bootstrap>
