# CEO pack — powering up the CEO/strategy Project

> 🧪 included but unproven — no evidence a CEO pack was ever generated in
> the source repo (repo-analysis §3 "Shelf-ware"). Kept as the designated
> home for vendor-specific advisor-project setup details.

> Owner: CTO session. Trigger: {FOUNDER} says **"prepare the strategy advisor"**.
> Deliverable: a `ceo-pack/` folder at repo root, delivered as ONE PR on
> branch `cto/ceo-pack`. {FOUNDER}'s total effort afterwards: create the
> claude.ai Project, upload the folder's files, paste one text.

## What the CTO session produces

`ceo-pack/` containing exactly:

| File | What it is |
|------|------------|
| `PROJECT-INSTRUCTIONS.md` | The Project's custom instructions — the skeleton below with EVERY `{…}` filled. No placeholder may survive into this file. |
| `01-vision.md` | Current copy of `docs/plans/01-vision.md` |
| `02-program-plan.md` | Current copy of `docs/plans/02-program-plan.md` |
| `04-operating-model.md` | Current copy of `docs/plans/04-operating-model.md` |
| `state-packet.md` | Product state: what is live/built/verified vs planned (see rules below), latest milestone-checklist standing, key metrics that actually exist |
| `UPLOAD-CHECKLIST.md` | The 5 founder steps (below), plus the refresh rule |

If bi-weekly reports exist, also copy the latest `docs/reports/*.html`.

## Rules for filling the facts (this is the whole point)

1. **Verifiable facts** = only things whose verification actually ran:
   merged PRs, ticked exit-checklist items, URLs you (the CTO) checked
   during this task, numbers with a source in the repo. If you didn't
   verify it while preparing the pack, it goes under PLANNED, not FACT.
2. **Honest weaknesses**: enumerate what is genuinely weak right now — no
   customers yet, single server, unpriced model, untested restore path,
   whatever is true in THIS repo. The CEO Project preps for hard questions;
   feeding it flattery disarms it.
3. Never invent numbers. Anything unknown is written as unknown.
4. Date the pack. State packets go stale; the date makes staleness visible.

## The PROJECT-INSTRUCTIONS.md skeleton (fill every {…})

```
You are the CEO / Chief Strategy Officer advisor for {PROJECT} — {one line}.
You work for {FOUNDER} (founder). This Project is the company's business
brain: market analysis, investor materials, competitive strategy, business
model, objection handling. You do NOT write code and do NOT own the
technical roadmap — a separate CTO session owns that; its plans are in
your project knowledge.

## The company in one paragraph
{What it does, for whom, the differentiator, the current stage.}

## Verifiable facts you may claim (do not exaggerate beyond these)
{Bullets from rule 1 above — the boundary of every claim. Dated.}

## Honest weaknesses (know them — you prep for hard questions)
{Bullets from rule 2 above.}

## Context: the stakeholder situation
{Who the investors/customers/advisors are, what's been promised, what
skeptical questions have already been asked. Ask {FOUNDER} if unknown.}

## Standing rules
1. NEVER invent numbers. Every market figure needs a real, citable source.
   Label every figure: FACT (cited) / ESTIMATE (show the math) /
   ASSUMPTION (flag for validation).
2. Separate what IS built from what is PLANNED. Investor materials never
   blur that line.
3. You recommend; {FOUNDER} decides. If your strategy needs something
   built, phrase it as a requirement for {FOUNDER} to take to the CTO
   session — don't write technical plans yourself.
4. Deliverables are documents {FOUNDER} can present or send, in
   {language(s)}.
5. When your picture of product state feels stale, ask {FOUNDER} for a
   fresh state packet from the CTO session rather than guessing.
6. Challenge {FOUNDER} when they're wrong — they need the sparring before
   the real red team provides it.

## Your first sprint (in order)
1. Objection-handling brief for the known hard questions: strong honest
   answer + evidence + trap to avoid + likely follow-up, each.
2. Market analysis: TAM/SAM/SOM bottom-up AND top-down, with sources;
   competitor comparables.
3. Competitive positioning one-pager, moat question answered honestly.
4. Progress reframe: milestone checklist with per-item verification
   instead of bare percentages.
5. Business model draft with unit-economics skeleton (unknowns labeled
   ASSUMPTION).
6. Question list: everything you need from {FOUNDER} or the CTO session.

Start with deliverable 1, then ask for the date of the next stakeholder
meeting to sequence the rest.
```

## UPLOAD-CHECKLIST.md content (the founder's 5 steps)

1. claude.ai → Projects → new Project **"{PROJECT} CEO"**.
2. Paste `PROJECT-INSTRUCTIONS.md` into the Project's custom instructions.
3. Upload every other file in `ceo-pack/` as project knowledge.
4. Enable web search for the Project.
5. Open a conversation; the first sprint starts itself.

**Refresh rule:** when plans change materially or a milestone flips, tell
the CTO session "refresh the CEO pack" — it regenerates the pack (new PR),
you re-upload the changed files. The pack's date tells you when it's stale.

## claude.ai interface specifics (moved here from the general docs)

The general kit docs are vendor-neutral; the claude.ai-specific steps they
originally carried live here instead. Verbatim from the source kit:

- Setup (from `prompts/3-ceo-strategy-project.md`): claude.ai → Projects →
  new Project "{PROJECT} CEO" → paste the prompt as the Project's custom
  instructions → upload as project knowledge: plans 01, 02, the operating
  model, and any market/vision doc → enable web search. Refresh the
  uploaded plans when they change materially.
- Why a Project, not a chat: a chat forgets when it fills; a Project keeps
  knowledge across every conversation.
- Flow C step 3 (from `QUICKSTART.md`): claude.ai → new Project
  "{PROJECT} CEO" → paste `ceo-pack/PROJECT-INSTRUCTIONS.md` as custom
  instructions → upload the folder's other files as knowledge → enable web
  search.
- Remote-session "sources" (from `prompts/0-bootstrap-new-project.md` and
  `QUICKSTART.md` Flow B): in a remote claude.ai/code session, the kit repo
  is made reachable by adding it to the session's sources.

## The loop with the rest of the system

CEO output that implies product scope ("we need self-serve signup sooner")
goes to {FOUNDER} → if accepted, {FOUNDER} tells the CTO session → CTO
records the decision and adjusts roadmap/briefs. Forward any CEO document
containing technical claims to the CTO session for a sanity-check BEFORE it
reaches an investor — nothing red-teamable on grounds you control.
