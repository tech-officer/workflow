# P-004 — Contract v2.1: queue semantics, FOUNDER.md types, canonical id mapping, DECISIONS.md status

**Status:** 🔨 Claimed (2026-08-05, lane `kimi-2`, branch `brief/P-004`)
**Source:** founder-assigned brief (2026-08-05 methods analysis — gap fixes 3, 4, 5, 10, 16, 21).
**Center:** INTEGRATION.md is the deliverable center; WORKFLOW.md / templates / prompts conform to it.
INTEGRATION.md version header becomes v2.1; every change also added to its changelog section, one line each.

## Context (gaps re-verified at claim)

- **Gap 3:** TWO ready-queue representations — front-matter queue (INTEGRATION.md:71)
  vs the prose "Ready to pick up" table (templates/STATUS.md:54-60,
  templates/AGENTS-section.md:15-16) — plus a THIRD in
  templates/02-program-plan.md §5 "Brief queue (sequenced)". Sync undefined;
  tools must ignore prose, so they can silently diverge.
- **Gap 4:** claim-time semantics undefined — contract calls queue "The ready
  queue", rule 13 prunes only merged items, but Brief 009 dogfooded adding a
  queue entry AT CLAIM time (docs/briefs/009-contract-v2.md:47-49).
- **Gap 5:** id mapping ambiguous — queue ids "B-NNN" (INTEGRATION.md:76) vs
  this repo's own branch `brief/009` and file `009-contract-v2.md`.
- **Gaps 10/21:** FOUNDER.md message types are exactly directive|context|question
  (INTEGRATION.md §2), but a real entry of type "answer" exists
  (FOUNDER.md:27-28) — written by the TechOfficer console's standup downlink;
  handling of unknown types undefined.
- **Gap 16:** founder's write-rights on STATUS.md undefined — template says
  "everyone updates this file", field ownership assigns every field to
  CTO/executors.
- DECISIONS.md exists as a convention (P-003) with machine-readable status
  deferred to v2.1 — this brief settles it.

## Slices

### Slice 1 — Queue: one source, defined lifecycle

- INTEGRATION.md: the front-matter queue is THE ready queue — single
  authoritative representation. Lifecycle: an item ENTERS when the CTO queues
  it (state ✅ Ready); LEAVES at claim (executor removes it in the claim
  commit), at prune (rule 13), or when the CTO withdraws it. A claimed brief
  lives in the claiming session's state/current_task, NOT in the queue.
- templates/STATUS.md: prose "Ready to pick up" table replaced with: "The
  machine queue in the front matter above is the ready queue (Contract v2.1);
  this section is commentary, never data."
- templates/02-program-plan.md §5: one line — §5 is the sequenced ROADMAP
  view (long-term order); the STATUS front-matter queue is what sessions claim
  from; on conflict, STATUS wins.
- WORKFLOW.md loop text where it describes claiming, and
  templates/AGENTS-section.md's executor line, point at the front-matter queue.

### Slice 2 — Canonical id mapping

- INTEGRATION.md: queue id, branch, and brief filename are canonically B-NNN
  (projects may use another prefix letter — e.g. this repo's P-NNN — but ONE
  scheme per repo, stated in its AGENTS.md): id "B-NNN" → branch
  "brief/B-NNN" → file "docs/briefs/B-NNN-<slug>.md". Zero-padded three digits.
  Legacy note: pre-v2.1 bare numbers (branch brief/009, file
  009-contract-v2.md) grandfathered; TOLERATE both when reading, always WRITE
  canonical.
- This repo's AGENTS.md states its own scheme: P-NNN for kit briefs, B-NNN
  reserved for product briefs.

### Slice 3 — FOUNDER.md type "answer" + unknown-type rule

- INTEGRATION.md §2: types become directive | context | question | answer.
  answer = a response to a question/signal, written by the founder OR by a
  permitted tool append (e.g. the console standup); consumed like any other
  entry. Unknown-type handling: a reader MUST surface the entry verbatim and
  flag it non-conformant — never silently drop, never guess the type.
- templates/FOUNDER.md format comment lists the four types.
- This repo's FOUNDER.md conformed: the 2026-08-03T21:49Z "answer" entry moved
  to Consumed unchanged, with a dated STATUS activity line ("consumed under
  v2.1 — type now legal").

### Slice 4 — Founder write-rights on STATUS.md

- INTEGRATION.md ownership section: the founder may append to the prose
  activity log and may answer questions via STATUS (existing convention),
  setting updated on any touch; the founder does not edit front-matter fields
  except to RELEASE a lane (state idle + lane null) as an emergency unblock —
  every such manual edit logged in the activity log with reason.

### Slice 5 — DECISIONS.md machine-readable status

- INTEGRATION.md: DECISIONS.md is a STANDARD kit file (installed by install.sh
  since P-003); tools MAY read it; the H2 entry format
  (## YYYY-MM-DD — title / Decision: / Rejected: / Accepted risk: / Who:) is
  the parse contract — entries matched on that heading pattern; prose between
  entries ignored. Tools never write it (sessions write it per the
  advisory-persist rule).

## Acceptance checklist

1. INTEGRATION.md header reads v2.1; changelog gains one line per slice;
   `git diff INTEGRATION.md` quoted in full.
2. Grep proof: no file still instructs claiming from a prose table; the three
   queue representations reduced to one authority + two clearly-labeled
   non-authoritative views (quote the two disclaimer lines).
3. Canonical mapping paragraph quoted; tolerance/legacy note quoted; this
   repo's AGENTS.md scheme line quoted.
4. FOUNDER.md: four types in INTEGRATION.md §2 AND in templates/FOUNDER.md
   comment (grep proof); the stray entry moved Inbox→Consumed verbatim
   (`git diff FOUNDER.md` shows ONLY that move); STATUS activity line quoted.
5. Founder-rights paragraph quoted.
6. DECISIONS.md status paragraph quoted.
7. Self-consistency sweep: grep INTEGRATION.md for "v2" references needing
   v2.1 framing (historical changelog lines stay as-is — they are history).
8. Ripples fixed or reported: WORKFLOW.md, templates/AGENTS-section.md,
   templates/STATUS.md, templates/02-program-plan.md,
   prompts/2-executor-session.md, prompts/executor-boot.md — for each, a
   quoted conforming hunk or "checked, no change needed, because …".
9. Drift checkpoint run at claim (quoted); STATUS.md front matter per
   contract; brief persisted at docs/briefs/P-004-contract-v2-1.md.
10. PR body: numbered slices, quoted evidence after every claim, Deviations
    (empty if none), explicit verdict-request line.

## OUT OF SCOPE (not touched)

ceo-pack install, CTO/PM rename sweep, rule-count staleness, overlay appendix,
installer label staleness (all P-005); any code in any other repo.

## Downstream

After merge, the TechOfficer console gets a compatibility-check brief (B-122:
parse this repo's updated STATUS.md/FOUNDER.md, verify the reader tolerates
v2.1, fix if shaken out). Noted here; not implemented in this brief.

## Verify

- `git diff main INTEGRATION.md` — v2.1 header + five slices + changelog.
- `grep -rn "Ready to pick up" templates/ prompts/ WORKFLOW.md` — no claim-from-prose instruction remains.
- `grep -n "directive|context|question|answer" INTEGRATION.md templates/FOUNDER.md` — four types both places.
- `git diff main FOUNDER.md` — only the entry move.
