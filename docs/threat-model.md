# TechOfficer — Threat Model

_Status: v1, 2026-08-14 · Owner: Mansoor (founder) · Written to be audited._

This document says, precisely, what TechOfficer holds, what it never holds,
and what an attacker gets when each component falls. It is written for a
developer deciding whether to point their client work at us, and for the
independent auditor who will review it before paid launch. Vagueness here
reads as evasion, so the claims are written to be checked — each one names
the command or code path that proves it.

**Maturity labels.** TechOfficer is mid-build. Every claim below is labelled:

- **Shipped** — true of running code today.
- **Designed** — true of the written contract/spec, not yet implemented.
  The milestone that delivers it is named.

Nothing labelled *Designed* should be read as a current property of a
running system.

---

## 1. The system

Three pieces, plus the phone:

| Piece | Runs on | Status |
|---|---|---|
| **Workflow kit** — briefs, review gates, router policy (markdown) | The user's repos | **Shipped** — public, `github.com/tech-officer/workflow` v1.0.0 |
| **Orchestrator** — spawns the genuine `claude`/`kimi`/`gemini`/`codex` CLIs, runs the job loop | The user's own VPS | **Designed** — contract written (cited below as the orchestrator contract), ships in milestone M2 |
| **Control plane** — fleet sync, phone backend, push, auth, billing, audit | Our cloud (Vercel + Supabase Postgres) | **Partially shipped** — the v1 console (single-user, read-only observatory) runs today; the multi-tenant paid control plane is milestone M4 |
| **Phone app** — Fleet / Agents / Reviews / Chat / More | The user's phone (PWA) | **Designed** — milestone M3 |

Because the control plane is only partially shipped, this document treats
**two systems**: the *v1 console that runs today* (§6.1) and the *v3
architecture it grows into* (everything else). Where they differ, both are
stated.

---

## 2. Assets

