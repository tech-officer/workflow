_Maturity: 🧪 included but unproven_

# Bi-weekly progress reports — {PROJECT}

> Every second {WEEKDAY}, the CTO session produces a visual report here as
> `YYYY-MM-DD-progress.html` (self-contained single file: inline CSS,
> `<meta charset="utf-8">` first line, light+dark, phone-friendly; bilingual
> toggle if stakeholders read different languages). ~30 min of session work.
> Request it with the kit's `prompts/5-biweekly-report.md`.

## Required sections

1. **Lead** — 3 sentences: where we are, ahead/behind plan, next big visible
   thing.
2. **Progress meter** — % derived ONLY from the milestone exit checklist
   (ticked / total), with the checklist itself shown: ✓ done / ● in progress
   / ○ waiting. A % without its checklist invites the question "based on
   what?" — never ship one.
3. **Timeline** — the weeks to milestone-done; done nodes green, current
   highlighted; dates honest (slips shown, not hidden).
4. **What changed since last report** — shipped items in user terms, not
   commit messages.
5. **Ask list** — what we need from stakeholders, each with why + when,
   urgency-tagged. Carry unanswered asks forward visibly.

## Rules

- Facts only in the done column — an item is "done" when its verification
  ran, not when the PR merged.
- Honest empty states: no data yet = say so, never a made-up number.
- Same template every time — stakeholders learn to read it in seconds.
