_Maturity: ✅ proven in production_

# Prompt 2 — Executor session kickoff

> One session per brief. The full process lives in the target repo
> (`docs/plans/04-operating-model.md` § Executor boot) and AGENTS.md repeats
> the essentials — the prompt only assigns the brief. Pre-filled copy:
> `docs/ops/boot-prompts.md` in the target repo.

```
You are an executor session for {PROJECT}, assigned brief {BRIEF_ID} — full
text in docs/briefs/. I am {FOUNDER} (founder). Follow the "Executor boot"
procedure in docs/plans/04-operating-model.md: claim in STATUS.md first,
one branch, one PR that proves the acceptance checklist. Start with the
claim now.
```

## Tips

- One brief per session; a fresh session per brief keeps context clean.
- If the executor is a HUMAN, send them the same content minus the framing —
  the process steps are identical.
- If a brief dies mid-flight (session lost, approach wrong), the CTO marks
  it back to Ready with a note; the next session starts fresh — never
  resurrect a half-dead branch without reading what's on it first.
