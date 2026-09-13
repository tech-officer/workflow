# P-007 — Contract v2.2: `docs/queue/` specified, readers accept both

**Status:** 🔨 Claimed (2026-09-13, lane `claude-1`, branch `brief/P-007`)
**Source:** founder-assigned, from a measurement in a consuming repo
(`tech-officer/TechOfficer`, brief B-432, 2026-09-11).
**Center:** `INTEGRATION.md` is the whole deliverable. Nothing else in the kit
changes shape — see *Explicitly out* for why that restraint is the point.

## What reality taught, and it was measured twice

Contract v2.1 already says the right thing about concurrent drains:

> **SURVIVES a merge** — … resolve by **union of changes** (both sides'
> removals apply, and both sides' additions survive), never union of lines.
> Union of lines resurrects claimed work into the ready queue — measured in a
> consuming repo…

That paragraph exists because a merge resolution kept a queue line and a
claimed, already-merged brief re-entered the queue. **It is correct, and it is
not enough**, because it describes how a human should resolve a conflict — it
does not stop the conflict happening. On a repo running two lanes, every pair
of concurrent claims produces a `STATUS.md` conflict that a person has to open
and reason about, and the easiest wrong answer is the one the contract warns
against.

**The consuming repo then tried to remove the conflict with configuration and
proved that it cannot be done.** `TechOfficer`'s orchestrator had asserted
since its own B-369 that concurrent drains *"merge by UNION, already this
file's convention."* Two facts, both measured 2026-09-11:

- `git check-attr merge STATUS.md` answered **`unspecified`** — the convention
  had been assumed and never configured.
- Configuring it, then testing on two real branches: three queue entries, one
  branch drains A, another drains B. The merge went **clean** and the result
  contained **both lines again**. `merge=union` keeps both sides of a hunk, so
  each side's copy of the block restores the line the other side deleted.

`merge=union` does not resolve the v2.1 rule — **it inverts it.** It is worse
than the conflict, because the conflict is loud and this is silent. The driver
was reverted; nothing in that repo's `.gitattributes` changed.

**So the conflict is correct behaviour and has no configuration fix.** Git
cannot express *"both sides deleted different lines of one list"*. What it can
express, and always could, is **two branches deleting two different paths** —
that merges silently and has since git existed.

## The shape: one file per queue entry

```
docs/queue/B-014.md      # one claimable item, one file
docs/queue/B-015.md
```

Two claims delete two different files. No conflict, no human, no rule to
remember. The v2.1 resolution rule stops being something a person has to apply
correctly under time pressure and becomes something the tool cannot get wrong.

## 🔴 This brief ships the READER half ONLY, and that is the whole design

The migration is two revisions, in this order, and **shipping them together
would break every consumer on the day it merged**:

| revision | what changes | who must act first |
|---|---|---|
| **v2.2 — this brief** | `docs/queue/` is **specified**. Readers **MUST** accept both forms. Producers keep writing front-matter `queue:`. | nobody — it is non-breaking by construction |
| **v2.3 — later, not here** | Producers write `docs/queue/`; front-matter `queue` becomes legacy-on-read. | every consuming reader must already accept both, i.e. v2.2 must have shipped and been adopted |

**Why the halves cannot swap.** A producer that writes the new shape before
readers accept it hands every console an empty queue. The first consumer is
`tech-officer/TechOfficer`, whose console reads the front-matter `queue` and
nothing else today; a project scaffolded from a producer-first kit would show
**no claimable work at all** on the Agents screen, and the failure would look
like a broken install rather than a contract it had not caught up with.

**A deprecation whose first step breaks the only consumer is not a
deprecation.** So v2.2 changes no file's shape anywhere: every repo on v2.1 is
already a valid v2.2 repo, on the day this merges, without being touched.

## Precedence, stated so two implementations cannot disagree

A reader that finds both must not guess:

1. If `docs/queue/` exists **and contains at least one valid item file**, it is
   THE ready queue. The front-matter `queue` is then **commentary** — exactly
   the status v2.1 gave a prose "Ready to pick up" table — and is ignored.
2. Otherwise the front-matter `queue` is THE ready queue, unchanged from v2.1.
3. An **empty or absent** `docs/queue/` is not an empty queue. It means *this
   repo does not use the directory form*, and the reader falls through to the
   front matter. A repo that has migrated and genuinely has nothing queued
   still has an empty front-matter `queue: []`, which reads as empty by rule 2.

Rule 3 is the one an implementer gets wrong. Without it, `mkdir docs/queue`
silently empties a project's board.

## Slices

1. **`INTEGRATION.md` §1 — a new subsection** *The ready queue as files (v2.2)*
   directly after *The ready queue — one source, defined lifecycle (v2.1)*:
   the item-file format, the precedence rules above, and the explicit
   statement that producers do **not** write this form yet.
2. **The item file format.** Front matter carrying exactly the four v2.1 keys
   (`id`, `title`, `role`, `weight`) — the queue item schema is unchanged and
   is not renegotiated here — plus optional prose below it, which is
   commentary and carries no machine meaning (rule 3's principle, applied one
   level down).
3. **`INTEGRATION.md` header + changelog** — version becomes **v2.2**, with a
   changelog entry naming the measurement, the reader-only scope, and the
   v2.3 that is deliberately not in it.

## Explicitly out — and each is a decision, not an omission

- **Producers writing `docs/queue/`.** That is v2.3. See the table above.
- **`templates/STATUS.md`, `install.sh`, `WORKFLOW.md`, the prompts.** All
  describe what a *producer* does, and producers do not change in v2.2. A
  template edited now would be a scaffold telling a new project to write a
  shape no console reads. **This brief touches no template and no installer.**
- **Migrating this repo's own queue.** `techofficer-workflow` runs
  `queue: []`; dogfooding the new form belongs with v2.3, when writing it is
  the specified behaviour.
- **Removing the v2.1 conflict-resolution rule.** It stays, and stays
  normative, because every repo on the front-matter form still needs it — and
  after v2.3 every *legacy* repo still will.

## Acceptance

- [ ] `INTEGRATION.md` header reads **Contract v2.2**, and the changelog
      carries a v2.2 entry naming the measurement that caused it.
- [ ] The precedence rules are stated as three numbered cases, including the
      empty-directory case, unambiguously enough that two implementers agree.
- [ ] The contract states in its own words that **producers do not write the
      new form in v2.2**.
- [ ] **A v2.1 repo is a valid v2.2 repo untouched.** No template, installer,
      prompt or example is edited; `git diff --stat` on this branch shows
      `INTEGRATION.md`, this brief, and `STATUS.md` — nothing else.
- [ ] The front-matter YAML of this repo's own `STATUS.md` still parses.

## Verify

```bash
# the diff is the contract, the brief and the board — nothing else
git diff --stat main...brief/P-007

# the version and the changelog entry are both present
grep -n "Contract v2.2" INTEGRATION.md
grep -n "^- \*\*v2.2\*\*" INTEGRATION.md

# no producer surface moved
git diff --name-only main...brief/P-007 | grep -E "^(templates/|prompts/|install\.sh|WORKFLOW\.md)" \
  && echo "FAIL: a producer surface changed" || echo "ok: producers untouched"

# this repo's own board still parses
python3 -c "import yaml,re;s=open('STATUS.md').read();d=yaml.safe_load(re.match(r'^---\n(.*?)\n---\n',s,re.S).group(1));print('queue:',d['queue'])"
```

**What failure looks like:** a `git diff --name-only` that lists anything under
`templates/` or `prompts/` — that would mean v2.3 leaked into v2.2 and new
projects are being scaffolded to write a shape no reader accepts yet.
