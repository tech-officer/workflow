# Contributing

Thanks for considering a contribution. This repo is a method, not a codebase —
most of it is markdown — and it dogfoods its own workflow, so contributions
follow the same loop the kit describes.

## What makes a good contribution

- **Bug reports and experience reports.** If you ran the kit on a real
  project and something broke, drifted, or confused a session, open an issue.
  "I installed this and the boot went wrong at step 3" is the most valuable
  report we get.
- **Fixes and clarifications.** Typos, broken links, stale cross-references,
  installer bugs — small PRs, always welcome.
- **New templates, prompts, or rules.** These need a story. The kit's
  position is that every rule here was paid for by a real incident; new
  material should say what reality taught it. If you have not run it, mark it
  🧪 *included but unproven* — the maturity labels are a feature, not an
  admission.

## What will not merge

- **Contract changes by drive-by.** `INTEGRATION.md` (the STATUS/FOUNDER
  schema) is versioned deliberately; downstream tooling parses it. Propose
  schema changes in an issue first.
- **Rewrites of the thirteen rules.** Argue against a rule in an issue;
  don't edit it in a PR.
- **Vendor-specific lock-in.** The kit is vendor-neutral. Adapter stubs
  (`templates/adapters/`) for a specific tool are fine; making the core
  method depend on one vendor is not.

## How this repo itself runs

This repo is managed by the method it ships: the board is `STATUS.md`, work
happens in numbered briefs under `docs/briefs/`, one brief per branch per PR.
External contributors don't need to run the full loop — open an issue or a
PR and a maintainer will route it — but reading
[WORKFLOW.md](WORKFLOW.md) first will tell you why the repo looks the way it
does.

## Style

- Plain, honest prose. Candid beats polished; labeled beats hidden.
- American English, wrapped lines, no emoji except the ✅/🧪 maturity labels.
- Keep placeholders as `{PLACEHOLDER}`; never commit real project names,
  paths, or people into templates and prompts.

## License

By contributing you agree your contribution is licensed under the
[MIT License](LICENSE).
