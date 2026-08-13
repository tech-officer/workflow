# P-003 — Cold-boot completeness & advisory persistency

**Status:** 🔨 Claimed (lane `kimi-2`, branch `brief/P-003`, 2026-08-05)
**Source:** founder-assigned brief (2026-08-05 methods analysis — gap fixes
6 and 8, plus the screenshot-convention rule). Received verbatim in the
executor session prompt; persisted here per the brief's acceptance item 8.

## Context (evidence re-verified at claim)

- The rule-13 drift checkpoint existed ONLY in `prompts/1-cto-kickoff.md`
  (a paste prompt), not in any boot procedure a cold session would
  self-discover (`WORKFLOW.md` boot procedures,
  `templates/04-operating-model.md`).
- Advisory discussions (CTO↔founder) had no persistence path: only final
  decisions land in plans; rejected options and open questions died with the
  session.
- The side-by-side mock-vs-implementation screenshot convention was practiced
  (sister product TechOfficer) but written nowhere in this kit.

## Scope — five slices

1. **Drift checkpoint moves into the boot procedures** — explicit numbered
   step in `WORKFLOW.md`'s boot section AND `templates/04-operating-model.md`;
   `prompts/1-cto-kickoff.md` slimmed to a pointer.
2. **"hey CTO" cold-boot block** — root `AGENTS.md` + `templates/AGENTS-section.md`
   (≤25 lines each): trigger phrases → read order (AGENTS.md → STATUS.md
   front matter → FOUNDER.md Inbox → open PRs → roadmap → DECISIONS.md →
   drift checkpoint) → report-back list (project, phase, lane state,
   in-review items, next queue item, unconsumed founder messages, open
   blockers).
3. **Advisory-persist rule** — a CTO session ends by writing, never by only
   talking: (1) decisions in the plan affected (date + who), (2) rejected
   options in DECISIONS.md, (3) open questions in FOUNDER.md Inbox / STATUS
   Proposals, (4) agreed work as queued briefs; no outcomes → a dated STATUS
   line ("silence is also recorded"). Executor contrast stated. Mirrored as
   one line in `templates/04-operating-model.md`.
4. **DECISIONS.md convention** — `templates/DECISIONS.md` (append-only
   ledger, entry format, 2 examples), added to install.sh, this repo's own
   DECISIONS.md dogfooded with exactly ONE real entry (the 2026-08-05
   P-003/P-004/P-005 sequencing decision). No INTEGRATION.md contract keys;
   one changelog line only.
5. **Screenshot convention written down** — `templates/AGENTS-section.md`
   verification block + `WORKFLOW.md` review rules: side-by-side
   mock-vs-implementation screenshots at 390px width + measured "horizontal
   overflow = 0px" line for any PR with visual output; screenshots may live
   under `docs/reports/<brief-id>/`.

## OUT OF SCOPE (not touched)

Queue semantics, FOUNDER.md types, id/branch/filename mapping (all P-004);
ceo-pack install, renames, rule-count staleness, overlay appendix (all
P-005); any INTEGRATION.md contract keys.

## Acceptance checklist

Per the founder's brief: (1) checkpoint in both boot procedures + kickoff
repointed (grep proof); (2) cold-boot blocks quoted, ≤25 lines; (3)
advisory-persist rule in both files, four must-record items enumerated;
(4) template quoted, install.sh hunk quoted, exactly one real dogfood entry;
(5) changelog line quoted, `git diff INTEGRATION.md` proves no keys touched;
(6) screenshot rule in both files; (7) cold-boot simulation pasted;
(8) STATUS.md per contract + this brief entry; (9) PR body with numbered
slice sections, quoted evidence, Deviations, verdict-request line.
