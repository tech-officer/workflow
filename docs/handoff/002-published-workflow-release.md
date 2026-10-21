# 002 — Published workflow release

21 October 2026. Read AGENTS/STATUS/FOUNDER and current PRs. P008/PR7 merged db6d10644fc25e1df476436eb91ec0062e790ef0. Workflow v1.1.0 is now public at that exact source; tag and release API verified. P009 records closeout only; founder merges it. Historical candidate docs describe their own pre-publication state and are not rewritten.

Eight real installer/export tests, syntax and production B511 integration passed. Source tree used for tests matches release tools/templates. Public release notes carry compatibility, migration and rollback. The custom asset-upload endpoint refused the upload; release uses GitHub standard source archives and does not claim custom checksums/assets.

Contract2.2 remains: readers accept both queue forms, producers keep front-matter queue. No2.3 migration. Existing adopter manifests pinned to db6d106 remain valid even if their original releaseLabel says unpublished; preserve immutable provenance. Per-project adoption and application readiness are distinct. Fleet outcomes belong to TechOfficer records, not private project details in this public kit.

No new CI; preserve no-CI ruling and locked master plan. No runtime deploy, permission/credential change or laptop/runner operation. Windows/Git Bash and TechOfficer phone/restart/installer/pilot/recovery gates remain separate.
