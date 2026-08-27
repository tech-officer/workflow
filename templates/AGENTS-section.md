_Maturity: ✅ proven in production_

<!-- Append this block to the project's AGENTS.md (or start AGENTS.md with
your stack rules and paste this below them). Every coding session on
this repo reads AGENTS.md automatically — this is how the protocol becomes
self-enforcing. -->

## Team & status protocol (read this every session)

This project runs the **TechOfficer workflow** — **{FOUNDER}** (founder/decider),
a dedicated **CTO session (any vendor)** (roadmap + briefs + review — writes NO
feature code), and **executor sessions** (yours, probably). Full operating
model: **`docs/plans/04-operating-model.md`** — read it once, then:

- **Executor sessions work from a BRIEF.** Read root **`STATUS.md`**, pick a
  brief from its front-matter ready queue (full text in `docs/briefs/`),
  **claim it** (remove it from `queue`, add yourself + branch `brief/<id>` to
  In-progress) before the first commit. **No brief, no code** — out-of-brief
  ideas go to STATUS *Proposals*, not into your diff.
- **A PR must prove its brief's acceptance checklist** — tick it in the PR
  body with the verify-command output pasted; when an autonomous runner opens
  the PR (runners use their own PR template), the ticked checklist lands in
  `docs/reports/<brief-id>/` instead. **A box you could not measure is marked
  `UNMEASURED` with the reason, never ticked** — an honest gap outranks a
  ticked guess. PR → CTO review vs brief → {FOUNDER} merges.
- **When you pick up / finish / get blocked:** update `STATUS.md`
  (In-progress table + a dated Activity-log line). Blocked = say so
  immediately, with a recommendation.
- **CTO session:** read the latest handoff in `docs/handoff/` (highest
  number) first; you own `docs/plans/02-program-plan.md`, `docs/briefs/`,
  and the STATUS board. You write no feature code.
- One brief = one branch = one PR = one session · never stack PRs (squash-
  merge makes stacked branches conflict) · green build to merge · **never
  push to `main`**.

## Cold boot ("hey CTO" / "take the next brief" / "new project")

A trigger phrase with no other context means: orient from the repo, not from
chat history. Read, in order:

1. `AGENTS.md` (this file) → `STATUS.md` front matter → `FOUNDER.md` Inbox
   → open PRs (`git branch -r` / `gh pr list`) → the roadmap
   (`docs/plans/02-program-plan.md`) → `DECISIONS.md`.
2. Drift checkpoint (rule 13): `git log main --oneline -15`; prune any queue
   item whose PR appears merged — a STATUS claiming merged work is out of
   contract.
3. Report back before acting: project, phase, lane state, in-review items,
   next queue item, unconsumed founder messages, open blockers.

Then follow the matching boot procedure in `docs/plans/04-operating-model.md`
§ Session boot procedures.

## Verification rule

At the end of every task, print: (1) a 2–3 sentence summary of what changed;
(2) the exact commands to verify it works; (3) what error messages would
indicate failure. If acceptance criteria can't be met, stop and explain —
don't push a broken implementation.

**Measure the thing, not a proxy for it** (workflow rule 14). A status code,
an exit code, a line count, a file's existence, a green suite that never
finished — each is a proxy, and a check that reads a proxy produces confident
false verdicts. The check that decides a claim must observe the behavior the
claim is about. An acceptance item you cannot observe from where you run (no
device, no browser, no production access) is marked **UNMEASURED** with the
reason — never ticked on a proxy's word, never silently dropped.

For any PR with visual output, the PR
body also includes side-by-side mock-vs-implementation screenshots at 390px
width (seed/mock on one side, shipped on the other) plus a measured
"horizontal overflow = 0px" line; screenshots may live under
`docs/reports/<brief-id>/`.
