# workflow

**Sessions die; the repo remembers.** This is an operating system for running
software projects with a human founder and AI coding sessions in defined
roles — Founder, CTO session, Executor sessions, Strategy advisor. Any
vendor, any model, any mix: the method is defined in files, so a session from
any provider reads the same three files and is fully oriented in minutes.
When a session ends — context exhausted, subscription swapped, vendor
changed — nothing is lost, because the project's brain was never in the
chat.

## The proof

Extracted from the **gollai** project (2026), where this method took a
codebase from rebrand to a live multi-tenant platform in **six days** — with
every decision, brief, and incident written down. The second consumer is a
university project family running it as a [process-only overlay](docs/appendix/overlays.md) on top of
their own repos. The kit you see here is that method, generalized and
vendor-neutral; where something is included but never run in production, it
is labeled as such (see below).

## What you get

- **Repo memory** — `STATUS.md` (the board), `FOUNDER.md` (the founder's
  async voice), numbered plans, briefs, handoffs, reports. The state of the
  project is inspectable text, not chat history.
- **Roles** — the founder decides and merges; the CTO session plans, briefs,
  and reviews (never codes); executor sessions build one brief at a time; an
  optional strategy advisor advises. Vendors are cast into roles through
  lanes — swap the vendor under a lane and the project does not notice.
- **The loop** — decision recorded → brief → claimed in STATUS before the
  first commit → built on `brief/<id>` → PR proves the acceptance checklist →
  CTO review → founder merges → board updated.
- **The rules** — thirteen of them, each paid for by a real incident.
  No brief, no code. Never push to main. Honest states over fake data.
  Full text: [WORKFLOW.md](WORKFLOW.md).
- **Maturity labels** — every template and prompt is marked ✅ *proven in
  production* or 🧪 *included but unproven*. We label what we have never
  run. You should know which is which before you bet a project on it.

## Install

One command, five questions, from Git Bash (Windows) or any Unix shell:

```sh
git clone https://github.com/tech-officer/workflow && ./workflow/install.sh /path/to/your-repo
```

Then follow [QUICKSTART.md](QUICKSTART.md) — three flows (existing project,
new project, strategy advisor), each about five minutes.

## The contract

`STATUS.md` carries a YAML front-matter block that machines read: project,
phase, state, lane, blocker, and the ready queue in a fixed schema. Tools
parse the front matter and never guess from prose; the only write a tool may
perform is appending to `FOUNDER.md`'s Inbox. The full contract — schema,
field ownership, tool rules — is [INTEGRATION.md](INTEGRATION.md).

## The ecosystem

This repo is the method; it **writes** state. The sister product is
**TechOfficer** — a phone-first console that **reads** this workflow's STATUS
contract across all your projects and routes the next brief to whichever of
your AI subscriptions is coldest. One workflow, any vendors, one screen.
(Sister repo, in development.)

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

MIT — see [LICENSE](LICENSE). Use it, fork it, run your projects on it.

---

Further reading: [WORKFLOW.md](WORKFLOW.md) (the method) ·
[QUICKSTART.md](QUICKSTART.md) (three flows) ·
[GUIDE-1](GUIDE-1-new-project.md) / [GUIDE-2](GUIDE-2-existing-project.md)
(first hour) · [INTEGRATION.md](INTEGRATION.md) (the contract) ·
[SCALING.md](SCALING.md) (what to drop when it's just you) ·
[CONTRIBUTING.md](CONTRIBUTING.md) (how to help)
