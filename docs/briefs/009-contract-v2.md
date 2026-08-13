# BRIEF 009 — Contract v2: summary, milestones, lane-label convention

Authority: founder-signed "TechOfficer Product Definition v0.1" (2026-08-02;
rulings D1 + D3 + sign-off ruling §12.3 — milestones must be a LIST, rendered
on the project's detail page). Persisted to this file in the same PR that
delivers it, per the brief.

## GOAL

Extend Contract v1 → v2 with three ADDITIVE, OPTIONAL capabilities so the
TechOfficer console can render a project-first Deck:

1. `summary` — one line from the project's CTO session: current stage +
   what's next.
2. `milestones` — list of {name, done, total, state}, state ∈
   done|current|planned; exactly one entry `current`.
3. Lane-label convention `<vendor>-<n>` (e.g. kimi-1, claude-2) so tools can
   show "which AI" unambiguously.

## SCOPE — only these files may change

1. **INTEGRATION.md**
   - §1 annotated schema + field-reference table: add `summary`
     (string|null, optional) and `milestones` (list|null, optional; item keys
     EXACTLY name/done/total/state).
   - Reader guidance: absent keys are VALID (rule 4); readers take the first
     `current` milestone, else first `planned`, else render "—". More than one
     `current` = take the first, do not fail.
   - Field ownership: CTO session owns `summary` and `milestones` (alongside
     queue/project/phase).
   - Lane-label convention paragraph: `<vendor>-<n>`; legacy free-form labels
     tolerated by readers.
   - Changelog: add a v2 entry (dated today, authority = founder-signed
     product definition) — additive only; v1 keys, queue item schema (exactly
     id/title/role/weight), FOUNDER.md format, and tool write-rules UNCHANGED.
     Do not alter the v1.1/v1 entries.
2. **templates/STATUS.md** — front matter gains the two optional keys with
   brief comments and a 🧪 maturity note consistent with the file's existing
   labels; prose below the front matter untouched.
3. **prompts/1-cto-kickoff.md** — add 2-3 lines to the CTO duties (where
   queue/phase ownership already lives): refresh `summary` whenever queue or
   phase changes; keep `milestones` truthful at transitions; exactly one
   `current`. No restructuring.
4. **This repo's own STATUS.md** — dogfood v2: add `summary` + `milestones`
   with numbers derived from the repo's real history (M0 = briefs 000–007
   complete; M1 = brief 008 complete, P-001 still open; quote the Milestone
   section you derived them from). Claim Brief 009 the standard way first:
   queue entry + In progress row + branch, mirroring how Brief 008 was
   claimed.

## EXPLICITLY OUT

- WORKFLOW.md rules, the master plan (locked), GUIDE-1/2, QUICKSTART,
  install.sh, adapters — untouched.
- Queue item schema unchanged. FOUNDER.md format unchanged. Tools still NEVER
  write STATUS.md (D2 was rejected — no approval flow).
- No TechOfficer app code (later briefs, other repo).

## ACCEPTANCE CHECKLIST — PR body must tick every box with QUOTED evidence

1. PyYAML parse of the updated INTEGRATION.md example block AND
   templates/STATUS.md front matter — valid, new keys shown.
2. `git diff --stat` proving only the scoped files + docs/briefs/009 changed.
3. grep proof the queue item schema still has exactly id/title/role/weight;
   FOUNDER.md has zero diff.
4. Changelog shows v2 added, v1.1/v1 entries byte-untouched.
5. Own STATUS.md `milestones` numbers traceable to quoted repo history.
6. One branch `brief/009` off main, one PR, `updated` bumped on every
   STATUS.md write, never push to main — the founder merges.
