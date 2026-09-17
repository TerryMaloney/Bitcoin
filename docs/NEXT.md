# Next

## Immediate input needed

Capture the first PayPal Bitcoin purchase receipt and fill only the verified fields in `data/position.json`:

- total cash charged;
- transaction fee;
- executed BTC/USD price;
- timestamp;
- confirm BTC quantity.

A screenshot is fine; values can be entered manually.

## Phase 1 — calculator

Build a tiny deterministic calculator that accepts a BTC/USD price and returns:

- current position value;
- dollar gain/loss;
- percentage gain/loss;
- price required for the position to reach selected dollar values;
- estimated net proceeds after configurable selling friction.

No network calls in the core calculation module.

### Exit criteria

- deterministic unit tests pass;
- calculations reproduce hand-checked examples;
- unknown purchase data remains explicit rather than guessed.

## Phase 2 — market data

Add one primary public BTC/USD price source and one fallback source. Keep provider adapters separate from calculations.

### Exit criteria

- stale/missing price data fails closed;
- source and timestamp are included in every snapshot;
- mocked tests cover provider failure.

## Phase 3 — strategy rules

Define rules in data/config before alerts are enabled. Candidate rule types:

- informational drawdown checkpoints;
- informational profit checkpoints;
- original-stake-recovery checkpoint;
- optional time-based review points;
- explicit "do nothing" default between checkpoints.

The rules should generate recommendations for review, never place trades.

## Phase 4 — notifications

Only after Phases 1–3 are tested, add scheduled monitoring. GitHub Actions or ChatGPT automations can run the checks. Notifications should fire only on a new threshold crossing or a material condition change, not every polling interval.

## Later, not now

- dashboard/UI;
- screenshot ingestion;
- OCR;
- multiple assets;
- automatic brokerage/exchange integrations;
- machine-learning price prediction.