| Asset | Where it lives | Crosses which boundary |
|---|---|---|
| User source code | The user's GitHub repos; checked out on the user's VPS | GitHub ↔ user VPS only. **Never** reaches the control plane. |
| GitHub tokens | The user's VPS only: a fine-grained PAT, mode `0600`, readable only by the dedicated `agent` OS user, scoped to Contents + Pull requests (the VPS setup runbook, §7). The v1 console additionally holds its own tokens — see §6.1. | None, in the v3 design. Never transmitted to the control plane. |
| AI subscription credentials | The user's VPS only, in the `agent` user's home (`~/.claude`, `~/.kimi`, `~/.gemini`, `~/.codex`), written there by the user logging in themselves | None. We detect login state; we never see, move, or refresh these. |
| Fleet metadata | Control-plane database: project names, repo URLs, job statuses, lane state, sync snapshots (the control plane's `db/schema.ts`) | User VPS → control plane (orchestrator reports); control plane → phone (display) |
| Job logs | The user's VPS (full); the control plane receives redacted log events | User VPS → control plane, after redaction (§5) |
| Phone session grants | Control plane (issued/revoked); the phone (held for the grant's lifetime) | Control plane ↔ phone |
| Billing data | Control plane + payment processor | Phone/control plane ↔ processor |

---

## 3. Trust boundaries

```
        ┌─────────────┐   reads/writes    ┌──────────┐
        │   GitHub     │◀────────────────▶ │ User VPS  │  source code,
        │ (user's acct)│   user's own PAT  │           │  CLI logins,
        └──────┬───────┘                   │           │  GitHub PAT
               │  PRs, review metadata     │  agent    │
               │                           │  user     │
        ┌──────▼───────┐   metadata only   │ (no sudo) │
        │ Control plane │◀────WS, outbound──┤           │
        │  (our cloud)  │   redacted logs   └─────┬─────┘
        └──────┬───────┘                         │ spawns as
               │  session grants, push           │ subprocesses
        ┌──────▼───────┐                   ┌─────▼─────┐
        │    Phone     │                   │ AI vendor │  prompts + code
        │    (PWA)     │                   │   CLIs    │  the user sends
        └──────────────┘                   └───────────┘
```

Boundaries that matter:

1. **User VPS ↔ control plane.** Outbound-only WebSocket, initiated by the
   orchestrator; the control plane never opens a connection in, and no
   inbound port is exposed for it (*Designed*, M2 — orchestrator
   contract, §5). Carries metadata and redacted logs,
   never source content, never credentials.
2. **Control plane ↔ phone.** Session grants (§4); no credentials on the
   device, ever.
3. **User VPS ↔ GitHub.** The user's own fine-grained PAT. We are not in
   this path in the v3 design.
4. **User VPS ↔ AI vendors.** The genuine vendor CLIs, logged in by the
   user, talking to the vendor directly. We are not in this path — no
   proxying, no token relay, no middle position.
5. **Control plane ↔ GitHub** exists *only in the v1 console* (§6.1) and
   is exactly what the v3 architecture removes.

---

## 4. What we hold, what we never hold

### What the control plane holds (v3 design)

Fleet metadata, job status, push routing, auth, billing, and the audit log
(PRD v3 §5.2). Nothing else.

### What we never hold — stated as testable claims

Each claim names its check. "Verify per PR" items run in CI or review; the
rest are one-command audits anyone can repeat.

1. **No user source code content in the control plane.**
   Check: the control plane's database schema carries metadata columns only,
   greppable in its repo —
   `grep -niE "source|content|diff|blob" db/schema.ts db/migrations/*.sql`.
   Run it today and it returns one column, defined in both places —
   `signals.source` in `db/schema.ts` and its migration: provenance,
   *where* a signal's evidence came from (e.g. "STATUS.md blocker ·
   updated 3h ago"). Its sibling `signals.quote` holds the evidence string
   itself — a blocker line or PR title parsed from the repo's `STATUS.md`
   contract file. Both are governance metadata, not source code; any
   further hit is a finding. The
   transport contract (orchestrator contract, §5) defines event
   payloads of metadata and redacted log lines; there is no field capable
   of carrying a file body. A server-side convenience cache of repo
   contents was explicitly rejected (the control plane's `DECISIONS.md`, 2026-08-11) because
   it would convert a metadata breach into a source-code breach.
2. **No AI subscription credentials anywhere in our systems.**
   Check: `grep -rniE "claude_code_oauth|\.kimi|\.gemini|\.codex" app/ lib/ db/` in the
   control-plane repo returns no credential-handling code. An engine is usable only if its
   official CLI is installed *and already logged in by the user* on their
   own server; the orchestrator spawns the binary and cannot see its login
   state (the control plane's `AGENTS.md`, rule 19).
3. **No GitHub tokens in the control plane (v3).**
   Check: the PAT lives at `~/.config/techofficer/github-token` on the
   user's VPS, mode `0600`, owner `agent` (VPS setup runbook, §7), and
   no orchestrator→control-plane message type carries a token field
   (contract §5). Residual exception today: the v1 console — see §6.1.
4. **No vault on our side.** There is no platform vault at all; credential
   state exists only on the user's own server (the control plane's `AGENTS.md`, rule 17).
   Check: per PR, the built client bundle and any stored payload are
   grepped for token shapes (`ghp_`, `github_pat_`, `sk-`, `-----BEGIN`),
   per rule 17's standing verification.
5. **The deprecated token-injection design is not a dependency.**
   Check: `grep -rn "vault-inject\|CLAUDE_CODE_OAUTH_TOKEN" app/ lib/ db/` in the
   control-plane repo returns nothing. See §7.

If any of these greps ever returns a hit, that is a security incident, not
a documentation bug — report it per `SECURITY.md`.

### Phone session grants (*Designed*, M3)

Specified here so the design is auditable before it is built:

- **Scope:** `read + approve` — view fleet state and approve/reject review
  cards. No shell access, no job submission, no settings changes.
- **Lifetime:** 4 hours per grant (the audit-log line in the v4 mockup:
  *"phone session grant issued (4h, read+approve)"*).
- **Storage:** the grant token only; the device holds **no** GitHub tokens,
  AI credentials, or source content. Approving a merge executes via the
  user's GitHub PAT *on their VPS*, never from the phone.
- **Revocation:** server-side, immediate; grants are also invalidated on
  password/credential change events and on demand from the web console.
- **Audit:** every grant issuance, use, and revocation is an audit-log line.

This is the specification the M3 implementation (push notifications +
session grants) must conform to; deviations get recorded in the control plane's `DECISIONS.md`,
not shipped silently.

---

## 5. Log redaction

Job logs cross the user-VPS → control-plane boundary, so they are the one
place a secret could ride along by accident. Redaction happens **on the
orchestrator before transmission, and again on ingest** — two layers,
because a single point of failure on a secret is not a control
(orchestrator contract, §5).

The concrete pattern set (assigned to this document by the orchestrator
contract, §9 question 4):

| Pattern | Matches |
|---|---|
| `github_pat_[A-Za-z0-9_]{20,}` | GitHub fine-grained PATs |
| `gh[opsur]_[A-Za-z0-9]{20,}` | GitHub OAuth/server/refresh/user tokens |
| `ghp_[A-Za-z0-9]{20,}` | GitHub classic PATs |
| `sk-[A-Za-z0-9_-]{20,}` | OpenAI / OpenRouter-style API keys |
| `AIza[A-Za-z0-9_-]{20,}` | Google API keys |
| `AKIA[A-Z0-9]{16}` | AWS access key IDs |
| `-----BEGIN [A-Z ]*PRIVATE KEY-----` … `-----END` | Private key blocks |
| `(?i)(authorization:\s*bearer\s+)\S+` | Bearer headers |
| `(?i)(postgres(?:ql)?://[^:/\s]+:)[^@\s]+(@)` | Passwords in database URIs |
| `(?i)(api[_-]?key\|token\|secret\|password)(\s*[:=]\s*)\S+` | Key=value secret assignments |

Replacement is `[REDACTED:<kind>]`, preserving position so logs stay
readable. The set is versioned with this document; adding a pattern is a
docs-visible change, not a silent code edit.

**Residual risk, stated plainly:** pattern-based redaction is best-effort.
A secret in an unusual format can leak into metadata logs. This is one
reason the blast-radius table (§6) assumes an attacker *with* control-plane
access reads the logs — and concludes they get redacted metadata, not the
keys to anything.

---

## 6. Blast radius — what a breach of each component yields

### 6.0 Control plane fully breached (v3 design)

**Attacker gets:** fleet metadata — project names, repo URLs, job statuses
and timings, redacted log lines, push routing tokens, account/billing
records, the audit log (and the ability to forge or delete its rows going
forward — a tampered audit trail is the worst realistic outcome here, and
the reason audit events should eventually be anchored externally; recorded
as a known limitation, not yet designed).

**Attacker does not get:** source code (not stored — claim 1), AI
credentials (claim 2), GitHub tokens (claim 3), vault contents (claim 4),
or any way to reach into a user's VPS (the transport is outbound-only; a
breached control plane cannot open a connection to an orchestrator — it can
only wait for orchestrators to call in and then lie to them, which the
orchestrator's admission rules bound: commands it accepts from the control
plane are limited to dispatch/cancel of jobs the user already configured).

**This row is the architecture's whole pitch:** a full breach of the paid
product yields metadata, not code and not credentials.

### 6.1 The v1 console, as it runs today (*Shipped* — the honest exception)

The console running today predates the pivot and **does** hold tokens, and
this document would be marketing if it pretended otherwise:

- A GitHub OAuth access token (scopes `read:user repo`) per signed-in
  session, held in the server-side JWT session cookie; there is exactly one
  allowed user (single-user lock; everyone else gets a bare 404 —
  the control plane's auth module).
- Two PATs in environment variables on the hosting platform: a read-only
  sync token (private-repo metadata sync) and a fine-grained write token
  (Contents read+write on the founder's repos) powering founder notes
  (the console's `.env.example`).
- Supabase Postgres with fleet metadata (same shape as the v3 table).

A breach of today's console therefore yields a write-capable GitHub token
for one user's repos — serious, and scoped to exactly that. This is a
**transitional, named exposure**: the v3 architecture closes it by moving
every token onto the user's own VPS. Until then it is mitigated by the
single-user lock, the 404 posture, and token scoping — not eliminated.

### 6.2 User's VPS breached

**Attacker gets:** everything the `agent` OS user can reach — the checked-out
source of projects on that box, the CLI login state in `~/.claude` /
`~/.kimi` / `~/.gemini` / `~/.codex` (i.e. use of the user's AI
subscriptions), the fine-grained GitHub PAT (Contents + Pull requests on
the repos the user scoped it to), and the local job queue/logs.

**Attacker does not get:** sudo (the agent user has none — the VPS setup runbook,
§6), deployment artifacts (owned by a different user), the control plane's
other tenants (they hold none of this box's trust — no inbound control
channel exists to hijack), or the user's other infrastructure beyond what
the scoped PAT touches.

**Mitigations shipped in the runbook:** dedicated unprivileged user,
per-job git worktrees, firewall allowing only 22/80/443 with no
orchestrator port, fail2ban, unattended upgrades, SSH hardening
(runbook §§2–3, 6). **This is the highest-value target in the
system, by design** — we chose to concentrate custody where the user
already concentrates it, rather than add ourselves as a second custodian.

### 6.3 Phone stolen (*Designed*, M3)

**Attacker gets:** whatever the phone's OS lock allows. If they defeat
that, a live session grant buys them up to 4 hours of `read + approve` —
they can see fleet state and could approve a pending merge inside the
window.

**Attacker does not get:** any credential (the device stores none), source
code (our cloud holds none to serve — claim 1; even the dev-mode diff view
on review cards is assembled on the user's VPS with the user's own GitHub
token, per the 2026-08-11 zero-custody decision, so the phone grant alone
reaches only card metadata), or durable access (grants expire and are
revocable from the web console the moment the loss is noticed).

### 6.4 Our install artifact or npm supply chain compromised

The orchestrator install path is an npm package plus an install script run
on the user's VPS. A compromised artifact runs with the `agent` user's
privileges → equivalent to §6.2 scoped to that user.

**Mitigations today:** pinned `package-lock.json`, CI build on every PR.
**Honest gaps:** we do not yet sign releases or publish provenance
attestations; both are pre-paid-launch work, recorded here rather than
implied.

### 6.5 An AI vendor breached (or its CLI compromised)

**Attacker gets:** whatever that vendor holds — the user's subscription
account and whatever prompts/code the user sent that vendor (true with or
without TechOfficer). **Not:** the other engines' credentials (separate
vendors, separate logins), the GitHub PAT (never given to any vendor CLI),
or the control plane (no shared secret exists to steal).

**Our exposure is availability, not custody:** we depend on four vendors'
CLIs keeping a working headless mode. Multi-engine neutrality is the
mitigation — the router fails over, and no single vendor is fatal
(the control plane's `DECISIONS.md`, 2026-08-11).

---

## 7. The deprecated design, described honestly

The pre-pivot "Founder engine" (`sandbox/` in the control-plane repo) **extracted OAuth credentials
from the user's CLIs and injected them into containers** —
`vault-inject.sh` materialized `CLAUDE_CODE_OAUTH_TOKEN` and copied
`~/.kimi` / `~/.gemini` into a Docker image's mount. It worked, and it was
abandoned for two reasons: Anthropic's February 2026 policy bans
subscription OAuth inside third-party harnesses (spawning the genuine CLI
is the tolerated path), and holding credentials at all contradicts the
zero-custody position we sell.

It is kept in the control-plane repo, marked **deprecated, personal-lab-only**, because
its job contract and failure-mode notes carry forward to the CLI-spawner.
No product code may depend on it — that is a standing, greppable rule
(claim 5, §4).

---

## 8. Accepted risks — named, not buried

Every security-relevant accepted risk in the control plane's `DECISIONS.md`, cross-checked
against the ledger:

1. **Agent CLIs run as host subprocesses, not containers** (2026-08-11).
   Isolation is OS-user-level, not container-level: a misbehaving agent
   reaches anything its OS user can. Mitigations: the dedicated user owns
   no deployment artifacts, per-job worktrees, the CLIs' own permission
   modes. Chosen deliberately over credential-mounting containers, which
   would have recreated the deprecated design's shape.
2. **The orchestrator holds a GitHub token with write scope on the user's
   box** (runbook §7). Contents + Pull requests is more than
   read-only; a VPS compromise turns it into write access to the scoped
   repos (§6.2). Scoped fine-grained, one box, one user — but write is
   write, and we say so.
3. **We depend on four vendors' CLI binaries** (2026-08-11), including
   their headless modes and their own permission systems. A vendor can
   break us; none can custody us.
4. **We cannot log a user in, rotate their credentials, or recover a
   broken session** (2026-08-11). Strictly worse UX than injection; the
   correct trade, taken knowingly.
5. **CI reports but does not gate; the founder is the gate** (2026-08-14).
   GitHub Free has no branch protection on private repos, so a red PR
   *can* be merged — it takes ignoring a visible warning. Tripwire
   recorded: the moment a second person or session can merge, upgrade to
   Team and make the build check required.
6. **Review cards are assembled on the user's VPS with the user's token**,
   not from our cache (2026-08-11) — slower and more failure-prone; the
   price of claim 1.
7. **The v1 console holds tokens today** (§6.1) — transitional exposure,
   closed by the v3 architecture, not by denial.
8. **One rented VPS is a single point of failure** (2026-08-07) —
   availability, not custody; fleet state survives on the control plane,
   work survives in git.
9. **Redaction is pattern-matching** (§5) — best-effort, with a named
   residual leak risk into metadata logs.
10. **The public kit names third parties without written consent**
    (2026-08-12 — gollai and Yeditepe; the founder judged the exposure
    acceptable and the fix is a README edit if either objects), and its
    pre-launch PR/review history was discarded in the squashed republish
    that scrubbed client and personal names (2026-08-13). Privacy and
    provenance risks, taken to ship the distribution engine; the launch
    history itself was secret-scanned clean before the flip.

---

## 9. What happens next

- The independent security audit promised in PRD v3 §3 is a **founder
  action before paid launch** — commissioning it is out of scope here.
  This document is written to be the auditor's starting point: every claim
  has a check, every trade has a name.
- When the orchestrator (M2), phone app (M3), and paid control plane (M4)
  ship, each *Designed* label above must be re-verified against the code
  and flipped to *Shipped* — or the document changes, not the truth.
