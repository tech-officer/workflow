# Security Policy

TechOfficer is mission control for AI coding agents, running on infrastructure
the user already owns. Its security posture rests on one promise — **zero
custody**: user source code and user credentials never reach our cloud. The
full reasoning, trust boundaries, and per-component blast radius are in
[`docs/threat-model.md`](docs/threat-model.md) — **the canonical, public copy
of the threat model lives in this repository.** If anything in the product
contradicts this policy or that document, that contradiction is itself a
vulnerability — please report it.

## Reporting a vulnerability

**Please do not open a public issue for a security problem.**

- **Primary:** use GitHub's private vulnerability reporting — the
  **"Report a vulnerability"** button on the repository's *Security* tab.
  This creates a private advisory visible only to the maintainer. Reports
  about any TechOfficer component are welcome here — this repository is the
  public front door even when the affected component is the (private)
  control plane.
- **If that is unavailable to you:** contact the founder, Mansoor, through
  the GitHub account that owns this repository (`@tech-officer`), and mark
  the message as security-sensitive.

Include: what you found, which component it affects (workflow kit,
orchestrator, control plane, phone app), how to reproduce it, and what an
attacker could do with it. Reports in English or Turkish are both fine.

## What to expect

TechOfficer is currently maintained by one person. Honest commitments, not
aspirational ones:

- **Acknowledgement within 72 hours** of your report.
- A severity assessment and a plan, or a reasoned disagreement, **within
  7 days** of acknowledgement.
- We will tell you when a fix lands, and we will credit you in the release
  note if you want to be named (or not — your choice).

There is no bug bounty programme at this stage. We ask for coordinated
disclosure: give us a reasonable window to fix before publishing. In return,
we commit to not threatening good-faith security research that stays within
the law and does not access other users' data.

## Supported versions

TechOfficer is pre-launch. The supported targets are:

- **Workflow kit** (this repository): the latest tagged release
  (currently the v1.x line).
- **Control plane** (`tech-officer/techofficer`, private): the `main`
  branch only.

There are no supported legacy versions. If you are running anything older,
upgrade before reporting — a finding that only reproduces on an old release
will be answered with an upgrade.

## Disclosure posture

- The **public threat model** ([`docs/threat-model.md`](docs/threat-model.md))
  is maintained in this repository and updated as the architecture ships.
  It names accepted risks explicitly rather than burying them — including
  the transitional exposure that today's v1 console holds a write-capable
  GitHub token (threat model §6.1).
- A **public, independent security audit** will be commissioned before paid
  launch. That audit's findings and their resolution will be published.
- When a reported vulnerability is fixed, the fix and (with the reporter's
  agreement) the credit are published. We do not silently patch and pretend.
