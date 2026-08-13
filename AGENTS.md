# AGENTS.md — operating rules for this repo

Every session working in this repository operates under these rules, from this
moment on (set by the founding CTO session, brief 000):

- **No brief, no code.** One brief = one branch = one PR = one session.
- **Never push to main; the founder merges.**
- **Claim work in STATUS.md before the first commit; bump `updated` on every touch.**
- **Blocked = say so immediately, with a recommendation.**
- **Honest states over fake data.**

Read `FOUNDER.md` at boot and at each brief claim. Unconsumed directives block
new brief claims. The roadmap and briefs live in `docs/briefs/000-master-plan.md`.

**Brief id scheme (Contract v2.1):** this repo uses **P-NNN** for kit briefs
(zero-padded three digits: id `P-NNN` → branch `brief/P-NNN` → file
`docs/briefs/P-NNN-<slug>.md`); **B-NNN** is reserved for product briefs.
Bare-number legacy (e.g. branch `brief/009`) is grandfathered — tolerate on
read, write the canonical form.

## Cold boot ("hey CTO" / "take the next brief" / "new project")

A trigger phrase with no other context means: orient from the repo, not from
chat history. Read, in order:

1. `AGENTS.md` (this file) → `STATUS.md` front matter → `FOUNDER.md` Inbox
   → open PRs (`git branch -r` / `gh pr list`) → the roadmap
   (`docs/briefs/000-master-plan.md`) → `DECISIONS.md`.
2. Drift checkpoint (rule 13): `git log main --oneline -15`; prune any queue
   item whose PR appears merged — a STATUS claiming merged work is out of
   contract.
3. Report back before acting: project, phase, lane state, in-review items,
   next queue item, unconsumed founder messages, open blockers.

Then follow the matching boot procedure in `WORKFLOW.md` § Session boot
procedures.

## Verification rule

At the end of every task, print: (1) a 2–3 sentence summary of what changed;
(2) the exact commands to verify it works; (3) what error messages would
indicate failure. If acceptance criteria can't be met, stop and explain —
don't push a broken implementation. This is a docs-only repo: "verify" means
the greps, parses, and installer dry-runs the brief names, quoted in the PR.
For any PR with visual output, the PR body also includes side-by-side
mock-vs-implementation screenshots at 390px width plus a measured
"horizontal overflow = 0px" line; screenshots may live under
`docs/reports/<brief-id>/`.
