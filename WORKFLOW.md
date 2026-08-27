# WORKFLOW.md — the method

> A repeatable operating system for running software projects with a human
> founder, human collaborators, and AI sessions in defined roles. Extracted
> from the gollai project (2026), where it took a codebase from rebrand to a
> live multi-tenant platform in six days — with every decision, brief, and
> incident written down.

This document is vendor-neutral. Roles are abstract — **Founder**, **CTO
session**, **Executor session**, **Strategy advisor** — and vendors are cast
into those roles through lanes (see *The lane model*). Any model, any vendor,
any mix; the method does not change.

Maturity labels follow the master plan: ✅ proven in production ·
🧪 included but unproven.

## The core idea

**Sessions die; the repo remembers.** Any AI session (and any human) can leave
at any moment. So the project's brain lives in files, not in anyone's head or
any chat history. A new session reads three files and is fully oriented in
five minutes. Everything else follows from this.

## The roles

| Role | Who | Does | Never does |
|------|-----|------|-----------|
| **Founder** | the human decider | Decides. Merges every PR. Runs ops from copy-paste commands. Owns external relationships (investors, customers, vendors). The only person who can change scope or unrecord a decision. | Gets asked to re-decide something already recorded. |
| **CTO session** | one dedicated session (any vendor) | Owns the roadmap, writes briefs, reviews every PR against its brief, keeps STATUS.md true, records decisions, guides ops step-by-step. | **Writes feature code. Ever.** The moment it codes, nobody is checking the work. |
| **Executor sessions** | founder + executor sessions (any vendor) | Pick a brief, claim it, build it, prove the acceptance checklist in a PR. | Works without a brief. Out-of-brief ideas go to STATUS *Proposals*, not into the diff. |
| **Strategy advisor** *(optional)* | a strategy-advisor session or project | Market analysis, investor materials, objection handling, business model. Advises. | Sets technical scope. Invents numbers. Decides. |

The founder is the only intersection point. Advice flows up to the founder;
decisions flow down through the CTO session into the roadmap and briefs.
Two sessions must never both be able to set scope — that's how a roadmap and
a pitch drift apart.

Requirements the strategy advisor raises flow one way: the founder decides →
the CTO session records + briefs.

**A CTO session ends by writing, never by only talking.** Before the session
closes it MUST record: (1) every decision made — in the plan it affects,
date + who decided; (2) every rejected option — one line in `DECISIONS.md`
(option, why rejected, date); (3) every open question — `FOUNDER.md` Inbox
(type question) or STATUS *Proposals*; (4) agreed work — briefs in
`docs/briefs/` queued in STATUS. A CTO session that produced none of these
writes a dated STATUS line saying the discussion produced no outcomes —
silence is also recorded. Executor sessions already persist by construction:
every pickup, finish, and block is a dated STATUS line and a PR — the
asymmetry this rule closes is on the advisory side.

## The lane model 🧪

A lane is one execution slot on an AI vendor subscription. A subscription is
the paid account (Claude, ChatGPT, Gemini, Kimi — one seat, one API key);
lanes are the parallel sessions you allow it to run — Claude might carry
3 lanes, Kimi 2. The method defines roles; lanes are how real, purchased
vendor capacity gets cast into those roles. A CTO lane runs the CTO session;
executor lanes run executor sessions; a strategy lane runs the strategy
advisor. The role is defined by the files it owns and the rules it follows —
not by the vendor behind the lane. Swap the vendor under a lane and the
project does not notice: the repo is the memory, the lane is just compute.

