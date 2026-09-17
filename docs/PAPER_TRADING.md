# Paper Trading Specification

## Purpose

The paper trader is the graduation bridge between historical research and any real-money experiment. It must consume only information that would have been available at the time and simulate execution conservatively.

## Accounts

Run at least two virtual accounts from the same starting capital:

- `buy_hold`: buys BTC at the paper start and holds it.
- `strategy`: follows the current candidate strategy's target exposure.

A third `cash` benchmark can remain 100% USD.

The paper starting capital is arbitrary and normalized for comparison; it is not intended to match the user's real balance.

## Allowed positions

Version 0 is long-only spot:

- minimum exposure: `0.00`
- maximum exposure: `1.00`
- suggested discrete targets: `0.00, 0.25, 0.50, 0.75, 1.00`
- no shorting;
- no leverage;
- no borrowing;
- no derivatives execution.

Derivatives data may be used as a signal only.

## Timing model

1. Complete UTC daily bar closes.
2. Data-quality checks run.
3. Features are computed from data through that close only.
4. Strategy emits a target exposure.
5. Any rebalance is queued.
6. The simulated order executes on the **next** eligible bar using a configured execution-price rule.

This rule is mandatory to prevent same-bar look-ahead bias.

## Execution model

Paper execution must include:

- configurable transaction fee;
- configurable bid/ask spread;
- configurable adverse slippage;
- minimum trade threshold;
- optional cooldown between reallocations.

Use conservative assumptions. Maintain separate profiles so results can be tested under both a low-cost venue and a higher-friction retail venue.

Do not tune fees after seeing the result.

## Ledger

Every simulated order appends a row to an immutable text ledger containing at least:

- decision timestamp;
- execution timestamp;
- strategy/config version;
- signal/regime;
- prior target exposure;
- new target exposure;
- reference BTC price;
- simulated execution price;
- BTC quantity changed;
- gross notional;
- simulated fee;
- simulated spread/slippage cost;
- resulting USD cash;
- resulting BTC quantity;
- resulting equity;
- reason code.

Never silently edit old rows to make a strategy look better. Corrections are new rows with explicit correction reason codes.

## Daily snapshot

After every decision cycle, persist a snapshot for all benchmarks:

```json
{
  "timestamp": "...",
  "btc_usd": 0,
  "regime": "...",
  "target_exposure": 0.0,
  "paper_equity_usd": 0.0,
  "buy_hold_equity_usd": 0.0,
  "cash_equity_usd": 0.0,
  "drawdown": 0.0,
  "turnover_ytd": 0.0,
  "data_quality": "ok"
}
```

## Metrics

Evaluate at minimum:

- total and annualized return;
- maximum drawdown;
- volatility;
- Sharpe ratio;
- Sortino ratio;
- downside deviation;
- time in market;
- turnover;
- number of reallocations;
- average win/loss after costs;
- worst rolling 7/30/90-day result;
- performance by bull, bear, and sideways regimes;
- excess return versus buy-and-hold;
- drawdown reduction versus buy-and-hold.

## Graduation gate

A strategy is not considered ready for a real-money experiment because of one good backtest.

Before even discussing micro-live use, require:

1. walk-forward/out-of-sample historical evidence;
2. results that survive conservative costs;
3. no single short period responsible for nearly all excess return;
4. stable behavior across materially different BTC regimes;
5. a live paper record long enough to encounter meaningful market movement;
6. no unresolved data-quality or accounting defects;
7. documented comparison against buy-and-hold and simple trend baselines;
8. explicit human approval.

The existing real BTC holding remains outside the paper ledger and untouched during this phase.
