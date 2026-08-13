_Maturity: ✅ proven in production_

# Prompt 0 — One-paste bootstrap (fresh repo → installed → CTO takes over)

> The zero-terminal path for a NEW project. Open an AI coding session on
> the fresh (empty) repo and paste the block below — the session clones the
> kit, asks you the setup questions in chat, runs the installer, takes your
> project document, and boots itself as the CTO.
>
> Requirements: the kit repo must be reachable from the session — public,
> or attached to the remote session's context (vendor-specific setup:
> `docs/appendix/ceo-pack.md`).
> Have your project document (PDF or similar) ready if you have one.

```
This is a brand-new repo. Set it up on my workflow, then become its CTO:

1. Clone the kit: git clone https://github.com/tech-officer/workflow
   into a temp folder — NOT into this repo. If the clone is denied (remote
   session), stop and ask me to make the kit repo reachable to the session.
2. Ask me the installer's five questions (project name, my name, product
   domain, dev URL if any, report weekday), then run the kit's install.sh
   against this repo with those values as flags. Show me the output.
3. Commit the scaffold straight to main — the once-only direct push.
4. I have a full project document (PDF). Ask me for it, save it under
   docs/intake/, and commit it — the repo must remember it, not this chat.
   If I say I don't have one, skip to step 5 without it.
5. Now follow the "CTO boot — new project" procedure in
   docs/plans/04-operating-model.md, including its source-document intake
   step: derive plans 01 and 02 from the document first, and interview me
   ONLY on gaps, contradictions, and decisions the document leaves open.
   You write NO feature code. Start now.
```

## Notes

- After step 3 the repo is a normal workflow repo — everything else
  (executor prompts, handoffs, CEO pack) works exactly as in QUICKSTART,
  and your pre-filled prompts are in `docs/ops/boot-prompts.md`.
- The document in `docs/intake/` is input, not a decision record — the CTO
  still records every decision in the plans with date + decider, and flags
  anything in the document it couldn't verify rather than copying it.
- For an EXISTING repo, don't use this: run `install.sh` per Flow A, or
  paste this same block with step 5 pointed at "CTO boot — existing
  project" (the audit still comes first; the document informs the plans,
  never replaces the audit).
