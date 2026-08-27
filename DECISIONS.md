_Maturity: 🧪 included but unproven_

# DECISIONS.md — the decision ledger (techofficer-workflow)

Append-only, newest entry on top. Never edit or delete an entry — reversing a
decision is a new entry that cites the old one.

**Why, not what.** This ledger records rejected options, accepted risks, and
cross-cutting rulings — the reasoning a successor session cannot reconstruct
from the code. Per-decision detail still lives in the plan it affects; this
file is the index of *why*.

Entry format (one H2 per decision):

    ## YYYY-MM-DD — short title
    Decision: <what was decided, one line>
    Rejected: <option — why rejected>   (one line per rejected option)
    Accepted risk: <risk consciously taken>   (optional)
    Who: founder (+CTO session)

## 2026-08-27 — Lessons flow back into the kit at milestone close-out
Decision: each consuming project's milestone close-out reviews what production
paid for and files a kit brief for anything rule-shaped; the kit is a living
document, not a snapshot (founder: "we should be always improving workflow
repo based on the experience we are getting"). P-006 is the first harvest —
five lessons from TechOfficer's M3 (~28 briefs, ~11 unplanned defects).
Rejected: letting each deployment keep its lessons in its own DECISIONS.md —
every new install inherits the kit as written, not as learned; the same
defects get paid for again.
Rejected: continuous trickle (a kit PR per lesson) — too much merge traffic
for a founder who is the single merge point; close-out batches it.
Accepted risk: lessons arrive late by up to one milestone; a consuming
project can still file an urgent kit brief out of band.
Who: founder (2026-08-25 directive) + TechOfficer CTO session.

## 2026-08-05 — Founder is the single merge point (no delegation path)
Decision: the founder remains the only merge authority; no delegation or
timeout/auto-merge path is added to the method.
Rejected: merge delegation or a timeout path — removes the control point
that rule 4 exists to create.
Accepted risk: waits happen — a session blocked on a merge records it via
`needs_input`/`blocked` states and dated STATUS lines; the delay is visible,
never silent.
Who: founder, from CTO review 2026-08-05.

## 2026-08-05 — Kit roadmap lives in docs/briefs/000-master-plan.md (locked)
Decision: this repo's roadmap stays in `docs/briefs/000-master-plan.md`
(locked at founder sign-off), not in `docs/plans/` as the installed
skeleton prescribes for target repos.
Rejected: migrating the roadmap into docs/plans/ — the plan is locked;
rewriting it to fit the kit's own template would falsify a signed artifact.
Accepted risk: deliberate deviation from the kit's own tree — sessions must
read AGENTS.md to learn where this repo's roadmap lives.
Who: founder, from CTO review 2026-08-05.

## 2026-08-05 — No CI in this docs-only repo
Decision: this repo runs no CI; rule 5's green-build-to-merge applies to
code repos. Verification here is the greps, parses, and installer dry-runs
quoted in each PR.
Rejected: adding a CI workflow for markdown linting — cost without signal;
the contract checks (front-matter parse, grep sweeps) are already run
manually and quoted per PR.
Accepted risk: a malformed front-matter block could merge unnoticed — PR
evidence (PyYAML re-parse quoted in the body) is the standing mitigation.
Who: founder, from CTO review 2026-08-05.

## 2026-08-05 — Cross-project board coherence is the console's job
Decision: the kit defines per-project state (STATUS.md front matter,
FOUNDER.md format); aggregating boards across projects belongs to the
TechOfficer console, not the kit.
Rejected: kit-side aggregation tooling or a cross-repo schema — out of the
kit's scope; the contract is the seam, not the dashboard.
Accepted risk: without the console, cross-project views are manual
(paste/export) — recorded in docs/appendix/overlays.md honest limits.
Who: founder, from CTO review 2026-08-05.

## 2026-08-05 — Three-brief workflow hardening sequence (P-003/P-004/P-005)
Decision: run P-003 (cold-boot completeness & advisory persistency), P-004
(contract amendment: queue semantics, FOUNDER.md types, id/branch/filename
mapping, DECISIONS.md machine-readable status), and P-005 (ceo-pack install,
renames, rule-count staleness, overlay appendix) as one sequenced hardening
pass on the kit.
Rejected: fixing gaps ad-hoc per occurrence — contract-first prevents
divergence between method and console.
Who: founder, from CTO analysis review (2026-08-05 methods analysis).
