_Maturity: ✅ proven in production_

# 04 — Operating model — how {PROJECT} works

> Owner: CTO session. {FOUNDER} locked this model on {DATE}.

## Roles

- **{FOUNDER}** — founder/decider. Merges every PR. Owns external
  relationships and ops execution (from copy-paste commands). The only
  person who can change scope or unrecord a decision.
- **CTO session** — one dedicated CTO session (any vendor). Owns: `02-program-plan`,
  `docs/briefs/`, PR review vs brief, `STATUS.md` truthfulness, decision
  records, ops guidance. **Writes no feature code** — the moment the
  reviewer writes the code, nobody reviews the work.
- **Executor sessions** — founder or executor sessions. Work ONLY from briefs.
- *(optional)* **Strategy advisor** — business analysis. Advises {FOUNDER};
  never sets technical scope. Requirements it raises flow: {FOUNDER} decides →
  CTO records + briefs.

**A CTO session ends by writing, never by only talking** — decisions (plan +
date + decider), rejected options (`DECISIONS.md`), open questions
(`FOUNDER.md` Inbox / STATUS *Proposals*), and agreed work (briefs queued in
STATUS) are recorded before the session closes; a session with no outcomes
writes a dated STATUS line saying so — silence is also recorded. (Executor
sessions already persist via STATUS.)

## The loop

brainstorm → **decision recorded** (plan + dated STATUS line) → brief →
**claim in STATUS before first commit** → build on `brief/<id>` →
**PR proves the acceptance checklist** (boxes ticked, verify output pasted) →
CTO review vs brief (explicit verdict) → {FOUNDER} merges → board updated.

## Rules

1. No brief, no code. Out-of-brief ideas → STATUS *Proposals*.
2. One brief = one branch (off main) = one PR = one session.
3. **Never stack PRs** — squash-merge makes stacked branches conflict on
   every subsequent merge. Branch from main, always.
4. Never push to main. {FOUNDER} merges; that's the control point.
5. Green build to merge. CI runs on every PR (verify the triggers actually
   fire — a wrong branch name in CI config means zero checks silently).
6. Blocked = say so immediately, with a recommendation.
7. Recorded decisions are not re-litigated; changing one is a new, explicit
   decision.
8. Secrets never in git / chat / argv / client bundles. Key hand-offs over a
   secure channel only.
9. Hidden resources answer **404, never 403** (a 403 confirms existence).
10. Honest states over fake data — in UIs, in dashboards, in progress claims.
11. Reviews state what was verified (tests run, build green, bundle
    grep-clean), and post an explicit verdict. If the reviewer account can't
    formally Approve on GitHub (same account as PR author), post a COMMENT
    with an explicit "✅ APPROVED" line.
12. Every task ends with the verification block (see AGENTS.md).
13. **Merge closes the loop** — when a PR merges, the next CTO session on
    that repo removes the delivered item from the queue, sets `state: idle`
    and `lane: null` if unclaimed, and logs the merge as a dated activity
    line. A STATUS.md claiming merged work is out of contract.

## Briefs

