# QUICKSTART — the whole kit in three flows

> One copy, a few answers, one paste. The installer fills every placeholder
> and writes your ready-to-paste prompts into the target repo at
> `docs/ops/boot-prompts.md` — so the prompts below are here for reference;
> after installing you copy them from your own repo, pre-filled.
>
> Vendor-neutral: `AGENTS.md` is the canonical rules file; the installer also
> writes thin `CLAUDE.md` / `GEMINI.md` adapters that point at it (only if
> absent — an existing adapter is never clobbered). Any AI coding session
> that can read files in your repo works.
>
> **Windows:** run the installer under Git Bash (comes with Git for Windows)
> or WSL: `bash install.sh <path>`. There is no separate .ps1 — Git Bash is
> the supported route.

## Flow A — existing project (~5 minutes)

1. `git clone <this-kit> && ./workflow/install.sh /path/to/your-repo`
2. Answer the questions (project, your name, domain, dev URL). An existing
   `AGENTS.md` is appended to, never clobbered; nothing else is overwritten
   without asking. `STATUS.md` is written with machine-readable front matter
   — the schema tools read is in `INTEGRATION.md`.
3. `git add -A && git commit -m "chore: TechOfficer workflow scaffold"` —
   direct to main, this once only.
4. Open an AI coding session on the repo and paste (values pre-filled in
   your `docs/ops/boot-prompts.md`):

   ```
   You are the CTO session for {PROJECT}. I am {FOUNDER} (founder). Read, in
   order: AGENTS.md → STATUS.md → FOUNDER.md — then follow the "CTO boot —
   existing project" procedure in docs/plans/04-operating-model.md. You
   write NO feature code. Start the audit now.
   ```

5. The CTO audits the code, interviews you, PRs the roadmap. You merge.

## Flow B — new project (~5 minutes)

**Zero-terminal variant (recommended):** create the repo, open an AI coding
session on it, and paste the block from `prompts/0-bootstrap-new-project.md`
— the session clones the kit, asks the five setup questions in chat, runs
the installer, commits your project PDF to `docs/intake/`, and boots itself
as CTO (interviewing you only where the PDF is silent). Needs the kit repo
reachable: public, or attached to the remote session's context.

**Terminal variant:**

1. `git init /path/to/new-repo` (or create on GitHub and clone it empty).
2. `./workflow/install.sh /path/to/new-repo` — answer the questions.
3. Commit the scaffold straight to main, this once only.
4. Paste into an AI coding session (pre-filled copy in
   `docs/ops/boot-prompts.md`):

   ```
   You are the CTO session for {PROJECT}. I am {FOUNDER} (founder). Read, in
   order: AGENTS.md → STATUS.md → FOUNDER.md — then follow the "CTO boot —
   new project" procedure in docs/plans/04-operating-model.md. You write NO
   feature code. Start the interview now.
   ```

5. Answer its interview; it PRs vision + roadmap; you merge; it cuts the
   first briefs.

## Flow C — strategy advisor 🧪 (~5 minutes of your time)

1. In any project running this workflow, say to the CTO session:

   ```
   Prepare the strategy advisor — follow the CEO pack and deliver the
   ceo-pack/ folder as one PR.
   ```

2. The CTO session follows `docs/appendix/ceo-pack.md` (🧪 included but
   unproven) and PRs the pack. Review + merge — check the "verifiable facts"
   section is actually true; that list is the boundary of every claim the
   advisor will make.
3. Load the pack into the strategy-advisor tool of your choice —
   tool-specific setup steps live in the appendix:
   `docs/appendix/ceo-pack.md`.
4. When plans change materially: "refresh the pack", re-upload.

## Day-to-day cheat lines (all pre-filled in `docs/ops/boot-prompts.md`)

- **Run a brief:** paste the *Executor session* prompt with the brief ID —
  its boot order is AGENTS.md → STATUS.md → FOUNDER.md → the brief's full
  text in `docs/briefs/`.
- **Session dying:** paste the *handoff* prompt; merge its PR; boot the
  successor with the *successor session* prompt.
- **Report day:** see `prompts/5-biweekly-report.md` (kept in the kit —
  it needs audience/language filled per report).
- **Steer sessions while you're away:** append a dated entry to
  `FOUNDER.md`'s Inbox (directive / context / question) — every session
  reads it at boot and at each brief claim, and an unconsumed directive
  blocks new claims.

Deeper reading: `README.md` (the system), `GUIDE-1`/`GUIDE-2` (first-hour
detail), `WORKFLOW.md` (the method), `INTEGRATION.md` (the machine-readable
front matter), `SCALING.md` (what to drop when it's just you).
