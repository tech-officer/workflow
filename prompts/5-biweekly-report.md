_Maturity: 🧪 included but unproven_

# Prompt 5 — Bi-weekly progress report request

> Send to the CTO session every second {weekday}. Takes it ~30 minutes.
> Requirements live in docs/reports/README.md (from templates/).

```
It's report day. Produce the bi-weekly progress report per
docs/reports/README.md:

- Audience: {who — investor / customer / team}, in {language(s); add a
  language toggle if audiences differ}.
- Single self-contained HTML file ready to send: <meta charset="utf-8">
  first line, inline CSS only, light+dark, readable on a phone.
- Progress % derived ONLY from the milestone exit checklist, and show the
  checklist itself (✓/●/○). Timeline with honest dates — slips visible.
  "What changed" in user terms. Ask-list with urgency tags, unanswered
  asks carried forward.
- Facts only: an item is done when its verification ran. No invented
  numbers, no smoothing.

Save it to docs/reports/{YYYY-MM-DD}-progress.html, commit it on your
branch (include it in your next docs PR), and send me the file for
distribution.
```

## Cadence tips

- Same structure every time — stakeholders learn to read it in seconds and
  trust it precisely because it doesn't restyle itself when news is bad.
- If a stakeholder meeting falls off-cycle, run the prompt early rather
  than presenting a stale report; the date in the filename keeps history
  honest.
- Keep every past report in docs/reports/ — the series itself becomes
  evidence of velocity ("here are 6 reports, watch the meter move").
