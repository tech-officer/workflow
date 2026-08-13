_Maturity: 🧪 included but unproven_

# Overlays — the workflow as a process-only layer

> The Yeditepe pattern: run this workflow **on** a codebase you don't own,
> can't modify, or must not pollute — without installing anything into it.

## What an overlay repo is

Normally `install.sh` writes AGENTS.md, STATUS.md, FOUNDER.md, DECISIONS.md
and the `docs/` skeleton **into** the project repo. That assumes you own it.
Sometimes you don't: a client's repo, a university org's repo, a shared
monorepo where an AGENTS.md from one consultant would collide with everyone
else's tools.

The overlay pattern splits the two concerns into two repos:

- **The target repo** — the code. Untouched by the workflow: no AGENTS.md,
  no STATUS.md, nothing committed that the target's owners didn't ask for.
- **The overlay repo** — a separate, usually **private** repo you do own. It
  holds the entire process layer for the target: `STATUS.md` (with the
  Contract front matter), `FOUNDER.md`, `DECISIONS.md`, `docs/briefs/`,
  `docs/handoff/`, `docs/reports/`. It contains **process only** — no source
  code, and nothing the target's owners would consider confidential leaking
  into a third place.

The public/private split cuts both ways: the overlay can be private while
the target is public (client work), or the overlay is the only place where
security-sensitive process notes live while the kit itself stays public.

## How sessions boot

A session clones **both** repos and treats them as one split brain:

1. Read the **overlay repo** for memory: `AGENTS.md` (the overlay's own,
   which names the target repo and its rules) → `STATUS.md` front matter →
   `FOUNDER.md` Inbox → the roadmap → `DECISIONS.md`. Same cold-boot order
   as any workflow repo.
2. Read the **target repo** for code reality: the brief's grounding
   (file:line) is checked against the target checkout, not the overlay.
3. Briefs live in the overlay's `docs/briefs/`, but their file:line
   references point into the target repo's paths.

So: **the overlay repo is the memory, the target repo is the code.** A new
session still orients in minutes — it just opens two directories instead of
one.

## Branches and PRs when you can't merge in the target

One brief = one branch = one PR still holds; what changes is **where** and
**who merges**:

- **You can branch in the target** (you have write access but not merge
  rights): work lands on `brief/<id>` in the target repo; the PR is opened
  there and the **target's owner merges** — they play the founder's merge
  role for code, while your founder still owns scope and process decisions.
- **You can't even branch in the target**: fork it. Work lands on branches
  in your fork; PRs go upstream (owner merges) or stay in the fork if the
  engagement is deliver-the-fork. The overlay's STATUS.md records which
  arrangement applies.
- **Process commits** (STATUS bumps, brief claims, handoffs) always land in
  the overlay repo, on its own `brief/<id>` or `chore/…` branches, merged by
  your founder per the normal rules.

Rule 4 is unchanged in spirit: **you never merge what isn't yours to
merge.** The founder-of-record for each repo merges there.

## What the console reads

Nothing about the contract changes. The TechOfficer console (or any tool)
reads the **overlay repo's** `STATUS.md` front matter and `FOUNDER.md` —
same schema, same rules (INTEGRATION.md). The target repo needs no front
matter, no instrumentation, no knowledge the workflow exists. Cross-project
aggregation stays the console's job.

## Honest limits

- **Drift detection sees the overlay's main, not the target's.** Rule 13's
  checkpoint (`git log main --oneline -15`) runs against the overlay repo; a
  PR merged in the *target* repo does not appear there. Sessions must check
  the target's merge state explicitly (e.g. `gh pr list` / `git log` on the
  target) before pruning queue items — the overlay cannot detect target-side
  drift on its own.
- The target repo's owners never see your board unless you show them —
  reporting to them is a manual step (export a report, paste a STATUS
  summary), not a side effect.
- Two clones must be kept in sync on the session's machine; a stale target
  checkout means briefs ground against old code.

## Mini example

```
yeditepe-overlay/            # private repo — the memory
├── AGENTS.md                # "target: github.com/uni/yeditepe-app; never commit there"
├── STATUS.md                # the board, Contract front matter on top
├── FOUNDER.md               # founder → session channel
├── DECISIONS.md
└── docs/briefs/B-001-…md    # grounds in ../yeditepe-app/src/… paths

yeditepe-app/                # the university's repo — the code (cloned read+branch)
└── src/ …                   # no workflow files here at all
```

An executor session claiming B-001: removes it from the overlay's
front-matter queue in a commit on the overlay's `brief/B-001`; builds the
code on a branch of `yeditepe-app` (or a fork of it); opens the code PR
against the target (its owner merges); opens the process PR against the
overlay (the founder merges). Two repos, two merge authorities, one board.
