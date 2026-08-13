# agents/router.md — TechOfficer Agent Router (v1.0, PRD v3)

Ships in the **public workflow kit** (PRD v3 §5.3) — this file is user-editable
policy, not hidden platform logic. The orchestrator reads it per project. This
is its canonical home (`DECISIONS.md`, 2026-08-11 — kit-bound files have one
home); downstream repos keep no second copy.

> **v1.0 (2026-08-11)** rewrites v0.1 for the pivot. v0.1 routed on *vault
> paths* (`vault/claude-token` → `CLAUDE_CODE_OAUTH_TOKEN`). **That mechanism is
> deprecated** (PRD v3 §3, §10): the orchestrator spawns the genuine official
> CLI as a subprocess on the user's own machine and never touches a credential.
> An engine is available iff its **official CLI is installed and already logged
> in on that machine** — discovered, never injected.

## Engines

| Engine | CLI binary | Auth (never ours) | Typical bucket |
|---|---|---|---|
| claude | `claude` | user's own `claude` login on their machine | Max 5-hour + weekly |
| kimi   | `kimi`   | user's own `kimi` login | membership 5-hour |
| gemini | `gemini` | user's own Google login | daily free tier |
| codex  | `codex`  | user's own ChatGPT login | plan 5-hour |

**Availability probe:** binary present on `PATH`, `--version` succeeds, and the
CLI reports itself authenticated. A probe never reads, copies, prints or
fingerprints a credential. If a CLI is not logged in, the engine is
`needs_login` and the user is told to run its login command **on their own
server** — we never do it for them.

## Task routing policy (mode → preference order)

- build    → kimi → codex → gemini → claude
- review   → claude → gemini → kimi → codex   # reviewer NEVER equals builder
- research → gemini → claude → kimi → codex
- docs     → kimi → gemini → codex → claude

## Invariants

1. **Builder ≠ reviewer**, enforced in code and failing closed. The engine that
   produced a diff is refused the review job for that diff, with a logged
   reason (AGENTS.md rule 16).
2. **Serialize per engine by default** (PRD v3 §5.1). One concurrent session per
   engine per user — "ordinary individual usage". Fleet parallelism comes from
   running *different* engines at once, never from hammering one subscription.
   Raising this is a user's explicit, logged choice.
3. **Quota-aware.** Read each engine's remaining 5-hour bucket before
   dispatching; below the reserve threshold, fail over in preference order.
4. **All buckets exhausted → park the job with an ETA**, never fail silently.
   The phone shows the parked state and when it resumes.
5. **Never a dead engine.** Availability is probed before dispatch, not
   discovered by a failing session twenty minutes in.

## Cost

Zero platform compute. Every job logs engine, wall time and tokens for the
user's own reporting — there is no credit ledger, no metering, no markup
(PRD v3 §5.5).

## Scale path

Orchestrator on the user's own VPS → same job contract across multiple servers
in one fleet (`vps-1`, `vps-2`) → admission control keyed on these preference
lists. The interface does not change.
