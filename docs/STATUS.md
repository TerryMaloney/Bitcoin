# Status

## Milestone

Bootstrap / Research Stage 0: define the research, backtest, paper-trading, and automation architecture before writing strategy code.

## Current operating rule

Real Bitcoin remains untouched. The repository is for public research code and paper-trading state only. Real account balances, receipts, credentials, and personally identifying financial details stay outside this public repository.

## Scope freeze for v0

Build, in order:

1. reproducible BTC market-data ingestion;
2. normalized daily research dataset;
3. deterministic feature library;
4. simple frozen baseline strategies;
5. backtest + walk-forward harness;
6. realistic transaction-cost model;
7. paper broker and append-only ledger;
8. automatic daily decision cycle;
9. reports and event-based notifications;
10. shadow comparison against buy-and-hold.

## Hard exclusions

- no autonomous real-money trading;
- no PayPal credentials or scraping;
- no leverage or shorting;
- no derivatives execution;
- no altcoin expansion in v0;
- no model presented as reliably predicting Bitcoin's future price;
- no strategy promoted from backtest directly to live money.

## Graduation path

`research -> walk-forward -> live paper -> shadow live -> optional micro-live/manual review`

Each transition requires explicit exit criteria. A failed strategy is a valid result and should remain documented.

## New design documents

- `docs/SYSTEM_ARCHITECTURE.md`
- `docs/RESEARCH_STAGE_0.md`
- `docs/PAPER_TRADING.md`
- `docs/AUTOMATION.md`

## Immediate next build

Implement the Stage 0 dataset, deterministic baselines, and backtest harness before enabling scheduled paper decisions.
