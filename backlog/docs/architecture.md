# Architecture

Repo shape, data flow, key modules. Keep this **descriptive of the current state**, not aspirational. For decisions about why the architecture is what it is, see [`decisions.md`](decisions.md) / `backlog decision list`.

## Layout

<TBD: directory tree with one-line description per top-level dir, filled as the project grows. Example:

```
src/
  core/         # pure domain logic, no I/O
  services/     # cross-cutting services (event bus, registry)
  adapters/     # adapter implementations of ports
  ui/           # presentation
backlog/        # tasks, docs, decisions (this tree)
scripts/        # build / dev helpers
```
>

## Data flow

<TBD: how data moves through the system, key boundaries, sync vs async. One paragraph or a small diagram.>

## Key modules

<TBD: name + one-sentence purpose per major module. Link out to decisions where the choice mattered.>

## Layering rules

<TBD: which layers may import which, if enforced by lint (e.g. eslint-plugin-boundaries, dependency-cruiser, cargo deny). Link the decision.>
