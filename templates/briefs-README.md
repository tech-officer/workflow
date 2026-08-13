_Maturity: 🧪 included but unproven_

# Execution briefs — {PROJECT}

> A **brief** is the unit of work: self-contained enough that one session (or
> person) executes it start-to-finish without asking questions. Written by the
> CTO session from `../plans/02-program-plan.md`; executed by an executor;
> merged by {FOUNDER}.
>
> **Process:** `../plans/04-operating-model.md`. Claim in `STATUS.md` before
> touching code. One brief = one branch (`brief/<id>`) = one PR.

## Lifecycle

`📝 Draft` → `✅ Ready` (queued in STATUS) → `🔨 Claimed (by …)` →
`🔍 In review (PR #)` → `✔ Done` / `🗄 Superseded`.
The CTO updates the status line at the top of each brief.

## Index

| Brief | Title | Status | Owner |
|-------|-------|--------|-------|

## Template (copy for every new brief)

```markdown
# BRIEF <id> — <title>

> Status: 📝 Draft · Owner: (unclaimed) · Branch: brief/<id> · Roadmap: 02 §5 <id>
> Size: S/M/L · Written: <date> by CTO

## Goal (one paragraph)
What exists when this is done, and why it matters to the milestone.

## Grounding (code reality — file:line)
What exists today. The executor starts from these anchors, not from search.
The CTO verifies these against the actual code BEFORE writing the brief —
a brief grounded on stale claims wastes an executor's whole session.

## Scope
- In: …
- **Explicitly OUT:** …

## REUSED vs NEW
- REUSED: …
- NEW: …

## Plan (steps)
1. …

## Acceptance checklist (copy into the PR, tick each)
- [ ] …
- [ ] {always last: build + tests green, verify commands pass}

## Verify (exact commands + expected results + what failure looks like)
```

## Dependencies / decisions needed
…
```
