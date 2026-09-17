# System Architecture

## Objective

Build a Bitcoin-specific research and paper-trading system that can run automatically, remain auditable, and fail closed. Real funds remain untouched until a separate live-trading gate is deliberately approved.

## Operating modes

1. **Research** — historical data, feature construction, backtests, walk-forward tests.
2. **Paper** — live market data, simulated orders, simulated cash/BTC ledger.
3. **Shadow live** — compare the paper system with a real BTC holding without changing the real holding.
4. **Micro-live (future, manual approval only)** — optionally test a very small real allocation after explicit graduation criteria are met.

No mode is allowed to jump directly from research to autonomous live execution.

## Pipeline

```text
PUBLIC MARKET DATA
  |-- spot OHLCV
  |-- derivatives / funding / OI
  |-- on-chain metrics
  v
NORMALIZATION + QUALITY GATES
  |-- timestamps aligned to UTC
  |-- duplicate/missing/stale checks
  |-- raw-source provenance
  v
FEATURE ENGINE
  |-- trend / momentum
  |-- breakout
  |-- realized upside/downside volatility
  |-- funding / basis / open-interest state
  |-- selected on-chain state
  v
STRATEGY LAYER
  |-- baseline strategies
  |-- candidate regime models
  |-- ensemble / ablations
  v
RISK + SIZING
  |-- spot only
  |-- 0%-100% BTC exposure
  |-- no leverage
  |-- turnover/cooldown controls
  v
PAPER BROKER
  |-- next-bar execution
  |-- fees + spread + slippage
  |-- append-only ledger
  v
EVALUATION
  |-- return
  |-- drawdown
  |-- Sharpe / Sortino
  |-- turnover
  |-- benchmark comparison
  |-- regime-by-regime results
  v
REPORT + ALERTS
```

## Initial data providers

Use adapters so providers can be replaced without touching strategy code.

- **Spot BTC/USD:** Coinbase public Exchange/market endpoints are a suitable first source for daily/hourly OHLCV.
- **Derivatives:** Deribit public BTC perpetual endpoints expose funding and open interest.
- **On-chain:** Coin Metrics Community API can provide a no-key starting point for metrics that are available in the community catalog.

Every observation must include provider, instrument, source timestamp, retrieval timestamp, and freshness status.

## Decision cadence

Start deliberately slow:

- collect spot and derivatives data hourly;
- calculate the official strategy state once per UTC day after the completed daily bar;
- generate a target BTC exposure for the next period;
- paper orders execute only on the next available bar, never on the bar used to generate the signal.

This prevents look-ahead execution and avoids designing an accidental high-frequency strategy.

## Source tree target

```text
src/bitcoin_lab/
  data/
    providers/
    normalize.py
    quality.py
  features/
    trend.py
    volatility.py
    derivatives.py
    onchain.py
  strategies/
    baselines.py
    regimes.py
    ensemble.py
  risk/
    sizing.py
    constraints.py
  backtest/
    engine.py
    metrics.py
    walk_forward.py
  paper/
    broker.py
    ledger.py
    state.py
  reports/
    snapshot.py
    compare.py
  cli.py

config/
  research.yaml
  paper.yaml

data/
  public/
  private/        # gitignored
  paper/

tests/
```

## Fail-closed rules

No signal or paper order is generated when:

- required data is stale;
- timestamps disagree beyond tolerance;
- a provider response is malformed;
- a feature requires unavailable history;
- a strategy produces NaN/invalid exposure;
- the proposed exposure violates configured risk limits.

The default state is **HOLD CURRENT PAPER EXPOSURE / NO NEW ORDER**, with an explicit data-quality warning.

## Reproducibility

Each decision snapshot records:

- code commit SHA;
- config version/hash;
- market-data timestamps;
- feature values;
- strategy outputs;
- final target exposure;
- simulated execution assumptions.

A later run should be able to explain exactly why an earlier paper trade occurred.
