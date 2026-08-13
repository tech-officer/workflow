# techofficer/workflow — master plan & session briefs

This file lives at `docs/briefs/000-master-plan.md` in the tech-officer/workflow repo.
It is the roadmap the CTO sessions execute against, brief by brief.

---

## 0. What we are building

A vendor-neutral, open-source (MIT) operating system for running software projects
with a human founder and AI coding sessions in defined roles. Ported from the
Claude-only internal kit (proven on gollai; second consumer: Yeditepe
overlay), extended with the machine-readable contract that the TechOfficer
console reads.

Two products, one ecosystem:
- **workflow** (this repo): the method. Writes state.
- **TechOfficer** (sister repo): the console. Reads state, routes work to the
  coldest subscription, carries founder messages down.

## 1. Design decisions (locked — do not re-litigate without founder)

1. `AGENTS.md` is the canonical rules file in target repos. `CLAUDE.md`,
   `GEMINI.md` etc. are thin adapter files that point to it.
2. The proven core is carried VERBATIM: the 11 rules (12 since PR #3 —
   rules 4/5 split, CI scar restored), the loop, the roles table,
   session boot procedures, the 5-question installer approach, QUICKSTART flows.
   No "improvements" before launch.
3. NEW — the TechOfficer contract:
   - YAML front matter at top of STATUS.md: project, phase, updated, lane,
     state (working|needs_input|review|blocked|idle), current_task, blocker, queue[]
   - Role ownership: CTO owns queue; executors own state/current_task/updated/blocker;
     anyone touching the file bumps `updated`.
   - `INTEGRATION.md` documents this contract for tool builders.
4. NEW — `FOUNDER.md`: async founder→session channel. Founder (or TechOfficer)
   appends dated messages (directive | context | question). Sessions read at boot
   and at each brief claim. Unconsumed directives block new brief claims.
   Consuming = move to Consumed section + dated STATUS activity line.
5. Maturity labels on every template: `✅ proven in production` or
   `🧪 included but unproven`. Proven (evidence in source repo): activity log,
   PR-based flow, recorded decisions, discovery audit. Unproven: filled briefs,
   handoff template, report checklist, CEO pack, program plan.
6. CEO/strategy pack moves to `docs/appendix/ceo-pack.md`, labeled 🧪.
7. Yeditepe-style overlays get one appendix page describing the pattern
   (process-only overlay repo, public/private split) — not v1 core.
8. Windows support = Git Bash (as source kit). No install.ps1 in v1.
9. The generalization is a PORT with additions, not a rewrite. Where the source
   text says something well, keep its words.

## 2. Target repo structure

```
workflow/
├── README.md              # story: gollai 6 days → the method → TechOfficer mention
├── LICENSE                # MIT
├── QUICKSTART.md          # Flows A/B/C, ~5 lines each
├── WORKFLOW.md            # THE method doc (generalized 04-operating-model)
├── INTEGRATION.md         # the machine-readable contract (for TechOfficer & tools)
├── GUIDE-1-new-project.md
├── GUIDE-2-existing-project.md
├── SCALING.md             # solo / founder / studio tiers
├── install.sh             # 5 questions; writes AGENTS.md + adapters + FOUNDER.md
├── STATUS.md              # this repo dogfoods the workflow (front matter included)
├── FOUNDER.md             # this repo's own founder channel
├── templates/
│   ├── STATUS.md          # WITH yaml front matter
│   ├── FOUNDER.md
│   ├── AGENTS-section.md  # protocol block (was CLAUDE-section.md)
│   ├── adapters/CLAUDE.md, GEMINI.md
│   ├── plans-00-INDEX.md, 02-program-plan.md, 04-operating-model.md
│   ├── briefs-README.md, handoff-template.md, report-checklist.md
├── prompts/
│   ├── 0-bootstrap-new-project.md ... 5-biweekly-report.md
│   └── executor-boot.md   # NEW: vendor-neutral executor boot (reads FOUNDER.md)
└── docs/
    ├── appendix/ceo-pack.md        # 🧪
    ├── appendix/overlays.md        # the Yeditepe pattern
    └── seeds/                     # source material (gitignored or clearly marked)
```

## 3. Execution sequence

Each brief = one session = one branch `brief/NNN` = one PR. Founder merges.
After brief 000, this repo runs on its own workflow (claim in STATUS first,
PR proves the checklist).