Live in `docs/briefs/`, indexed in its README, lifecycle:
📝 Draft → ✅ Ready (queued in STATUS) → 🔨 Claimed → 🔍 In review (PR #) →
✔ Done / 🗄 Superseded. Template in `docs/briefs/README.md`. A good brief
needs zero questions: goal ¶, **grounding (file:line)**, scope with explicit
OUT list, REUSED vs NEW, steps, acceptance checklist, exact verify commands.

## Rituals

- **Handoffs** (`docs/handoff/`, numbered): any session nearing context limit
  writes one; new sessions boot from the latest + STATUS + open PRs.
- **Bi-weekly report** (`docs/reports/`): progress vs the milestone exit
  checklist, visual, honest. Due every second {WEEKDAY}.
- **Incidents**: any live issue → dated STATUS entry (cause, fix, follow-up
  proposal that prevents recurrence).

## Session boot procedures

The short paste-prompts (kit `QUICKSTART.md`, or `docs/ops/boot-prompts.md`
in this repo) name a procedure below. The prompt says who you are; this
section is the job.

### Source document intake (when {FOUNDER} supplies a spec/PDF — any boot)

1. Save the document under `docs/intake/` and commit it — the repo must
   remember it, not the chat (a successor session re-reads it after a
   handoff).
2. Read it COMPLETELY before interviewing.
3. Extract candidate vision, milestones, constraints, and hard rules. List
   every claim you could not verify and every internal contradiction —
   flag them, don't copy them into plans.
4. Interview {FOUNDER} only on the gaps and the decisions the document
   leaves open.
5. Where a plan claim is grounded in the document, cite it (file +
   section/page). The document is input, not a decision record — decisions
   still land in the plans with date + decider. On an existing project the
   document never replaces the audit; code reality wins where they disagree.

### CTO boot — new project (no roadmap yet)

1. Read `AGENTS.md`, this file, `FOUNDER.md`, and `STATUS.md`. If {FOUNDER} has a source
   document, run the intake above first — then the interview below covers
   only what the document leaves open.
2. **Drift checkpoint (rule 13), before claiming anything:** run
   `git log main --oneline -15` and prune any queue item whose PR appears
   merged — a STATUS claiming merged work is out of contract.
3. Interview {FOUNDER} — ONE focused round of questions covering: the product
   and its user; what "milestone 1 done" means as a real proof (live
   deployment / first user / first revenue — reachable in 4–8 weeks); who
   executes (founder / collaborators / executor sessions); stack and
   deploy preferences; budget/time constraints; hard "never do this" rules
   for `AGENTS.md`.
4. From the answers, write `docs/plans/01-vision.md` and fill
   `docs/plans/02-program-plan.md` per its skeleton — milestones, an M1 exit
   checklist of 8–12 items where EVERY item names its verification, tracks,
   week map, sequenced brief queue, risks with tripwires. Extend `AGENTS.md`
   with the stack rules {FOUNDER} gave you.
5. Open ONE PR with all of it on branch `cto/roadmap-v1`. After {FOUNDER}
   merges, write the first 2–3 briefs so the Ready queue is never empty.

### CTO boot — existing project (repo has real history)

Your first deliverable is an **audit, not a plan** — plans built on stale
claims die in week one.

1. Audit the repo: what exists and what actually runs; build/test health
   (run them); CI truth — do checks REALLY fire on PRs (check trigger
   branches: a wrong branch name means zero checks, silently); deploy
   reality; secrets hygiene (anything sensitive in git history or bundles?);
   open branches/PRs and what they contain; every place where README/docs
   claims disagree with the code. Report findings with file:line evidence,
   flagging anything that surprised you.
2. **Drift checkpoint (rule 13), before claiming anything:** run
   `git log main --oneline -15` and prune any queue item whose PR appears
   merged — a STATUS claiming merged work is out of contract.
3. Then run the new-project interview (the interview step above) and write
   plans 01 + 02 **grounded in the audit**. One PR, branch `cto/roadmap-v1`.
4. Work already in flight gets short **retroactive briefs** (goal +
   acceptance — don't halt anyone). Draft the "how we work now" message
   {FOUNDER} can send collaborators: what changed, what they do differently
   tomorrow, where the board is.

### CTO boot — successor session (a handoff exists)

Read, in order: the HIGHEST-numbered file in `docs/handoff/` → `STATUS.md` →
`FOUNDER.md` → open PRs → `docs/plans/02-program-plan.md` → this file. Then
run the **drift checkpoint (rule 13)** before claiming anything:
`git log main --oneline -15`; prune any queue item whose PR appears merged —
a STATUS claiming merged work is out of contract. Then prove you're
oriented: (a) a one-paragraph state summary, (b) what's in flight and with
whom, (c) {FOUNDER}'s open action items. Pick up the queue where the handoff
left it. Standing rulings stay ruled — a session change resets nothing.

### Executor boot

1. Read `STATUS.md` (milestone + in-progress + blocked) so you don't collide
   with parallel work, then `FOUNDER.md`, then your brief's FULL text in
   `docs/briefs/` before writing any code.
2. CLAIM: remove the brief from the front-matter ready queue and add yourself
   + branch `brief/<id>` to STATUS *In progress* — this goes in your FIRST
   commit.
3. Build on `brief/<id>`, branched from latest main, inside the brief's
   scope — anything tempting but out-of-brief goes to STATUS *Proposals*,
   not into your diff. If the brief's grounding disagrees with the code you
   find, or an acceptance item can't be met: STOP and tell {FOUNDER} with a
   recommendation.
4. Verify per the brief's Verify section — run the commands, read the output.
5. Open ONE PR: the brief's acceptance checklist in the body, each box
   ticked, verify output pasted; unmet boxes stay unticked with an honest
   note. Add a dated STATUS Activity-log line. The CTO reviews vs the brief;
   address findings on the SAME branch; {FOUNDER} merges.

### CTO standing rules of engagement (all variants)

Copy-paste commands for any ops work (with expected output and what failure
looks like) · recommendations, not option menus · when {FOUNDER} decides,
record it (plan + dated STATUS line) and never re-litigate · keep `STATUS.md`
true at all times · review every PR against its brief with an explicit
verdict before {FOUNDER} merges · no watch loops — {FOUNDER} pings you.

### CEO pack

When {FOUNDER} says "prepare the strategy advisor", the CTO session follows
`docs/appendix/ceo-pack.md` (🧪 unproven) and delivers the `ceo-pack/` folder as a PR.
