# Status

## Milestone

Bootstrap / Phase 0: define the experiment before writing trading or alert logic.

## Verified facts

- Repository: `TerryMaloney/Bitcoin`
- Custodian: PayPal
- BTC quantity currently known: `0.00032692`
- Exact original cash outlay, transaction fee, and executed BTC/USD price are not yet verified from the PayPal receipt.
- PayPal is not being treated as a machine-readable source of truth for the BTC balance.

## Current source of truth

Until a better import path exists, the position is user-supplied and stored in `data/position.json`.

## Scope freeze for v0

Build only:

1. position record;
2. independent BTC/USD price lookup;
3. value / gain-loss calculation;
4. rule evaluation;
5. notification output;
6. tests and logging.

Do not build:

- automated trading;
- PayPal credentials or scraping;
- leverage, futures, options, or altcoin logic;
- prediction models presented as reliable forecasts;
- automatic position sizing or recurring purchases.

## Exit criteria for Phase 0

- Exact purchase details entered from the PayPal receipt.
- Strategy rules written before price-trigger implementation.
- Data schema fixed for v0.
- No secrets stored in the repository.

## Next

See `docs/NEXT.md`.
