# INTEGRATION.md — the machine-readable contract

> **Contract v2.2** · Status: active · First reader: the TechOfficer console
>
> This document is the single source of truth for how tools read and write
> workflow state. If a tool and this document disagree, the document wins and
> the tool is wrong. Prose in `STATUS.md` / `FOUNDER.md` is for humans; the
> formats below are for machines.

Two products, one ecosystem: a project repo **writes** state (in `STATUS.md`
front matter and `FOUNDER.md` entries); a console or tool **reads** that state,
routes work, and carries founder messages down. This contract is the seam
between them.

---

## 1. The STATUS.md front-matter schema

`STATUS.md` begins with a YAML front-matter block delimited by `---` lines.
Everything between the first `---` and the second `---` is the machine zone;
everything after is human prose and carries no machine meaning.

```yaml
---
project: my-saas              # string, REQUIRED. Repo slug.
phase: implementation         # string, free text. See vocabulary below.
updated: 2026-07-31T14:22:00Z # string, REQUIRED. FULL ISO-8601 with timezone.
lane: claude-2                # string or null. The subscription slot driving.
state: working                # enum: working | needs_input | review | blocked | idle
current_task: "Brief 014 — password reset flow"  # string or null
blocker: null                 # string when blocked|needs_input, else null
summary: "M2 in progress — billing live; next: usage metering"
                              # string or null, OPTIONAL (v2). One line from the
                              # CTO session: current stage + what's next.
milestones:                   # list or null, OPTIONAL (v2); item keys EXACTLY
                              # name/done/total/state — exactly one `current`
  - name: "M1 — MVP"          #   name:  string
    done: 9                   #   done:  integer — checklist items done
    total: 9                  #   total: integer — checklist items in total
    state: done               #   state: enum done | current | planned
  - name: "M2 — billing"
    done: 2
    total: 8
    state: current
  - name: "M3 — teams"
    done: 0
    total: 10
    state: planned
queue:                        # list of items; each item has EXACTLY these 4 keys
  - id: B-014                 #   id:     string, task id
    title: "Password reset"   #   title:  string
    role: executor-backend    #   role:   string, e.g. executor-frontend |
                              #         executor-backend | executor-qa | cto-plan
    weight: M                 #   weight: enum S | M | L
---
```

### Field reference

| Field | Type | Required | Meaning |
|-------|------|----------|---------|
| `project` | string | **yes** | Repo slug (e.g. `techofficer-workflow`). How a tool names the project. |
| `phase` | string | no | Free text; conventional values: `bootstrap` \| `spec` \| `planning` \| `implementation` \| `review` \| `maintenance`. A tool must not fail on an unknown value. |
| `updated` | string | **yes** | FULL ISO-8601 timestamp **with timezone**, e.g. `2026-07-31T14:22:00Z`. Date-only is invalid: staleness detection ("has this project moved in the last N hours?") needs time-of-day. Set to *now* on every write. |
| `lane` | string \| null | yes (may be null) | Which lane holds this project, e.g. `"claude-2"`. A lane is one execution slot on an AI vendor subscription (WORKFLOW.md §The lane model): the subscription is the paid seat, lanes are its parallel sessions. `null` = no lane currently driving. |
| `state` | enum | **yes** | `working` — a session is actively building · `needs_input` — waiting on the founder (see `blocker`) · `review` — PR open, awaiting review/merge · `blocked` — cannot proceed (see `blocker`) · `idle` — nothing in flight. |
| `current_task` | string \| null | yes (may be null) | What is being worked on right now, one line. `null` when `state: idle`. |
| `blocker` | string \| null | yes (may be null) | Free text describing the blocker. Present **iff** `state` is `blocked` or `needs_input`; `null` otherwise. |
| `summary` | string \| null | no (optional, v2) | One line from the project's CTO session: current stage + what's next. An absent key is **valid** (rule 4). |
| `milestones` | list \| null | no (optional, v2) | Milestone list for the project's detail page. Each item has **exactly** the keys `name` (string), `done` (integer), `total` (integer), `state` (`done` \| `current` \| `planned`); exactly one item carries `state: current`. An absent key is **valid** (rule 4). |
| `queue` | list | yes (may be empty) | **THE ready queue** — the single authoritative representation of claimable work (see *The ready queue* below). Each item has **exactly** the keys `id`, `title`, `role`, `weight` — no other key names, no extra keys. |

### Queue item schema (standardised)

