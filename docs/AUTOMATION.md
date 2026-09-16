# Automation Plan

## Principle

Automate observation, calculation, paper execution, evaluation, and reporting before automating any real-money action.

## GitHub Actions jobs

### 1. CI

Trigger: pull request / push.

Runs:

- unit tests;
- schema validation;
- deterministic backtest smoke tests;
- lint/type checks;
- no-network calculation tests.

No strategy change may merge while core tests fail.

### 2. Hourly data collection

Suggested schedule: minute 17 of each hour rather than the top of the hour.

Runs:

- fetch current/most recent spot data;
- fetch derivatives state;
- fetch available on-chain updates when their native cadence warrants it;
- normalize and validate;
- write/update the public research dataset or cache;
- never create a trading decision.

### 3. Daily decision cycle

Suggested schedule: shortly after 00:00 UTC once the completed UTC daily bar can be retrieved and validated.

Runs:

1. fetch/finalize prior day's inputs;
2. run quality gates;
3. compute features;
4. run every frozen baseline and candidate strategy;
5. evaluate final paper target exposure;
6. execute queued paper rebalance using the defined next-bar model;
7. append the paper ledger;
8. create a daily snapshot and comparison report;
9. emit a notification only for a meaningful state change or failure.

### 4. Weekly research report

Runs once per week and summarizes:

- paper strategy vs buy-and-hold;
- drawdown and turnover;
- current regime and why;
- data-source health;
- threshold/state changes during the week;
- whether any strategy parameter changed (normally none).

## Notifications

Avoid "BTC is still bullish" spam. Trigger only on events such as:

- regime changes;
- target exposure changes;
- paper order executed;
- new drawdown threshold;
- provider/data-quality failure;
- unusually large daily move;
- strategy/benchmark performance divergence crossing a configured threshold.

Initial delivery can use GitHub Issues or workflow summaries. ChatGPT notifications can be layered on separately after the core paper system is reliable.

## State persistence

Use append-only or versioned text formats where possible:

- normalized daily data: CSV/JSONL;
- paper ledger: CSV/JSONL;
- daily snapshots: JSON/JSONL;
- configs: YAML committed to Git;
- generated reports: Markdown.

Do not use workflow artifacts as the only long-term paper-trading ledger because artifact retention is finite.

Do not commit real account credentials, API secrets, exact private balances, or private receipts to a public repository.

## Scheduler limitations

GitHub Actions is acceptable for hourly/daily research and paper trading, not precise high-frequency execution. Scheduled jobs can be delayed. Therefore strategy logic must not depend on second-level or minute-perfect execution.

If the strategy eventually requires reliable sub-hour execution, move the same containerized application to a small always-on worker while retaining GitHub for code, configuration, CI, and audit history.

## Data-provider resilience

Each provider adapter must support:

- timeout;
- retry with bounded backoff;
- rate-limit handling;
- source timestamp validation;
- explicit stale status;
- fallback where appropriate.

Never silently replace missing values with zero.

## Human gate

Even after paper graduation, version 0 live operation remains:

```text
SYSTEM -> RECOMMENDATION -> HUMAN REVIEW -> MANUAL TRADE
```

Only after a separately reviewed live-execution design should an exchange API be considered. PayPal scraping or browser automation is out of scope.
