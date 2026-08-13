---
# Machine-readable front matter — schema: INTEGRATION.md (Contract v2.1).
# `updated` is a FULL ISO-8601 timestamp WITH timezone (e.g. 2026-07-31T14:22:00Z),
# bumped to now on EVERY write — staleness detection needs time-of-day.
# Queue items have EXACTLY the keys id/title/role/weight.
project: "{PROJECT}"        # repo slug (string, required)
phase: bootstrap            # bootstrap | spec | planning | implementation | review | maintenance
updated: "{ISO-8601-WITH-TIMEZONE}"  # e.g. 2026-07-31T14:22:00Z
lane: null                  # execution slot on a subscription, e.g. "kimi-1", or null
state: idle                 # working | needs_input | review | blocked | idle
current_task: null          # string, or null when idle
blocker: null               # free text iff state is blocked|needs_input, else null
summary: null               # OPTIONAL (v2, 🧪 unproven): one line — current stage + what's next; absent is valid
milestones: null            # OPTIONAL (v2, 🧪 unproven): list of {name, done, total, state: done|current|planned}, exactly one `current`; absent is valid
queue: []                   # items: {id: "...", title: "...", role: "...", weight: S|M|L}
---

_Maturity: 🧪 included but unproven_

# STATUS — {PROJECT} (single source of truth)

> **Everyone updates this file** — {FOUNDER} and every session (CTO, executor).
> **Protocol:** (1) read this before starting work; (2) add yourself to
> *In progress* when you pick something up; (3) move the item + write a dated
> Activity-log line when you finish/hand off/block. Keep it terse — a board,
> not a diary.
>
> Owners: **{FOUNDER_INITIAL}** = {FOUNDER} · **C** = CTO/executor sessions (any vendor).
> Master roadmap: [`docs/plans/02-program-plan.md`](docs/plans/02-program-plan.md)

---

## 🎯 Current milestone

**M1 — {one sentence: what exists when M1 is done}.** Horizon: {weeks}.
Exit checklist: plan 02 §2 — progress is ticked boxes there, never a bare %.

---

## 🚦 Track board

| Track | What | Owner | Status |
|-------|------|-------|--------|
| {A — name} | {scope} | | ⏳ Planned |

---

## 🔨 In progress

| Task | Owner | Branch | Notes |
|------|-------|--------|-------|
| *(nothing in flight — claim a brief from the front-matter queue above)* | | | |

## 📋 Ready to pick up

> The machine queue in the front matter above is the ready queue (Contract
> v2.1); this section is commentary, never data. To claim: read the brief,
> remove it from the front-matter `queue`, add yourself + branch above, go.
> Process: [`docs/plans/04-operating-model.md`](docs/plans/04-operating-model.md).

## 🚧 Needs {FOUNDER} (actions, not decisions)

- *(exact, small, dated asks — "create X account", "add DNS record Y")*

## 💡 Proposals (park out-of-brief ideas here for the CTO session)

- *(anything an executor wanted to build that wasn't in their brief)*

---

## 📓 Activity log (newest first)

- **{YYYY-MM-DD} — {who}** — {what happened, in 1–3 sentences; link PRs;
  state what was verified, what's blocked and on whom}

---

## 🔗 Map

- **Plans:** `docs/plans/` (numbered; `00-INDEX.md` is the legend)
- **Briefs:** `docs/briefs/` · **Handoffs:** `docs/handoff/` (highest = latest)
- **Ops runbooks:** `docs/ops/` · **Reports:** `docs/reports/`
- **Dev environment:** {DEV_URL}