Lanes are what make parallelism and routing safe. Two executor lanes — same
vendor or different — can build in parallel because work is claimed in
STATUS.md before the first commit, and one brief equals one branch. The
founder (or the TechOfficer console) routes the next brief to whichever lane
is coldest. STATUS.md front matter carries the active lane name, so anyone —
human, session, or tool — can see who is driving. Accepted risk, recorded in
DECISIONS.md: cross-project board coherence (aggregating many repos' boards)
is the sister console's job by design — the kit defines state, not
aggregation.

This section is the concept only. The full lane schema — front-matter fields,
ownership rules, routing semantics — is part of the machine-readable contract
in `INTEGRATION.md`.

## The repo memory (what every project carries)

```
{PROJECT}/
├── AGENTS.md              # project rules + the operating protocol (canonical;
│                          #   CLAUDE.md / GEMINI.md are thin adapters pointing to it)
├── STATUS.md              # THE board: milestone, in-progress, ready queue,
│                          #   blocked-on-founder, proposals, activity log —
│                          #   YAML front matter on top for machine readers 🧪
├── FOUNDER.md             # the founder's voice in the repo (see below) 🧪
├── DECISIONS.md           # append-only decision ledger: rejected options,
│                          #   accepted risks, cross-cutting rulings 🧪
└── docs/
    ├── plans/             # numbered, highest = latest; 00-INDEX.md is the legend
    │   ├── 00-INDEX.md
    │   ├── 01-vision.md   # what & why (rarely changes)
    │   ├── 02-program-plan.md   # THE roadmap: milestones w/ exit checklists 🧪
    │   └── 0N-...         # one plan per major track/decision area
    ├── briefs/            # execution units; README.md holds index + template 🧪
    ├── handoff/           # numbered session handoffs, highest = latest 🧪
    ├── ops/               # runbooks: deploy, backups, incident fixes
    └── reports/           # bi-weekly progress reports (HTML/MD) 🧪
```

(This kit repo itself deviates deliberately: its roadmap is the locked
`docs/briefs/000-master-plan.md`, not `docs/plans/` — accepted risk,
recorded in DECISIONS.md.)

## The loop (one unit of work, start to finish)

brainstorm → **decision recorded** (plan + dated STATUS line) → brief →
**claim in STATUS before first commit** → build on `brief/<id>` →
**PR proves the acceptance checklist** (boxes ticked, verify output pasted) →
CTO review vs brief (explicit verdict) → the founder merges → board updated.

1. **Brainstorm** — founder + CTO session discuss; options end with a
   recommendation, not a menu.
2. **Decision recorded** — in the relevant plan + a dated STATUS activity line.
   Recorded decisions are not re-litigated; changing one is a new decision,
   made explicitly.
3. **Brief written** — self-contained: goal, code-reality grounding
   (file:line), scope with explicit OUT list, plan, **acceptance checklist**,
   exact verify commands. Good briefs need zero questions.
4. **Claimed** — executor removes the brief from the front-matter ready queue
   (THE ready queue — the single authoritative representation, Contract v2.1),
   adds self + branch `brief/<id>` to STATUS *In progress* BEFORE the first
   commit. No brief, no code.
5. **Built** — one brief = one branch (off main) = one PR = one session.
6. **PR proves the checklist** — every box ticked in the PR body, verify
   command output pasted. An unticked box is stated as unticked, with why.
7. **CTO review vs the brief** — matches / gaps / out-of-scope diff. Verdict
   is explicit ("APPROVED" / "CHANGES"). Reviewer never merges.
8. **Founder merges.** Auto-deploy to the dev environment if wired.
9. **Board updated** — item moved, dated activity-log line written by whoever
   finished it.

## The rules (each one was paid for)

1. No brief, no code. Out-of-brief ideas → STATUS *Proposals*.
2. One brief = one branch (off main) = one PR = one session.
3. **Never stack PRs** — squash-merge makes stacked branches conflict on
   every subsequent merge. Branch from main, always.
4. Never push to main. The founder merges; that's the control point.
   Accepted risk, recorded in DECISIONS.md: the founder is the single merge
   point — no delegation or timeout path; waits happen and
   `needs_input`/`blocked` states record them.
5. Green build to merge. CI runs on every PR (verify the triggers actually
   fire — a wrong branch name in CI config means zero checks silently).
   Accepted risk, recorded in DECISIONS.md: this kit repo is docs-only and
   runs no CI — rule 5 applies to code repos; here the quoted greps, parses,
   and installer dry-runs in each PR are the verification.
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
    with an explicit "✅ APPROVED" line. For any PR with visual output, the
    PR body includes side-by-side mock-vs-implementation screenshots at
    390px width (seed/mock on one side, shipped on the other) plus a
    measured "horizontal overflow = 0px" line; screenshots may live under
    `docs/reports/<brief-id>/`.
12. Every task ends with the verification block (see AGENTS.md).
13. **Merge closes the loop** ✅ — when a PR merges, the next CTO session on
    that repo removes the delivered item from the queue, sets `state: idle`
    and `lane: null` if unclaimed, and logs the merge as a dated activity
    line. A STATUS.md claiming merged work is out of contract. **And a drain
    survives a merge**: when a git conflict pits a removed queue line against
    a branch that still carries it, the removal wins — resolve STATUS.md by
    **union of changes** (both sides' removals apply, both sides' additions
    survive), never union of lines, which resurrects claimed work into the
    ready queue. (Paid for: a consuming repo's merge resolution chose "keep
    the queue line" and a claimed, merged brief re-entered the ready queue.)
14. **Measure the thing, not a proxy for it.** A status code, an exit code, a
    line count, a file's existence, a green suite that never finished — each
    is a proxy, and a check that reads a proxy produces confident false
    verdicts. The check that decides a claim must observe the behavior the
    claim is about. Two of the ~16 times one deployment paid for this rule:
    an HTTP 404 from a scope-limited token read as "this repo has no
    workflow" (it was unreadable, not un-onboarded — cost the founder a
    day), and `test -r` on a file that did not exist printing the *success*
    line of a security check — there was nothing to secure. When the real
    thing cannot be observed from where you run, write **UNMEASURED** with
    the reason (rule 12's escape hatch) — never substitute the proxy.

## Briefs 🧪

Live in `docs/briefs/`, indexed in its README, lifecycle:
📝 Draft → ✅ Ready (queued in STATUS) → 🔨 Claimed → 🔍 In review (PR #) →
✔ Done / 🗄 Superseded. Template in `docs/briefs/README.md`. A good brief
needs zero questions: goal ¶, **grounding (file:line)**, scope with explicit
OUT list, REUSED vs NEW, steps, acceptance checklist, exact verify commands.

## The rituals

- **Activity log** (STATUS.md) ✅: dated line for every pickup/finish/block —
  newest first, terse, written by the person who did the thing.
- **Session handoff** 🧪: before a session's context runs out, it writes
  `docs/handoff/NNN-*.md` — state, rulings, gotchas, queue, waiting-on list.
  A new session boots by reading: latest handoff → STATUS.md → open PRs →
  the roadmap. (Prompt provided.)
- **Bi-weekly report** 🧪 (`docs/reports/`): a visual progress report against
  the milestone exit checklist — done/remaining as inspectable items, never a
  bare percentage. "60% based on what?" must always have the answer:
  *this checklist.* Due every second week, on a fixed weekday.
- **Milestone exit checklists**: every milestone is 8–12 verifiable items,
  each with its own falsification test. Progress = boxes, not feelings.
- **Incidents**: any live issue → dated STATUS entry (cause, fix, follow-up
  proposal that prevents recurrence).

## FOUNDER.md — the founder's voice in the repo 🧪

Sessions are asynchronous and disposable; the founder is not always at the
keyboard when a session boots. `FOUNDER.md` is the async founder→session
channel: the founder (or the TechOfficer console) appends dated messages to
its Inbox, and every session reads them without a meeting.

Each message has one of four types:

- **directive** — an order. Unconsumed directives **block new brief claims**.
- **context** — information sessions should know; does not block.
- **question** — something the founder wants answered (via STATUS.md or a PR).
- **answer** — a response to a question/signal, from the founder or a
  permitted tool append (e.g. the console standup); does not block.
  Any other type is surfaced verbatim and flagged non-conformant — never
  silently dropped, never guessed.

The ritual: sessions read `FOUNDER.md` **at boot and at each brief claim**.
Consuming a message means moving it to the Consumed section and adding a
dated STATUS.md activity line recording the consumption. A session that
claims a brief while an unconsumed directive sits in the Inbox is breaking
the protocol — directives exist precisely so the founder can stop or steer
work without being online when a session starts.

## Session boot procedures

The short paste-prompts (kit `QUICKSTART.md`, or `docs/ops/boot-prompts.md`
in the target repo) name a procedure below. The prompt says who you are;
this section is the job.

### Source document intake (when the founder supplies a spec/PDF — any boot)

1. Save the document under `docs/intake/` and commit it — the repo must
   remember it, not the chat (a successor session re-reads it after a
   handoff).
2. Read it COMPLETELY before interviewing.
3. Extract candidate vision, milestones, constraints, and hard rules. List
   every claim you could not verify and every internal contradiction —
   flag them, don't copy them into plans.
4. Interview the founder only on the gaps and the decisions the document
   leaves open.
5. Where a plan claim is grounded in the document, cite it (file +
   section/page). The document is input, not a decision record — decisions
   still land in the plans with date + decider. On an existing project the
   document never replaces the audit; code reality wins where they disagree.

### CTO boot — new project (no roadmap yet)

1. Read `AGENTS.md`, this file, `FOUNDER.md`, and `STATUS.md`. If the founder
   has a source document, run the intake above first — then the interview
   below covers only what the document leaves open.
2. **Drift checkpoint (rule 13), before claiming anything:** run
   `git log main --oneline -15` and prune any queue item whose PR appears
   merged — a STATUS claiming merged work is out of contract.
3. Interview the founder — ONE focused round of questions covering: the
   product and its user; what "milestone 1 done" means as a real proof (live
   deployment / first user / first revenue — reachable in 4–8 weeks); who
   executes (founder / collaborators / executor sessions); stack and deploy
   preferences; budget/time constraints; hard "never do this" rules for
   `AGENTS.md`.
4. From the answers, write `docs/plans/01-vision.md` and fill
   `docs/plans/02-program-plan.md` per its skeleton — milestones, an M1 exit
   checklist of 8–12 items where EVERY item names its verification, tracks,
   week map, sequenced brief queue, risks with tripwires. Extend `AGENTS.md`
   with the stack rules the founder gave you.
5. Open ONE PR with all of it on branch `cto/roadmap-v1`. After the founder
   merges, write the first 2–3 briefs so the Ready queue is never empty.

### CTO boot — existing project (repo has real history)

Your first deliverable is an **audit, not a plan** ✅ — plans built on stale
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
   acceptance — don't halt anyone). Draft the "how we work now" message the
   founder can send collaborators: what changed, what they do differently
   tomorrow, where the board is.

### CTO boot — successor session (a handoff exists)

Read, in order: the HIGHEST-numbered file in `docs/handoff/` → `STATUS.md` →
`FOUNDER.md` → open PRs → `docs/plans/02-program-plan.md` → this file. Then
run the **drift checkpoint (rule 13)** before claiming anything:
`git log main --oneline -15`; prune any queue item whose PR appears merged —
a STATUS claiming merged work is out of contract. Then prove you're
oriented: (a) a one-paragraph state summary, (b) what's in flight and with
whom, (c) the founder's open action items. Pick up the queue where the
handoff left it. Standing rulings stay ruled — a session change resets
nothing.

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
   find, or an acceptance item can't be met: STOP and tell the founder with a
   recommendation.
4. Verify per the brief's Verify section — run the commands, read the output.
5. Open ONE PR: the brief's acceptance checklist in the body, each box
   ticked, verify output pasted; unmet boxes stay unticked with an honest
   note. Add a dated STATUS Activity-log line. The CTO reviews vs the brief;
   address findings on the SAME branch; the founder merges.

### CTO standing rules of engagement (all variants)

Copy-paste commands for any ops work (with expected output and what failure
looks like) · recommendations, not option menus · when the founder decides,
record it (plan + dated STATUS line) and never re-litigate · keep `STATUS.md`
true at all times · review every PR against its brief with an explicit
verdict before the founder merges · no watch loops — the founder pings you.

### Strategy advisor pack 🧪

When the founder says "prepare the strategy advisor", the CTO session follows
the CEO pack (`docs/appendix/ceo-pack.md` in this kit, 🧪 unproven) and
delivers the pack as a PR.