```yaml
- id: B-005              # string. Task id; briefs use B-NNN, but any string is valid.
  title: "Short human-readable title"   # string.
  role: executor-docs    # string. Which role should pick it up, e.g.
                         # executor-frontend | executor-backend | executor-qa |
                         # executor-docs | cto-plan. Free text, e.g. not enum —
                         # tools route on exact match or prefix, never on guesswork.
  weight: M              # enum: S | M | L (rough effort sizing for routing).
```

### The ready queue — one source, defined lifecycle (v2.1)

The front-matter `queue` is **THE ready queue** — the single authoritative
representation of claimable work. Any prose table or list that looks like a
queue (a "Ready to pick up" section in STATUS.md prose, a sequenced brief
list in a program plan) is **commentary, never data**: tools MUST ignore it,
and sessions claim only from the front-matter queue. On any conflict between
a prose view and the front-matter queue, the front-matter queue wins.

Lifecycle of a queue item:

- **ENTERS** when the CTO session queues it — the brief becomes ✅ Ready.
- **LEAVES at claim** — the claiming executor removes the item from the queue
  in its claim commit. A claimed brief lives in the claiming session's
  `state`/`current_task`, NOT in the queue.
- **LEAVES at prune** — rule 13: when its PR merges, the next session removes
  it if still present and logs the merge.
- **LEAVES at withdrawal** — the CTO session may withdraw a queued item any
  time before claim (brief back to 📝 Draft or 🗄 Superseded).
- **SURVIVES a merge** — a removal is durable against branches that forked
  before it. When a git conflict on STATUS.md pits a drained queue line
  against a branch that still carries it, **the removal wins**: resolve by
  **union of changes** (both sides' removals apply, and both sides'
  additions survive), never union of lines. Union of lines resurrects
  claimed work into the ready queue — measured in a consuming repo, where a
  merge resolution chose "keep the queue line" and a claimed, already-merged
  brief re-entered the queue for the next executor to claim again.

A claim strictly **removes** — writers never add a queue item at claim time.

### The ready queue as files — `docs/queue/` (v2.2)

**READERS ONLY IN v2.2. Producers do not write this form yet** — see *Migration*
below before implementing anything.

A repo may carry its ready queue as **one file per claimable item**:

```
docs/queue/B-014.md
docs/queue/B-015.md
```

Each file is YAML front matter carrying **exactly the four queue-item keys** of
the schema above — `id`, `title`, `role`, `weight` — optionally followed by
prose:

```markdown
---
id: B-014
title: "Password reset"
role: executor-backend
weight: M
---

Anything below the front matter is commentary for humans and carries no
machine meaning, exactly as in STATUS.md.
```

