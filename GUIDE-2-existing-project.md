# Guide 2 — Retrofitting an EXISTING project (without stopping work)

The trap with retrofits: writing plans that describe the project you *wish*
you had. The fix: the CTO session audits the actual code FIRST, and every
plan claim is grounded in file:line reality. (On gollai, the pre-workflow
docs claimed ~216 refs needed renaming; the audit found 494. Plans built on
stale claims die in the first week.)

## Step 1 — Install the skeleton (2 min, you)

Run the installer: `./workflow/install.sh /path/to/your-repo` (Guide 1
step 1 has the details). Retrofit notes:
- **Don't fill plan 02's milestones yet** — leave the skeleton. The CTO
  session writes it after the audit, not before.
- If an `AGENTS.md` already exists, the installer appends the protocol block
  to it — nothing is replaced, and no other existing file is overwritten
  without asking. `STATUS.md` arrives with machine-readable front matter
  (schema: `INTEGRATION.md`); `FOUNDER.md` is your async channel to
  sessions — they read it at boot and at each brief claim.
- **Don't own the repo, or must not add files to it?** Skip the installer
  and run an overlay instead — the whole process layer lives in a separate
  private repo: `docs/appendix/overlays.md` (🧪 unproven).

Commit the scaffold to main directly this once. ⚠️ **If an AI session runs
the installer for you, say "commit the scaffold directly to main" in so many
words** — its default is branch → PR, and until that PR merges, every tool
that reads `STATUS.md` from the default branch reports the repo as **not
onboarded**: the scaffold exists and nothing can see it.

## Step 2 — Boot the CTO session with the EXISTING PROJECT variant

Paste the **CTO — existing project** prompt from `docs/ops/boot-prompts.md`
(read order: AGENTS.md → STATUS.md → FOUNDER.md, then the procedure in
`docs/plans/04-operating-model.md`).
Its first deliverable is an **audit, not a plan**:

1. Codebase reality: what exists, what actually runs, test/build health,
   CI truth (do checks really fire on PRs? wrong trigger branches are a
   classic silent failure), deploy reality, secrets hygiene.
2. In-flight work: open branches/PRs, who's on what.
3. Contradictions: where docs/README claims disagree with code. Every one
   goes in the audit — these are the landmines.

Then, WITH you (it interviews, you decide): plan 01 (vision — often just
writing down what's in your head), plan 02 (roadmap: milestone 1 = shortest
path to the next real proof — live deployment, first customer, first
revenue — with a verifiable exit checklist), all delivered as one PR.

## Step 3 — Fold in-flight work in gently

- Anything already in progress gets a **retroactive brief** — a short one
  recording goal + acceptance for work already moving. Don't halt work to
  write paperwork; write the paperwork around the work.
- Existing collaborators: send them the "how we work now" message (the CTO
  session drafts it — on gollai this onboarding message pattern worked
  well: what changed, what they do differently tomorrow morning, where the
  board is). The change for them is small: claim before code, checklist in
  the PR.
- Open PRs predating the workflow: review and merge them as-is; the rules
  apply from the next branch onward. No retroactive enforcement.

## Step 4 — The first clean loop

Run one full loop (brief → claim → PR → review → merge) on a SMALL task
within the first two days, even if a bigger one is burning. The team learns
the loop on something low-stakes; the big task then runs through a system
everyone has already seen work.

## Retrofit checklist

- [ ] Scaffold committed; existing AGENTS.md preserved and extended
- [ ] CTO audit done — I read it and was surprised by at least one thing
      (if nothing surprised you, the audit was too shallow — push back)
- [ ] Plans 01+02 merged; milestone 1 exit checklist is verifiable
- [ ] In-flight work has retroactive briefs; collaborators got the message
- [ ] One full loop completed on a small task
- [ ] STATUS.md is the only place anyone asks "what's the state?"
