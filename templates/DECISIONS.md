_Maturity: 🧪 included but unproven_

# DECISIONS.md — the decision ledger ({PROJECT})

Append-only, newest entry on top. Never edit or delete an entry — reversing a
decision is a new entry that cites the old one.

**Why, not what.** This ledger records rejected options, accepted risks, and
cross-cutting rulings — the reasoning a successor session cannot reconstruct
from the code. Per-decision detail still lives in the plan it affects; this
file is the index of *why*.

Entry format (one H2 per decision):

    ## YYYY-MM-DD — short title
    Decision: <what was decided, one line>
    Rejected: <option — why rejected>   (one line per rejected option)
    Accepted risk: <risk consciously taken>   (optional)
    Who: {FOUNDER} (+CTO session)

Two example entries:

## 2026-01-14 — Postgres over DynamoDB for the MVP
Decision: Postgres for all MVP persistence.
Rejected: DynamoDB — the data model is relational and the team knows SQL;
access-pattern-first design is premature at MVP scale.
Who: {FOUNDER} (+CTO session)

## 2026-02-03 — M1 ships without usage metering
Decision: M1 ships with flat-rate billing only; metering moves to M2.
Rejected: per-seat metering in M1 — two weeks of work, and no M1 customer
asked for it.
Accepted risk: early heavy users are unprofitable until M2 metering lands.
Who: {FOUNDER} (+CTO session)
