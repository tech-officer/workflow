_Maturity: 🧪 included but unproven_

# Prompt 4 — Session handoff & fresh-session boot

Two halves: ask the OLD session to write the handoff, then boot the NEW one.
(Pre-filled copies live in the target repo's `docs/ops/boot-prompts.md`.)

## 4a — Ask the dying session (when context nears its limit)

```
Your context is nearly full. Write docs/handoff/NNN-<era>.md (next number,
structure per 000-TEMPLATE.md), including anything we discussed that is NOT
yet written elsewhere in the repo — the handoff is the last chance to save
it. Commit on your branch and open a PR — write for a reader with zero chat
history.
```

## 4b — Boot the fresh session (after merging the handoff PR)

```
You are the {ROLE} session for {PROJECT}. I am {FOUNDER} (founder). Your
predecessor left a handoff: follow the "CTO boot — successor session"
procedure in docs/plans/04-operating-model.md and prove you're oriented
before touching the queue.
```

## Notes

- Works for ANY role (CTO, executor mid-brief) — set {ROLE} accordingly; the
  successor procedure's read order is role-independent.
- If the old session died before writing a handoff: boot the new one anyway
  (STATUS + plans carry most of it) and tell it what you remember; have it
  write the missing handoff entry from that + the activity log, marked as
  reconstructed.
- Anything discussed but never written into the repo does not survive the
  handoff. If the new session seems unaware of a decision, tell it once and
  have it recorded permanently.
