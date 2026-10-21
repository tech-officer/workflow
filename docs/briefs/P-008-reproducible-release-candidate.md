# P-008 — Reproducible workflow release candidate and migration evidence

Status: Built in PR7; CTO scoped approval45d3268 recorded, founder review/merge pending, 21 October 2026. Founder authorized Plan07 workflow rollout in TechOfficer and continuation today. Branch `brief/P-008`, isolated `/workspace/workflow-p008`, baseline main `cb4267da64b25ec4d996cbe308bfa5640f555b0b`. Existing executor `/root/b507_executor` implements; CTO independently reviews; founder merges. One substantial kit PR. No release publication or adopter write in this brief.

## Outcome

Produce a usable, deterministic workflow release candidate: render the kit with explicit inputs, export its managed-file provenance in TechOfficer B511's schema, verify actual installer/export parity, and give existing adopters a truthful migration/rollback path. Preserve Contract2.2 and project customizations. Do not label the candidate published or a historical install version known.

## Grounding

- `install.sh:98-114`: implicit dates and sequential sed substitutions. B511's renderer uses simultaneous literal replacement; nested placeholders can differ. Resolve explicitly and test actual behavior, not a duplicate stub.
- `install.sh:142-170`: combined AGENTS append and non-overwriting adapters. These are protected, not ordinary replaceable managed files.
- `install.sh:174-237`: generated boot prompts lack a standalone source artifact. Move to a reviewed template/shared mapping if needed, preserving established boot instructions and literal placeholder semantics.
- `install.sh:244-263`: existing write map includes owner state and customized plans; installation does not establish blanket future ownership.
- `INTEGRATION.md:183-192`: Contract2.2 readers accept both queue forms; producers remain unchanged. No2.3 migration.
- `STATUS.md`: P007 already merged in #6 at baseline; reconcile drift without deleting history or changing milestone totals.
- `DECISIONS.md:56`, `WORKFLOW.md:142-145`: founder's no-CI policy; retain manual quoted verification. Do not add Actions.
- TechOfficer #323 merged87e6d76; B511 offline planner12tests and five self-hosted CI checks pass. CTO post-merge approval recorded21October; hosted3 billing-blocked. Planner is at `/workspace/TechOfficer-b511/tools/workflow_upgrade/`; consume it for compatibility checks, do not fork/vend a second implementation.

## Scope and contract

Add a declarative bounded mapping of source templates to rendered destinations, with explicit ownership policy. Export standalone managed documentation only; list protected owner records, plans, adapters and combined AGENTS separately. Existing users retain their instructions and history. Default owner customizations remain manual; no heuristic section replacement. Merely seeing a file or a successful install does not prove a version.

Provide an offline candidate/export command, Python stdlib is acceptable for this optional command. Keep existing installer dependencies and invocation compatibility unless a measured need is recorded; avoid introducing Python as a new prerequisite for ordinary Bash installs. Require full immutable source commit, explicit bounded render inputs and observation/render date. Read Git object content for that commit rather than trusting modified working files. Candidate outputs go to a separate new/empty directory, refuse overlap, symlink/unsafe paths, nonregular sources, malformed inputs and overwrite. Never execute source scripts during export. Resolve nested placeholder semantics safely (e.g. explicit refusal of ambiguous values) and document any installer behavior change with regression proof. Do not silently substitute a newer checkout for the selected source.

Export candidate metadata, file hashes, declared Contract2.2, a `techofficer.workflow-rendered/v1` manifest accepted by B511, protected-file report, changelog and migration/check/rollback instructions. Source commit is resolved at generation, not hardcoded self-reference in a committed file. A release label is a candidate/declaration only; do not claim public release verification. Do not seed a fabricated baseline for existing adopters. Metadata distinguishes exported candidate, freshly installed subset proven by bytes, and merged/adopted version. If an installation contains skipped files it must not report a complete current version.

Exercise actual `install.sh` in disposable directories, not the B382 two-file stub. Fresh install parity compares managed rendered bytes/modes to exported manifest. Include explicit dates/timezone, Unicode/spaces/escaping, missing arguments, deterministic repeated output, ambiguous replacement tokens, generated boot prompts, existing custom records, adapters and AGENTS append-once behavior. Run ask unattended/skip reruns to prove no-clobber; do not use force on any real repo. Fix safety defects exposed by the new export/installer parity work within this scope and report them.

Test candidate with production B511 planner via explicit consumer-path argument. Missing consumer dependency is an explicit unavailable/failure, never silent success. Prove fresh disposable baseline → changed candidate → forward patch → reverse exact tree restoration. Record source commits and synthetic fixture identities honestly; test artifacts derived from changed source should be committed to a disposable fixture repository without relabelling its commit as upstream main. Run on actual TechOfficer snapshot read-only: report unknown historical baseline, protected/custom content, no changes. No production/adopter checkout is modified, no discovered project scripts executed without scope.

Document next adopter steps: confirm adoption/access, inspect unknown baselines manually, preview exact diff, run authorized checks, open PR, founder merge, record installed subset/version only with evidence, and rollback via reviewed revert. Include pinned/deferred choices. Do not copy TechOfficer-specific production secrets, engine settings or internal records into public templates. Proven general principles (attributed evidence, independent review, checkpoints, scoped diagnostics and explicit environment authority) can be added to migration guidance without claiming the kit implements the app's functionality.

## Out of scope

No GitHub release/tag, default-branch write, rollout to other adopters, auto-upgrade/merge, production permission/billing change, runner/laptop operation or deployment. No role/queue producer contract changes. Preserve no-CI ruling, historical decisions and milestone counts. TechOfficer Plan05/06 Windows/restart/pilot/phone/release gates remain open.

## Acceptance and verification

- [x] Actual export works from pinned Git source; B511 accepts its manifest and verifies hashes. Dirty source does not alter pinned output. Candidate state/release provenance truthful.
- [x] Actual installer/export byte+mode parity, deterministic inputs and boot prompts; no duplicated renderer test that merely agrees with itself.
- [x] Existing custom records/adapters/AGENTS preserved, protocol append once, reruns do not certify skipped files as current.
- [x] Traversal, links, nested roots, collisions, malformed/oversized input, unknown refs, nonempty output and ambiguous token cases refuse safely without outside writes.
- [x] Disposable candidate forward/reverse exact tree evidence; real TechOfficer read-only unknown-baseline report and production queue readers remain compatible. No2.3 producer migration.
- [x] Documentation includes candidate changelog, compatibility, migration, pins/defer, custom conflicts, rollback, publication/adopter steps and exact commands; no release or live acceptance claimed.
- [x] STATUS reconciled/claimed before first implementation commit; README/brief/handoff and dated activity updated. One PR, explicit CTO review, founder merge.

Run `bash -n install.sh`, new stdlib suite (document exact command), real installer disposable matrix, and explicit B511 integration command using `/workspace/TechOfficer-b511`. Run consumer readers `npx tsx tools/b434/queue-form-test.ts` and `npx tsx tools/b398/degrading-parse-test.ts` from that consumer checkout if contract fixtures changed. `git diff --check`. No full Next/browser regression needed for kit-only changes; don't weaken checks. Keep source/evidence changes batched and open a meaningful draft PR early. Report blockers immediately with smallest phone-friendly action.
