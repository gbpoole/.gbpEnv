# Architecture Decision Records

This directory stores Architecture Decision Records (ADRs): short documents
that capture important technical decisions and their tradeoffs.

## When to add an ADR
- A change affects architecture, deployment, security posture, or long-term maintenance.
- A decision has meaningful alternatives or tradeoffs worth recording.
- You want future contributors to understand why a choice was made.

## File naming
- Use a zero-padded number and slug: `NNNN-short-title.md`
- Example: `0001-shell-plugin-loading-order.md`

## Process
1. Copy `0000-template.md` to the next number.
2. Fill in context, decision, and consequences.
3. Set status to `Accepted` once implemented.
4. If replaced, mark old ADR as `Superseded by NNNN`.

## Index
- `0000-template.md` - ADR template
- `0001-session-and-decision-records.md` - Adopt `AGENT.md` and ADR workflow