The item schema is **unchanged**: same four keys, same types, same rule 4
enforcement. Only its location moves. A file whose front matter violates the
item schema is an invalid item (→ rule 3 applies to that item's repo).

**Why this form exists.** Git cannot express *"both sides deleted different
lines of one list"*, so two concurrent claims against the front-matter `queue`
conflict, every time, and a human resolves them under the v2.1 rule above.
That rule is correct and insufficient: it tells a person how to resolve a
conflict, it does not prevent one. Two branches deleting two different **paths**
merge silently and always have.

**And there is no configuration fix — that was measured, not assumed.** A
consuming repo set `STATUS.md merge=union` to remove the conflict and tested it
on two real branches: the merge went clean and **both drained lines came back**,
re-queueing claimed, already-merged work. `merge=union` keeps both sides of a
hunk, so each side restores the line the other deleted — it does not implement
the v2.1 rule, it **inverts** it, trading a loud conflict for a silent
regression. Do not configure it. (`tech-officer/TechOfficer`, B-432,
2026-09-11.)

#### Precedence — a reader must not guess

1. If `docs/queue/` exists **and contains at least one valid item file**, it is
   THE ready queue. The front-matter `queue` is then **commentary** — the same
   status a prose "Ready to pick up" table has — and is ignored.
2. Otherwise the front-matter `queue` is THE ready queue, exactly as in v2.1.
3. An **empty or absent** `docs/queue/` is **not an empty queue.** It means the
   repo does not use the directory form, and the reader falls through to case
   2. A migrated repo with nothing queued still carries `queue: []` in its
   front matter, which reads as empty under case 2.

Case 3 is the one an implementation gets wrong. Without it, an accidental
`mkdir docs/queue` silently empties a project's board.

The lifecycle is unchanged — enter on CTO queue, leave at claim, at rule-13
prune, or at withdrawal — and **a claim strictly removes**: in this form, by
deleting the item's file in the claim commit.

#### Migration — two revisions, in this order

| revision | producers | readers |
|---|---|---|
| **v2.2** (this one) | keep writing front-matter `queue` | **MUST** accept both forms, per the precedence above |
| **v2.3** (not yet specified) | write `docs/queue/`; front-matter `queue` becomes legacy | accept both, unchanged |

**The halves cannot be swapped.** A producer writing the new form before
readers accept it hands every console an empty queue, and the failure looks
like a broken install rather than an un-adopted contract. **v2.2 therefore
changes no file's shape:** every v2.1 repo is a valid v2.2 repo, untouched, on
the day this ships. Readers are what must move first, and v2.3 is gated on them
having moved.

### Canonical id mapping (v2.1)

Queue id, branch, and brief filename are canonically **B-NNN** — zero-padded
three digits:

- id `"B-NNN"` → branch `brief/B-NNN` → file `docs/briefs/B-NNN-<slug>.md`

A project may use another prefix letter (e.g. this kit's own `P-NNN`), but
**one scheme per repo**, stated in that repo's AGENTS.md. **Legacy note:**
pre-v2.1 repos using bare numbers (branch `brief/009`, file
`009-contract-v2.md`) are grandfathered — sessions MUST tolerate both forms
when reading, and always WRITE the canonical form.

### Lane labels (v2)

Lane labels follow the convention **`<vendor>-<n>`** — e.g. `kimi-1`,
`claude-2` — so tools can show *which AI* is driving a project
unambiguously: the vendor, and which of its parallel lanes. Writers use the
convention for new labels; readers must **tolerate legacy free-form labels**
(`kimi`, `lane-2`, …): any non-null string is a valid label, and a reader
never fails on its format.

### Reader guidance for the v2 optional keys

- `summary` and `milestones` are OPTIONAL. An **absent key is valid** (rule 4
  already tolerates unknown keys; these two are simply known-but-absent).
  `null` is equivalent to absent. Neither case makes the front matter
  invalid.
- To render the current milestone: take the **first** item with
  `state: current`; if none, the first with `state: planned`; if none (or the
  key is absent, null, or an empty list), render **"—"**.
- More than one `current` is a writer-side contract violation: readers take
  the **first** `current` and **do not fail**.

### Field ownership

Ownership decides **who may write which field**. Tools honouring this contract
must respect it; humans are bound by it via AGENTS.md.

- **CTO session owns** `queue`, `summary`, and `milestones` (and `project`,
  `phase` when they change).
- **Executor sessions own** `state`, `current_task`, `updated`, `blocker`.
- **ANY role touching the file sets `updated` to now** (full ISO-8601 with
  timezone). No write without a fresh `updated`.

**Founder write-rights on STATUS.md (v2.1).** The founder may append to the
prose activity log and may answer questions via STATUS.md (the existing
convention), setting `updated` on any touch. The founder does **not** edit
front-matter fields — with one emergency exception: to **release a lane**
(set `state: idle` + `lane: null`) as an emergency unblock. Every such manual
front-matter edit is logged in the activity log with its reason.

### Complete annotated example

```yaml
---
project: techofficer-workflow          # repo slug — required
phase: bootstrap                       # free-text phase
updated: 2026-07-31T14:55Z             # full ISO-8601 + timezone — bumped on EVERY write
lane: kimi                             # execution slot on the Kimi subscription; null if none
state: working                         # working | needs_input | review | blocked | idle
current_task: "Brief 003 — INTEGRATION.md contract"  # null when idle
blocker: null                          # text iff state is blocked|needs_input
summary: "M1 in progress — contract shipped; next: founder rulings"
                                       # OPTIONAL (v2): stage + what's next
milestones:                            # OPTIONAL (v2); exactly one `current`
  - name: "M0 — bootstrap"
    done: 8
    total: 8
    state: done
  - name: "M1 — contract + rulings"
    done: 1
    total: 2
    state: current
queue:                                 # CTO-owned ready queue
  - id: B-003
    title: "The contract: INTEGRATION.md, templates, v1 migration"
    role: cto-plan                     # the CTO session plans; executors execute
    weight: M
  - id: B-004
    title: "Templates + prompts generalized, maturity labels"
    role: executor-docs
    weight: M
  - id: B-005
    title: "install.sh updated for the generalized kit"
    role: executor-docs
    weight: M
---
```

---

## 2. The FOUNDER.md message format

`FOUNDER.md` is the async founder→session channel. It has exactly two machine
sections: `## Inbox` and `## Consumed`. Every Inbox entry is:

```markdown
## YYYY-MM-DDTHH:MMZ — directive|context|question|answer
<message text>
```

- The header line is an H2 whose text is an ISO-8601 timestamp (`YYYY-MM-DDTHH:MMZ`),
  a space, an em-dash, a space, then the type: exactly one of
  `directive`, `context`, `question`, `answer`.
- Everything from the line after the header to the next `## ` header (or the
  `## Consumed` section) is the message text.
- **directive** — an order. Unconsumed directives **block new brief claims**.
- **context** — information; does not block.
- **question** — the founder wants an answer (via STATUS.md or a PR).
- **answer** — a response to a question/signal, written by the founder OR by a
  permitted tool append (e.g. the console standup downlink); consumed like any
  other entry. Does not block.
- **Unknown type** — a reader MUST surface the entry verbatim and flag it as
  **non-conformant** — never silently drop it, never guess its type.

**Consumption** is mechanical: the consuming session moves the entry, unchanged,
under `## Consumed`, and adds a dated line to the `STATUS.md` activity log
recording the consumption. An entry still sitting in Inbox is unconsumed.

### Worked example: console approval downlink

The TechOfficer console never gets `STATUS.md` write access — it does not need
it. Approving a brief from a phone is a round trip the existing contract
already covers (§3 rule 2):

1. The founder taps *approve* in the console; the console **appends** an
   `answer` entry to the `## Inbox` of `FOUNDER.md`:

   ```markdown
   ## 2026-08-12T09:14Z — answer
   Brief B-014 approved — build it.
   ```

2. The executor session reads `FOUNDER.md` at its next boot/claim (the
   standard read order), consumes the entry — moves it, unchanged, to
   `## Consumed` plus a dated `STATUS.md` activity line — and claims B-014
   the standard way, which includes removing B-014 from the front-matter
   `queue` in its claim commit.

The console wrote one append-only entry; the session did every `STATUS.md`
write itself. No console-owned fields in the front matter, no tool write
access to `STATUS.md`, no contract change. (The console↔runner *job* stream
— `job_id`, `preview_url`, and friends — is a different seam: it belongs in
the console repo's own job contract, not in this project-state contract.)

---

## 3. Rules for tools

1. **Read-only by default.** A tool reads `STATUS.md` and `FOUNDER.md` to build
   its view of the world. Nothing in this contract grants write access beyond
   rule 2.
2. **Append-only on FOUNDER.md.** The single write a tool may perform is to
   **append** a new entry to the `## Inbox` section of `FOUNDER.md`, in the
   §2 format. A tool never edits, reorders, or deletes any other content in
   `FOUNDER.md`, and never writes `STATUS.md` at all — sessions do that.
3. **Parse, don't guess.** Extract state only from the YAML front matter.
   If the front matter is missing, unparseable, or lacks a required field,
   report the project as **"not on the workflow"** — never infer state from
   the prose below the front matter. Prose is for humans; it is not data.
4. **Tolerate the schema, enforce the queue.** Unknown top-level keys and
   unknown `phase`/`role` values must not break a reader. Queue items, however,
   have exactly `id`/`title`/`role`/`weight`; a queue item that violates this
   makes the front matter invalid (→ rule 3).
5. **Staleness uses `updated`.** A project whose `updated` is older than the
   tool's staleness threshold is stale — surface that, don't assume it died or
   is healthy. This is why `updated` carries time-of-day.

---

## 4. DECISIONS.md — machine-readable status (v2.1)

`DECISIONS.md` is a **standard kit file** (installed by `install.sh` since
P-003). Tools **MAY read** it. The parse contract is the H2 entry format:

```markdown
## YYYY-MM-DD — short title
Decision: <what was decided, one line>
Rejected: <option — why rejected>   (one line per rejected option)
Accepted risk: <risk consciously taken>   (optional)
Who: <decider(s)>
```

Entries are matched on that heading pattern (`## YYYY-MM-DD — title`); prose
between entries is ignored. Tools **never write** `DECISIONS.md` — sessions
write it per the advisory-persist rule (WORKFLOW.md §The roles).

---

## Changelog

- **v2.2** (2026-09-13, P-007) — **Additive, reader-only, and non-breaking by
  construction.** Specifies `docs/queue/` — one file per claimable item, the
  same four-key item schema — as an alternative location for THE ready queue,
  with three-case precedence (directory with at least one valid item wins;
  otherwise front matter; an empty or absent directory is **not** an empty
  queue and falls through). **Producers do not write the new form in v2.2** and
  no template, prompt, installer or example changed: every v2.1 repo is a valid
  v2.2 repo untouched. Cause, measured: the v2.1 "removal wins / never union of
  lines" rule tells a human how to resolve a conflict but cannot prevent one,
  and `merge=union` — tried on two real branches in a consuming repo — restored
  **both** drained lines, inverting the rule rather than implementing it
  (`tech-officer/TechOfficer`, B-432, 2026-09-11). Two branches deleting two
  different paths merge silently. **Unchanged:** all v1/v2/v2.1 keys, the queue
  item schema, the queue lifecycle and claim-removes semantics, the v2.1
  conflict-resolution rule (still normative for every repo on the front-matter
  form), the FOUNDER.md format, and the tool write-rules. **Deferred to v2.3:**
  producers writing `docs/queue/`, gated on readers having adopted v2.2.

- **v2.1** (2026-08-05, P-004 — gap fixes 3/4/5/10/16/21 from the 2026-08-05
  methods analysis) — one line per slice:
  - Slice 1: the front-matter `queue` is THE ready queue (single authoritative
    representation); lifecycle defined — enter on CTO queue, leave at claim /
    rule-13 prune / CTO withdrawal; claim strictly removes.
  - Slice 2: canonical id mapping — id `B-NNN` → branch `brief/B-NNN` → file
    `docs/briefs/B-NNN-<slug>.md`, one scheme per repo stated in AGENTS.md;
    bare-number legacy (e.g. `brief/009`) tolerated on read, canonical on write.
  - Slice 3: FOUNDER.md message types now `directive | context | question |
    answer`; unknown-type rule — surface verbatim + flag non-conformant,
    never drop, never guess.
  - Slice 4: founder write-rights on STATUS.md — prose activity log +
    question answers allowed; front matter untouched except emergency lane
    release (`state: idle` + `lane: null`), always logged with reason.
  - Slice 5: DECISIONS.md is a standard kit file — tools MAY read it (H2 entry
    format is the parse contract; prose between entries ignored), never write it.
  **Unchanged:** all v1/v2 keys, the queue item schema, the Inbox/Consumed
  mechanics, and the tool write-rules.

- DECISIONS.md convention added (P-003); machine-readable status deferred to v2.1 (P-004).

- **v2** (2026-08-02, founder-signed "TechOfficer Product Definition v0.1" —
  rulings D1 + D3 + sign-off ruling §12.3; Brief 009) — **Additive only.**
  Two OPTIONAL front-matter keys so the TechOfficer console can render a
  project-first Deck: `summary` (one line from the CTO session: current stage
  + what's next) and `milestones` (list rendered on the project's detail
  page; item keys exactly `name`/`done`/`total`/`state`, state ∈
  done|current|planned, exactly one `current`). Lane-label convention
  `<vendor>-<n>` (e.g. `kimi-1`, `claude-2`); legacy free-form labels
  tolerated by readers. Field ownership: the CTO session owns `summary` and
  `milestones` alongside `queue`/`project`/`phase`. **Unchanged:** all v1
  keys, the queue item schema (exactly id/title/role/weight), the FOUNDER.md
  message format, and the tool write-rules (read-only by default,
  append-only Inbox, never write STATUS.md).

- **v1.1** (2026-08-02, founder directive) — Process note only, **no schema
  change**: WORKFLOW.md gained rule 13 ("Merge closes the loop" — when a PR
  merges, the next CTO session prunes the delivered item from the queue,
  sets `state: idle` / `lane: null` if unclaimed, and logs the merge as a
  dated activity line). Rule 13 is a process rule about *when* sessions
  update STATUS.md; it adds, removes, and reinterprets **no** contract
  fields. The v1 schema above is unchanged.

- **v1** (2026-07-31, Brief 003) — Initial contract. STATUS.md front-matter
  schema (project/phase/updated/lane/state/current_task/blocker/queue),
  standardised queue items (id/title/role/weight), field ownership,
  FOUNDER.md Inbox/Consumed format, tool rules (read-only, append-only Inbox,
  parse-don't-guess). Founder review notes applied: `updated` is full ISO-8601
  with timezone (date-only insufficient for staleness); queue keys are exactly
  id/title/role/weight.
