# Research Stage 0

## Question

Can a simple, Bitcoin-specific regime strategy improve the return/drawdown tradeoff versus buy-and-hold and simple trend baselines after realistic costs, without relying on look-ahead or parameter mining?

## Frozen benchmark set

Before building an ensemble, implement and retain these independent baselines:

1. cash;
2. buy-and-hold BTC;
3. one simple long-horizon trend filter;
4. one multi-horizon momentum model;
5. one breakout model;
6. one volatility-scaled trend model.

Exact parameters must be declared before evaluating the final holdout period.

## Candidate signal families

Add families one at a time and ablate them:

### Price / trend

- multi-horizon returns;
- distance/slope relative to long-term trend;
- breakout state;
- drawdown from rolling high.

### Volatility

- realized volatility;
- upside semivolatility;
- downside semivolatility;
- volatility expansion/contraction;
- downside/upside asymmetry.

### Derivatives

- perpetual funding level and change;
- open interest level/change normalized to market size where possible;
- perpetual mark/index premium;
- futures basis when available;
- liquidation stress only if sourced reproducibly.

### On-chain

Start very small. Candidate metrics must have a plausible mechanism and reliable history. Examples to investigate include realized-cap/MVRV-family state and holder profitability measures when accessible from a reproducible provider.

Do not add dozens of correlated on-chain metrics merely because they improve a backtest.

## Regime output

Candidate models may produce a small state space such as:

- defensive;
- cautious;
- neutral;
- constructive trend;
- overheated/crowded.

The state maps to a target long-only BTC exposure. Exposure mapping is itself a parameter set and must be tested out-of-sample.

## Anti-overfitting protocol

- Keep a final untouched holdout period.
- Use expanding or rolling walk-forward evaluation.
- Generate a signal only from data available at that timestamp.
- Execute no earlier than the next eligible bar.
- Include fees/spread/slippage.
- Compare every added feature against an ablation without that feature.
- Track the number of parameter combinations attempted.
- Prefer wide stable parameter plateaus over one sharp optimum.
- Reject strategies whose advantage disappears under small parameter perturbations.
- Reject strategies whose advantage is dominated by one exceptional trade/period.
- Report failed experiments, not only winners.

## Selection hierarchy

A candidate is interesting only if it improves several dimensions together, for example:

- comparable or improved long-run return;
- materially lower maximum drawdown;
- improved downside-adjusted return;
- tolerable turnover;
- stable behavior across cycles and walk-forward windows.

Do not optimize one headline metric in isolation.

## Stage 0 deliverables

1. reproducible historical daily dataset;
2. provider/data dictionary;
3. benchmark backtest suite;
4. transaction-cost model;
5. walk-forward harness;
6. metric report generator;
7. first candidate trend + volatility regime model;
8. ablation report;
9. frozen paper-trading candidate or a documented no-go result.
