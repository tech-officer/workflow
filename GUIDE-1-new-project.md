# Guide 1 — Starting a NEW project on this workflow

Time: ~1 hour to a running system. Prerequisite: a git repo (can be empty).
Vendor-neutral throughout — any AI coding session that can read and edit
files in your repo can play any role.

## Step 1 — Seed the repo (2 min, you)

1. Create the repo on GitHub (protect `main` if the plan allows — or just
   follow the never-push-to-main rule by discipline) and clone it, or
   `git init` locally.
2. Run the installer from your kit checkout:
   `./workflow/install.sh /path/to/new-repo`
   — it asks project name, your name, domain, dev URL (Enter if none yet),
   report weekday, then writes every template into place with every
   placeholder filled: `AGENTS.md` (the canonical rules file — thin
   `CLAUDE.md`/`GEMINI.md` adapters point at it), `STATUS.md` (with the
   machine-readable front matter described in `INTEGRATION.md`),
   `FOUNDER.md` (your async channel to sessions), the `docs/` skeleton, and
   your pre-filled prompts at `docs/ops/boot-prompts.md`. (Windows:
   `bash install.sh …` under Git Bash. Manual alternative: copy `templates/`
   into place and find-replace the placeholders yourself.)
3. Commit directly to main this once ("chore: TechOfficer workflow
   scaffold") — the last direct push to main you'll ever make.
   ⚠️ **If an AI session runs the installer for you, say "commit the
   scaffold directly to main" in so many words.** Its default is
   branch → PR, and until that PR merges, every tool that reads
   `STATUS.md` from the default branch reports the repo as **not
   onboarded** — the scaffold exists and nothing can see it.

## Step 2 — Boot the CTO session (5 min, you)

Open an AI coding session on the repo. Paste the **CTO — new project**
prompt from `docs/ops/boot-prompts.md` — its read order is AGENTS.md →
STATUS.md → FOUNDER.md, then the boot procedure in
`docs/plans/04-operating-model.md`. The session will interview you to fill
plan 01 (vision) and plan 02 (roadmap with milestone-1's exit checklist),
then PR them to you.

**Interview prep — know your answers to:**
- What is the product, for whom, and what does "milestone 1 done" mean in
  one sentence? (M1 should be reachable in 4–8 weeks.)
- Who executes? (You alone / a collaborator / executor sessions.)
- Stack preferences, deploy target, budget constraints.
- What must NEVER happen? (These become AGENTS.md hard rules — e.g. "no
  secrets in git", "no external CDN fonts", domain-specific bans.)

## Step 3 — First loop (same day)

1. Merge the CTO session's plans PR after reading it — actually read it;
   this is the decision record you'll be held to.
2. Ask the CTO session for the first 2–3 briefs (it keeps the Ready queue
   ≥2 deep from then on).
3. Boot an executor session with the executor prompt from
   `docs/ops/boot-prompts.md` (or hand a brief to a human). Watch the first
   loop run end-to-end: claim → branch → PR proving the checklist → CTO
   review → you merge.
4. The first loop is the habit-setter. If anything skipped a step (no claim
   line, no checklist in PR, review without explicit verdict), fix it NOW —
   process debt compounds faster than tech debt.

## Step 4 — Optional add-ons (when they earn their keep)

- **Dev environment + auto-deploy** (usually worth it by week 1): every merge
  live on a URL in minutes. Have the CTO session write the deploy runbook to
  `docs/ops/` as it guides you — you'll redo the setup someday.
- **Strategy advisor** 🧪 (when investors/customers enter the picture):
  tell the CTO session "prepare the strategy advisor" — it follows
  `docs/appendix/ceo-pack.md` (🧪 unproven) and hands you a `ceo-pack/`
  folder to load into the advisor tool of your choice (QUICKSTART Flow C).
- **Bi-weekly report ritual** (as soon as anyone external cares about
  progress): `prompts/5-biweekly-report.md`.

## Day-0 checklist

- [ ] Templates in, placeholders replaced, scaffold committed
- [ ] CTO session booted, interviewed me, plans 01+02 PR'd and merged
- [ ] Milestone 1 has an exit checklist where every item names its
      verification
- [ ] First brief written and claimed
- [ ] First PR merged with its checklist ticked
- [ ] STATUS.md activity log has ≥3 dated lines and they're all true
