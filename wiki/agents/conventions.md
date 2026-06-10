# Coding conventions

Generic conventions that apply regardless of stack. Stack-specific rules (language idioms, framework patterns, formatter config) go in the **Stack-specific** section at the bottom — filled at bootstrap.

## File naming

- Pick **one** casing per category and stick with it (e.g. PascalCase for components, kebab-case for scripts, snake_case for modules). Document the choice in Stack-specific.
- One unit per file (one component, one class, one primary export). Co-locate tightly related sibling files (CSS module next to component, test next to source).

## Imports

- Cross-folder imports go through a folder's barrel / public entry, not into its internals. The barrel is the contract; internals are not.
- Prefer path aliases (`@core`, `@services`, ...) over deep relative paths once the project grows past ~3 directory levels.

## Comments

- **Default: no comment.** Names do the work.
- Add only when the *why* is non-obvious: hidden constraint, subtle invariant, workaround for a specific bug, surprising behavior.
- Never explain *what* the code does — well-named identifiers already do that.
- Don't reference the current task / fix / PR ("added for X", "handles case from #123") — that belongs in the commit message, not the source file.

## Commits

- Conventional Commits by default (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `release:`). If your project uses a different convention, document in Stack-specific.
- GPG-signed. The `gpg-uid-guard` pre-commit hook refuses to sign if `user.email` has no matching UID on `user.signingkey`.
- **Never commit without explicit user request.** This rule supersedes any plan acceptance.

## Phase / scope discipline

- Don't pre-empt later milestones. If something is tagged `milestone:m5`, don't half-implement it during M2 work.
- If a refactor would be cleaner alongside a bug fix but isn't required, defer it — open a Radicle issue instead.
- Don't add error handling, fallbacks, or validation for scenarios that can't happen at the call site. Trust internal code; validate only at system boundaries (user input, external APIs).

## UI / output text (if applicable)

- Terse. Lowercase. No emoji in UI text or logs unless the project explicitly opts in.

## When in doubt

- Read the relevant ADR in [`../adr/`](../adr/).
- Check Radicle issues for active work: `rad issue list --all`.
- Ask the user. Solo project — they're the only deciding authority.

---

## Stack-specific

<TBD: filled at bootstrap based on Q2 (primary stack). Examples of what goes here:

- **TypeScript**: strict mode rules, framework version, state management policy
- **Rust**: edition, MSRV, clippy lint level, error handling style (anyhow vs thiserror)
- **Python**: version, type-hint policy, formatter (ruff/black), test runner
- **CSS**: methodology (modules, tokens, utility framework, none)
- **Plugin/extension model**: if the project has one
- **Test strategy**: contract, integration, E2E split + tools

Keep each subsection short. Link out to ADRs for anything that needed a real decision.>
