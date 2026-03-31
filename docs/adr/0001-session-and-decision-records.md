# 0001: Session handoff and decision records

- Status: Accepted
- Date: 2026-03-31

## Context
Work continues across multiple sessions, and context can be lost between runs.
The repository needs a simple and consistent way to preserve immediate next steps
and long-lived architectural rationale.

## Decision
Use `AGENT.md` at the repository root as the canonical session handoff file.
Use `docs/adr/` for Architecture Decision Records and track important decisions
with numbered ADR files.

## Consequences
- Positive:
  - Session continuity improves with a single handoff location.
  - Architectural rationale is retained in a searchable history.
- Negative:
  - Requires lightweight maintenance during development.
  - Team members must follow naming and update conventions.

## Alternatives Considered
- Keep all notes only in commit messages: not sufficient for in-progress context.
- Use only issue tracker notes: not always available in local/offline workflows.

## References
- `AGENT.md`
- `docs/adr/README.md`
- `docs/adr/0000-template.md`
