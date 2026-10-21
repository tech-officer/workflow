# Reproducible candidates and adopter migration

A candidate is not a published release or an installed version. Contract2.2 remains unchanged: readers accept both queue forms; producers still write front-matter queue entries. No2.3 producer migration is authorized here.

## Export without touching an adopter

The optional exporter requires Python3 and Git. Ordinary `bash install.sh` retains its existing Bash/Unix dependencies and does not require Python. Export reads only pinned Git objects, does not execute the chosen source, and refuses output inside/above the source root, links and nonempty directories.

Create an explicit JSON input file with exactly these fields:

```json
{"project":"Example","founder":"Founder","domain":"Software","devUrl":"https://example.invalid","weekday":"Monday","renderTime":"2026-10-21T12:34:56Z"}
```

```sh
python3 tools/release/export.py --source /absolute/workflow \
  --commit FULL_40_CHARACTER_COMMIT --inputs /absolute/inputs.json \
  --label candidate-review --output /absolute/separate-empty-directory
```

Full commits are required; labels are declarations only. Explicit UTC time fixes both date substitutions. Values are bounded single-line text; braces/controls are refused to avoid sequential-vs-literal replacement ambiguity. Project quote/backslash values are refused because the STATUS template embeds that field in YAML quotes. Unicode/spaces, ampersands, slashes and founder backslashes are tested. The matching installer option is `--render-time YYYY-MM-DDTHH:MM:SSZ`; omitted time uses current UTC. No GNU date parsing extension is required.

The fixed-schema `managed-files.tsv` describes source, destination, ownership and installation strategy. Exported `manifest.json` is `techofficer.workflow-rendered/v1`, accepted by the production TechOfficer B511 planner. Each included file binds source hash, rendered hash, regular0644 mode, exact substitutions and immutable source commit. `candidate.json` lists protected records and records mapping/manifest identity. `rendered/` contains only six standalone managed documents, not a complete scaffold. These may establish a freshly installed *subset* only after actual byte+mode verification at a recorded adopter commit.

STATUS, FOUNDER, DECISIONS, custom plans, adapters and combined AGENTS are protected: the export does not claim replacement authority. The installer still scaffolds them, skips existing differences unattended, appends the protocol only when absent, and never overwrites adapters. Fresh written documentation is0644; skipped existing permissions are preserved. Installation never certifies a complete release merely because some files were unchanged or skipped.

## Existing adopters and unknown history

1. Confirm the repository actually adopted the workflow and establish read/write authority separately. Visible repositories are not automatically adopters.
2. Preserve local records/instructions. A historical kit job/ref or matching filenames do not prove installed version. Without a proven manifest/baseline commit, use B511 unknown/manual assessment; never invent historical provenance.
3. Pin an explicit target manifest, or defer it. A target label is not automatic-latest policy. Preview actual hashes and local customizations/conflicts in a disposable clean checkout.
4. Review every protected/unknown/conflicting item. No heuristic combined-AGENTS replacement, no automatic recreation of locally deleted files. Keep project-specific checkpoints, attributed evidence, independent reviewer and explicit environment authority intact.
5. Verify exact baseline and patch digest; `git apply --check` before applying. Obtain separate authority to run the project's checks; the exporter/planner does not discover or execute them.
6. Open one reviewed upgrade PR. Founder merges. Record accepted source commit, exact managed subset, resulting adopter commit and check evidence only after that outcome is observed.
7. Retain forward/reverse patches and old manifest. Before merge reverse only against the exact resulting disposable tree. After merge open a reviewed revert PR; never reset a shared branch or erase later customizations.

## Publication and remaining gates

This PR does not create a tag/release, change an adopter, provision infrastructure or operate laptops/runners. After founder review/merge, select the release commit, verify artifacts/checks/license and author compatibility/changelog notes, then obtain publication and each adopter's authorization. Historical unknown baselines remain unknown. TechOfficer's Windows/restart/pilot/phone/release gates are separate live acceptance, not satisfied by these fixtures.

## Verification

```sh
bash -n install.sh
python3 -m unittest discover -s tests -v
python3 tests/consumer_integration.py --consumer /absolute/TechOfficer --output /absolute/new-report.json
```

Missing B511 dependency is an error, not a skipped pass. The integration runs actual installer/export/planner in disposable Git repositories and reads the consumer snapshot only. Exact source identities distinguish synthetic changed-source fixtures from upstream. No CI is added, preserving the founder's documented manual-verification policy. `Refused:`/exit2, unittest failures, or nonzero integration exit block acceptance.