| Brief | Deliverable |
|---|---|
| 000 | Self-governance: STATUS.md (with front matter), FOUNDER.md, docs/briefs/, this plan committed |
| 001 | Mechanical port: all source kit files copied; every §4 coupling renamed; AGENTS.md + adapters |
| 002 | WORKFLOW.md — the generalized method doc (founder reviews line by line) |
| 003 | The contract: templates/STATUS.md front matter, lane model, INTEGRATION.md, templates/FOUNDER.md |
| 004 | Templates + prompts generalized, maturity labels applied |
| 005 | install.sh updated (AGENTS.md, adapters, FOUNDER.md, front-matter STATUS) |
| 006 | QUICKSTART + GUIDE-1 + GUIDE-2 rewritten for the generalized kit |
| 007 | LICENSE, README final, full self-review against this plan |

---

## BRIEF 000 — bootstrap (paste this into the first Kimi Code session)

You are the founding CTO session of the `tech-officer/workflow` repository.
This repo will hold an open-source (MIT), vendor-neutral workflow kit for running
software projects with a human founder and AI sessions in defined roles. It is
ported from a Claude-only kit and extended with a machine-readable integration
contract.

SOURCE MATERIAL (read first, it is ground truth):
- The source kit was a private Claude-only kit on the founder's machine; its
  Yeditepe overlay branch informed the overlay pattern — the overlay itself was
  never copied into this repo. (The local staging area `docs/seeds/` and the
  source-repo recon notes were removed before public release, 2026-08-13.)
- The master plan at `docs/briefs/000-master-plan.md` (this file) — sections 0–3
  are the locked design. Follow them exactly.

TASKS for this session:
1. Create the repo skeleton: README.md (placeholder, one paragraph), LICENSE (MIT,
   copyright "Mansoor Khan"), docs/briefs/, templates/, prompts/, docs/appendix/.
2. Create this repo's own `STATUS.md` — the board for building this kit —
   INCLUDING the yaml front matter block from plan §3 (project: techofficer-workflow,
   phase: bootstrap, lane: kimi, state: working, queue: briefs 001–007 with weights).
3. Create `FOUNDER.md` (empty inbox with the three message types documented in a
   header comment).
4. Copy the source kit's files into a staging area `docs/seeds/source-kit/`
   so later briefs can diff against them without leaving this repo.
5. Open ONE PR with all of the above. PR body: checklist of the 4 tasks,
   each ticked with evidence (file paths).

RULES you operate under from this moment (write them into AGENTS.md at root):
- No brief, no code. One brief = one branch = one PR = one session.
- Never push to main; the founder merges.
- Claim work in STATUS.md before the first commit; bump `updated` on every touch.
- Blocked = say so immediately, with a recommendation.
- Honest states over fake data.

If anything in the plan is ambiguous, state your interpretation in the PR body
under "Decisions made" rather than asking — the founder reviews there.

---

## BRIEF 001 — mechanical port (paste into the second session, after PR #1 merges)

You are an executor session on `tech-officer/workflow`. Claim brief 001 in
STATUS.md first (branch `brief/001`).

TASK: Port the source kit (`docs/seeds/source-kit/`) into its final places,
applying the mechanical de- coupling listed in repo-analysis §4:
1. Copy: QUICKSTART.md, GUIDE-1, GUIDE-2, SCALING.md, install.sh, all of
   templates/, all of prompts/ into their target structure (plan §2).
2. Rename/rewrite mechanically:
   - Every `CLAUDE.md` reference → `AGENTS.md` (canonical). Where a file IS the
     CLAUDE-section template, move it to `templates/AGENTS-section.md`.
   - Create `templates/adapters/CLAUDE.md` and `templates/adapters/GEMINI.md`:
     ≤5 lines each, "read AGENTS.md, it is canonical" style.
   - Role actors: "a dedicated Claude session" → "a dedicated CTO session
     (any vendor)"; "humans + Claude sessions" → "founder + executor sessions";
     "a Claude Project (claude.ai)" → "a strategy-advisor session or project".
   - claude.ai interface specifics (Projects/sources/custom instructions) move
     to `docs/appendix/ceo-pack.md`, labeled 🧪 unproven.
3. Do NOT rewrite prose beyond the couplings. Keep sentences verbatim where no
   coupling exists. This is a port, not an edit.
4. PR body: the §4 checklist from the analysis, each item ticked with the
   file:line where it was resolved. That checklist IS the acceptance test.

---

(Session prompts for briefs 002–007 are written by the CTO session as earlier
briefs merge — one brief at a time, queue owned in STATUS.md.)
