# Design

## Goal

Create a small, auditable decision-support system for one manually tracked Bitcoin position.

## Architecture

```text
manual position update
        |
        v
 data/position.json
        |
        +-------------------+
        |                   |
        v                   v
 independent price      strategy rules
     source                 |
        |                   |
        +--------+----------+
                 v
          calculation engine
                 |
                 v
          decision snapshot
                 |
                 v
        notification / report
```

## Core principle

Separate facts, calculations, and decisions.

- **Facts:** BTC quantity, verified purchase details, current market price.
- **Calculations:** position value, percentage gain/loss, break-even estimate after known fees.
- **Rules:** explicit thresholds decided in advance.
- **Output:** alerts and explanations only.

## Data source rules

1. The BTC quantity comes from the user or a verified screenshot/receipt.
2. Market price comes from an independent public market-data source.
3. PayPal's displayed value is useful for reconciliation, not assumed to be a programmatic feed.
4. Unknown fields remain `null`; do not invent missing transaction details.

## v0 implementation target

A tiny Python project is sufficient:

- `src/price.py` — fetch BTC/USD price.
- `src/position.py` — load and validate position data.
- `src/calc.py` — compute value, gain/loss, thresholds.
- `src/rules.py` — evaluate strategy rules.
- `src/report.py` — human-readable output.
- `tests/` — deterministic tests with mocked prices.

GitHub Actions can later run scheduled checks, but notifications should be added only after the calculation and rule layers are tested locally and in CI.

## Non-goals

- high-frequency trading;
- technical-analysis signal generation as a substitute for a predefined plan;
- autonomous execution;
- storing passwords, API secrets, PayPal cookies, or private account exports in Git.
