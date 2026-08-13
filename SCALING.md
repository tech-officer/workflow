# Scaling the workflow up and down

The full system was built for a funded project with a team and an investor.
Run it whole on a weekend side-project and the ceremony will kill the
project. Here's what to keep at each size.

## The irreducible core (every project, even solo weekend hacks)

1. **STATUS.md** — even alone, future-you is a different person. Milestone,
   in-progress, activity log. 5 lines is fine.
2. **Session handoffs** — the single highest-value ritual with AI sessions.
   Context windows fill; a handoff file turns session death from a disaster
   into a non-event.
3. **One branch per unit of work, never push main directly** — costs nothing,
   saves everything.
4. **Verification at the end of every task** — what changed, how to check,
   what failure looks like.

## Solo project (just you + AI coding sessions)

Core + plan 02 (a milestone list with exit checklists — even 5 items).
**Drop:** separate CTO/executor roles (one session plans AND codes — accept
that nobody reviews), formal briefs (STATUS "next up" lines suffice), the
CEO Project, reports.
**Watch for:** the moment you invite a collaborator or an investor asks
"how's progress?" — that's the trigger to add briefs and reports.

## Small team (you + 1–2 people/sessions) — the gollai configuration

Everything in the kit: role split (the no-code CTO rule starts mattering
exactly when more than one party writes code), briefs with checklists,
PR-review-vs-brief, handoffs, ops runbooks.
Add the CEO Project and bi-weekly reports when external stakeholders exist.

## Growing team (3+ executors, paying customers)

Everything above, plus what gollai staged for its M2:
- CI-enforced rules (conformance gates) instead of review-vigilance —
  contract law beats memory.
- Dev/prod split with promotion-not-merge deploys; runbooks for every op.
- Incident habit: any live issue gets a dated STATUS entry — cause, fix,
  and the follow-up proposal that prevents recurrence.
- Audit trails on anything staff can touch.

## Signs you're over-processed (subtract)

- Briefs take longer to write than the work they describe → shrink briefs
  to goal + checklist, keep grounding only for risky work.
- STATUS activity log entries nobody ever reads back → terser lines.
- The Ready queue is 6+ deep and rotting → stop briefing, start deciding.

## Signs you're under-processed (add)

- You explained the same context twice to two different sessions → handoffs
  are missing or stale.
- A PR surprised you ("I didn't ask for this") → briefs are missing or the
  no-brief-no-code rule slipped.
- You can't answer "what % done and based on what?" in one minute →
  milestone exit checklist is missing.
- Two people/sessions touched the same file in the same week without knowing
  → claims in STATUS aren't happening before code.
