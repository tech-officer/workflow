# BRIEF P-006 — Harvest: what one month of production paid for

> Status: ✅ Ready · Owner: CTO session (docs-only) · Branch: `brief/P-006`
> Size: **S** · Written: 2026-08-27 by the TechOfficer CTO session
> Founder directive: *"we should be always improving workflow repo based on
> the experience we are getting."*

## Goal

Five lessons the TechOfficer deployment paid for in production reach the kit,
so the **next** project that installs it does not pay for them again.

## Why now

The kit's rules file says it plainly: *"each one was paid for."* Since the kit
shipped, one consuming project ran it hard — 28 briefs in one milestone, ~11
unplanned production defects, two multi-day outages diagnosed to root cause —
and the lessons stayed in that project's `DECISIONS.md` and activity log.
**Nothing flowed back.** Every future install inherits the kit as it was, not
as the experience says it should be.

## The five lessons, each with its receipt

**L1 — Measure the thing, not a proxy for it.** The consuming project hit this
~16 times, three in one week: an HTTP `res.ok` read as "this repo has no
workflow" (a fine-grained token's 404 — cost a day); `test -r` on a file that
did not exist printing `SECRET-ISOLATION-OK` (a security check passing because
there was nothing to secure); a `| head -1` status line read as "the site is
up" on a hostname that once answered 302 with no service behind it. The kit
never states the rule. → **WORKFLOW.md rule 14.**

**L2 — UNMEASURED is a sanctioned verdict.** The best run of the month refused
to tick two acceptance boxes it could not measure (no device, no browser) and
wrote UNMEASURED with the reason. The kit's own text — *"tick it in the PR
body"* — gives that honest move no spelling: a session following the kit
literally would have ticked the boxes. → **AGENTS-section.md + AGENTS.md
verification rule.**

**L3 — A queue drain must survive a merge.** A claimed brief was drained from
the STATUS.md queue; a branch that forked before the drain merged later, and
the conflict resolution *kept the queue line* (consuming repo, commit
`9777146`, "keep B-369 queue line") — a claimed brief re-entered the ready
queue. "Resolve by union" invites exactly this: union of **lines** resurrects
drains; the rule must be union of **changes**. → **INTEGRATION.md queue
lifecycle + WORKFLOW.md rule 13.**

**L4 — Tell the installing AI session about main.** Both guides say the
scaffold commits directly to main, this once. An AI session running the
installer defaults to branch → PR — and until that PR merges, every tool
reading `STATUS.md` from the default branch reports the repo as **not
onboarded**. The instruction has to be given *to the session*, explicitly.
→ **GUIDE-1 + GUIDE-2.**

**L5 — An autonomous runner cannot paste into the PR body.** Orchestrated
runs open PRs with their own template; a brief demanding its checklist "in
the PR body" is unsatisfiable by the very runs the workflow exists to enable.
The consuming project's convention — the checklist lands in
`docs/reports/<brief-id>/` when a runner opens the PR — becomes the kit's.
→ **AGENTS-section.md.**

## Scope

**In:** the six file edits above, this brief, a `DECISIONS.md` entry recording
the harvest ritual (lessons flow from consuming projects into the kit at each
milestone close-out), and the STATUS.md board updates the kit's own protocol
demands.

**Explicitly OUT:**

- **New machinery.** No scripts, no checkers — these are rules, stated where
  the existing rules live.
- **Renumbering or rewording existing rules.** Rules 1–13 keep their numbers;
  `AGENTS-section.md` cites "rule 13" and installed copies exist.
- **Contract changes.** The front-matter schema is untouched; L3 changes how
  *conflicts on it* are resolved, not its shape.
- **Anything the consuming project has not actually paid for.** No
  speculative rules.

## Acceptance checklist

- [ ] WORKFLOW.md has rules 14 (measure, don't proxy) and 13 gains the
      drain-survives-merge clause; rules 1–12 byte-identical.
- [ ] templates/AGENTS-section.md verification rule carries UNMEASURED and
      measure-don't-proxy; checklist line carries the runner allowance.
- [ ] AGENTS.md (kit's own) verification rule carries the same two additions.
- [ ] INTEGRATION.md queue lifecycle has the SURVIVES-a-merge bullet with the
      union-of-changes rule.
- [ ] Both guides carry the say-it-to-the-session warning.
- [ ] DECISIONS.md records the harvest ritual, format respected.
- [ ] STATUS.md: claim, activity line, `updated` bumped.
- [ ] `bash install.sh --help` still prints (no installer change intended —
      prove none happened).

## Verify

```bash
grep -n "rule 14\|14\." WORKFLOW.md | head -3
grep -n "UNMEASURED" templates/AGENTS-section.md AGENTS.md
grep -n "union of changes\|survives" INTEGRATION.md
grep -rn "directly to main" GUIDE-1-new-project.md GUIDE-2-existing-project.md
bash install.sh --help | head -3
```
