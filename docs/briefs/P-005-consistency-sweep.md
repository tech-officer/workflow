# P-005 — Consistency sweep + overlay appendix

_✅ Ready → 🔨 Claimed 2026-08-05 (executor session, lane kimi-2, branch
`brief/P-005`). Founder-assigned brief, received in session prompt; source:
2026-08-05 methods analysis, gap fixes 1, 2, 11, 12, 13, 14, 17, 18, 19, 20,
plus the FOUNDER.md header-comment carry-over from P-004._

This is a sweep brief: many small mechanical fixes + ONE content page (the
overlay appendix) + accepted-risk documentation. Order the commits by slice.

## SLICE 1 — ceo-pack gets installed (Gap 2, BLOCKER)

QUICKSTART Flow C and templates/04-operating-model.md point at
docs/appendix/ceo-pack.md, but install.sh never installs it. Fix: add the
appendix to install.sh's write list (quote the diff hunk — follow how
DECISIONS.md was added in P-003, including the header-comment line), with the
docs/appendix/ directory created as needed. Dry-run proof into a fresh temp
dir: quote the file list showing docs/appendix/ceo-pack.md present with
placeholders rendered. bash -n clean.

## SLICE 2 — Rule-count and pointer staleness (Gaps 11, 12)

- README.md:34 "twelve" → thirteen (quote hunk). The
  docs/briefs/000-master-plan.md:25 footnote says "12 since PR #3" — the plan
  is LOCKED; do not edit it; instead the README fix suffices and you state
  the locked-plan exception in Deviations.
- WORKFLOW.md rule 12 points at "the verification block (see AGENTS.md)" but
  this repo's root AGENTS.md has none. Fix: add the verification block to
  root AGENTS.md (mirror templates/AGENTS-section.md's block, adapted to a
  docs repo — quote both). Grep proof the pointer now resolves.

## SLICE 3 — CTO/PM rename completion (Gap 13)

Finish the Brief-008 rename "CTO/PM session" → "CTO session" in:
prompts/1-cto-kickoff.md, templates/AGENTS-section.md,
templates/02-program-plan.md, templates/plans-00-INDEX.md,
templates/briefs-README.md, docs/appendix/ceo-pack.md,
prompts/3-ceo-strategy-project.md. Also unify the trigger phrase: "prepare
the strategy advisor" wins (WORKFLOW.md:280 is canonical); fix "prepare the
CEO project" in templates/04-operating-model.md. Before/after
grep -rn "CTO/PM\|CEO project" — after: zero hits outside docs/seeds/ and
locked plans (state the exemptions).

## SLICE 4 — Installer labels (Gap 14)

install.sh header: "Contract-v1 YAML front matter" → v2.1 (quote hunk).
templates/STATUS.md lane example "lane-2" → a v2-convention label like
"kimi-1" (quote hunk). Grep proof no "v1" labels remain in
installer/template headers (historical changelog lines exempt — say so).

## SLICE 5 — FOUNDER.md header comment (P-004 carry-over)

Root FOUNDER.md's header comment still says three types — conform it to the
four types + unknown-type rule, matching templates/FOUNDER.md (quote hunk;
this was deliberately deferred from P-004 to keep its diff clean).

## SLICE 6 — The overlay appendix (Gap 1 / Proposal P-001 — the content page)

Write docs/appendix/overlays.md: the Yeditepe-style overlay pattern — running
the workflow as a process-only layer on someone else's codebase (you don't
own the repo, can't install AGENTS.md into it, or must not pollute it).
Content: what an overlay repo is (a separate private repo holding
STATUS.md/FOUNDER.md/DECISIONS.md/briefs for the target codebase); how
sessions boot (clone both; overlay repo is the memory, target repo is the
code); branch/PR rules when you can't merge in the target (fork-or-branch
strategy, who merges); what the console reads (the overlay repo's STATUS.md —
the contract is unchanged); honest limits (drift detection sees the overlay's
main, not the target's — state it). ~1 page, concrete, with a mini example.
Add it to install.sh's write list (same pattern as Slice 1 — quote hunk +
dry-run proof) and close Proposal P-001 in STATUS.md Proposals with a dated
line pointing at the merged file. Check QUICKSTART/GUIDE-2 for any place
that should link it (quote the link hunk or "checked, no link needed because
…").

## SLICE 7 — Accepted risks documented (Gaps 17, 18, 19, 20 — decision, not code)

These were ruled accepted-by-design in the 2026-08-05 CTO review; record them
as ONE DECISIONS.md entry each (format per contract; Who: founder, from CTO
review 2026-08-05):

(a) Founder is the single merge point — no delegation/timeout path; accepted
    risk: waits happen, needs_input/blocked states record them.
(b) This repo's roadmap lives in docs/briefs/000-master-plan.md (locked), not
    docs/plans/ — deliberate deviation.
(c) No CI in this docs-only repo; rule 5's green-build applies to code repos.
(d) Cross-project board coherence is the sister console's job by design; the
    kit defines state, not aggregation.

Also one line each in WORKFLOW.md where the topic lives (e.g. near the merge
rule: "Accepted risk, recorded in DECISIONS.md: the founder is the single
merge point"). Grep-proof the four DECISIONS.md entries exist
(grep -c "^## 2026-08-05" DECISIONS.md → 4, plus the P-003 entry already
there = 5 total dated 2026-08-05; quote all four in full).

## ACCEPTANCE CHECKLIST

1. install.sh: two new files in the write list (ceo-pack, overlays) with
   dry-run proofs + bash -n clean.
2. Greps: zero "twelve" for the rule count; verification block present in
   root AGENTS.md; zero "CTO/PM"/"CEO project" outside exemptions; no "v1"
   labels in installer/templates.
3. FOUNDER.md header comment conformed, four types.
4. docs/appendix/overlays.md quoted in full; P-001 closed in STATUS with
   dated line.
5. DECISIONS.md: exactly four new 2026-08-05 entries, quoted.
6. Drift checkpoint at claim quoted; STATUS front matter per Contract v2.1;
   brief persisted at docs/briefs/P-005-consistency-sweep.md.
7. PR body: numbered slices, before/after greps for every sweep, Deviations
   (the locked master-plan footnote belongs here), verdict-request line.

OUT OF SCOPE: INTEGRATION.md contract keys (v2.1 settled in P-004 — changelog
line for P-005 allowed only if a slice changes tool-visible behavior;
expected: none — state it); the locked 000-master-plan.md body; any other
repo.
