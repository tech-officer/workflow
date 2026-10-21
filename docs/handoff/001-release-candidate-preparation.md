# 001 — Reproducible candidate preparation

Read AGENTS → STATUS → FOUNDER → this handoff → P008 brief and report. Founder merges; CTO plans/reviews, executor implements. The workflow repository uses P-NNN; product TechOfficer uses B-NNN. No CI was added: preserve the documented manual-verification decision.

P007 merged in workflow PR6 atcb4267d; stale board entry was moved to dated history. P008 continues TechOfficer PR323 (merged87e6d76; CTO postmerge approval21October https://github.com/tech-officer/TechOfficer/pull/323#pullrequestreview-5598976668). Product five selfhosted checks passed; hosted3 billing-blocked. Product checkout/STATUS was not edited during this kit work.

Workflow PR7 implements offline candidate export, shared declarative map and boot template, optional deterministic installer time, protected-record ownership, destination-link preflight and exact documentation modes. Final feature45d3268; final docs follow. Eight actual installer/export tests PASS, production B511 integration PASS with exact forward/reverse tree, reader36+40PASS, syntax/diffPASS. CTO independently approved scoped implementation in docs/reports/P-008/cto-review.md. See report for exact source/test attribution, initial failures corrected and retained actual/synthetic artifacts.

Six standalone managed docs are exported; nine owner/plan/adapters/combined instructions protected. Candidate metadata is not a release or installed version. Actual TechOfficer unknown-baseline scan emits empty patches and preserves records. The explicitly supplied consumer worktree wasfda6213, distinct from merged main87e6d76. No fabricated historical manifest or heuristic AGENTS replacement.

Next: founder review/merge, then separately authorized publication and per-adopter preview/check/PR/merge/version recording. Do not publish a tag/release, apply to adopters, run their discovered scripts, alter billing/permissions, deploy or operate laptops/runners without authority. Keep pinned/deferred targets and reviewed revert path. Contract2.2 readers accept both queue forms; producers remain front-matter. No2.3 claim.

All TechOfficer Plan05/06 live gates remain open, especially Windows/Git Bash runtime, deferred restart/signin, pilot target/cost/policy, phone/slow/offline and release. Tests ran on Linux with disposable directories; no live rollout is certified.
