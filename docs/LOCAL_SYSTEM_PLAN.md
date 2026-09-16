# Local Bitcoin system: implementation and handoff
Date: 2026-09-16
Status: proposed implementation; no trading engine, local installation, or profitability evidence yet.

## Current objective and precedence
Build an automated BTC/USD spot research and paper-trading system on the user's own computer, with an eventual separately enabled small live pilot. This document supersedes the calculator-first ordering in DESIGN.md and NEXT.md. SYSTEM_ARCHITECTURE.md and RESEARCH_STAGE_0.md remain the research foundation. Live execution is a future implementation stage, not current permission to submit orders. Existing holdings stay untouched during research and paper testing.

## Access and hardware
The current chat's shell is a hosted Linux workspace, not the user's desktop. GitHub authorization does not connect a Windows terminal. Do not mistake hosted CPU/RAM for local hardware.
Run scripts/windows-preflight.ps1 in ordinary Windows PowerShell, or paste its contents. It only reads selected OS, CPU, RAM, disk, and command-availability fields and prints JSON. It does not install software, inspect secrets, change settings, or upload results.
User supplies output plus whether PC can remain powered on and connected continuously.
Use a local Codex session opened on the repository folder for local file/terminal work. This is a separate execution context; this chat does not automatically gain remote control. Use this document as the handoff.
Official Windows documentation: https://learn.chatgpt.com/docs/windows/windows-sandbox
Official desktop setup: https://learn.chatgpt.com/docs/app

## Provisional stack, subject to preflight
- Native Windows Python virtual environment and Git; select and pin a supported Python version when installing.
- Deterministic Python strategy/risk/accounting modules, shared by historical and paper runners.
- SQLite transactions and unique event/order keys for operational state; immutable raw market files and Parquet for historical research.
- CSV/JSON report and tax-record exports. Private state outside the public checkout.
- Windows Task Scheduler for a serialized periodic paper runner, restart recovery and catch-up. Independent heartbeat monitor required before live use.
- Begin with hourly data and one daily decision; do not start with high-frequency execution.
- No GPU, local LLM, paid AI API, Docker, WSL, subscription signals or VPS required for the initial system.
- Design target, not confirmed hardware requirement: an ordinary supported 64-bit PC with roughly 8 GB RAM and 10 GB available space should be ample for daily/hourly BTC-only research. Measure actual use.
- A sleeping/offline PC cannot monitor markets. Record gaps, refuse stale fills, and reconcile on resumption. Never fabricate trades during an outage.
- GitHub holds code and CI, not live balances, receipts, secrets, or the sole ledger.
- Before unattended live use, implement an appropriate Windows service or supervised worker, backup/restore, update handling, clock checks and an external missed-heartbeat alert. Do not disable OS security updates.

## Venue selection before implementation of private APIs
Shortlist Coinbase Advanced and Kraken spot API. Neither has been selected or confirmed for the user's account.
Compare account eligibility/residency, official API terms, actual BTC/USD maker/taker tiers, min order notional/quantity, precision, deposit minimums, transfer charges, rate limits and permission scopes.
Coinbase's exact Advanced fee schedule requires sign-in:
https://help.coinbase.com/en/coinbase/trading-and-funding/advanced-trade/advanced-trade-fees
Kraken's public spot schedule observed today lists entry tier 0.40% maker / 0.80% taker; recheck the user's account and regional applicability:
https://www.kraken.com/features/fee-schedule
Do not assume a limit order is maker, or that touching a limit price guarantees a fill.
Paper model defaults to observed taker fees plus spread and adverse slippage. A maker model requires queue/fill conservatism, partial fills, expiry and an explicit cancellation policy.
Private API integration begins read-only. Kraken separates query, order modification, cancellation and withdrawal permissions:
https://support.kraken.com/articles/360000919966-how-to-create-an-api-key

External BTC transfer minimum published by PayPal is 0.001 BTC as checked today. Account restrictions and the confirmation screen remain authoritative. Review source-account records, fees and destination network/minimums before any transfer. Do not recommend topping up just to satisfy the minimum.
https://www.paypal.com/us/cshelp/article/how-do-i-transfer-my-crypto-help822
A future transfer is a manual user step after venue selection; never put an address or private balance in this public repository.

## Build sequence and acceptance
1. Local preflight and development setup. Confirm local project path and OS; install only missing dependencies. Inspect existing work before changing branches.
2. Data and accounting. Public BTC/USD ingestion, UTC closed-bar validation, immutable raw records, provenance and reproducible import. SQLite transaction recovery, fee/rounding and accounting invariants. No keys required.
3. Baselines and historical engine. Cash, buy-and-hold, fixed BTC/cash allocation, slow trend, breakout and volatility-scaled trend. Historical and live paths share identical feature calculations.
4. Frozen research protocol. Select finite parameter sets on development data, chronological walk-forward windows and a final untouched period. Log every trial. Report unstable or failed candidates.
5. Venue-specific live paper runner. Simulate both normalized and intended small capital, including initial BTC/cash allocation, dust, min sizes, unavailable cash, fees and partial fills. Freeze strategy versions; a modified strategy gets a new forward record.
6. Reliability trial. Exercise restart, offline gaps, malformed/stale data, duplicate invocation, full disk, unknown order status and backup restoration. No trading permission.
7. Read-only account reconciliation. User completes KYC/2FA and enters read-only credentials locally. Reconcile balances and import original cost basis privately.
8. Separate live gateway and micro-live review. Only after evidence gates and user activation. No automatic promotion from a profitable paper record.

## Research standard
Primary proposed goal: improve net return relative to a predeclared simple benchmark under an agreed drawdown budget. Also report buy-and-hold and a risk-comparable fixed allocation so sitting in cash is not misrepresented as trading skill. User's acceptable dollar loss and intended capital are still unknown; do not invent them.
Before final holdout, freeze benchmark, min acceptable benefit, max drawdown, turnover ceiling and parameter budget. Report uncertainty with time-dependent resampling where appropriate, and disclose multiple testing.
Test several market regimes, 2x execution-friction stress, timing delays and nearby parameters. No future-known regime labels as inputs.
Include annualized and absolute-dollar net results, equity drawdowns, capital tied up, BTC-equivalent value, and taxes as separate explicit scenarios. Do not confuse realized gains with total portfolio profit.
Execution time must follow decision time. A signal calculated at 00:20 UTC must never fill at that day's 00:00 open. Daily strategy decisions may use subsequent hourly quotes/bars with a conservatively defined delay.
Prefer a few interpretable hypotheses first; derivatives/on-chain/ML features must add independently validated value. Preserve publication/retrieval timestamps to prevent revised data leaking future information.
A 90-day paper checkpoint is operational evidence, not statistical proof or automatic eligibility. Insufficient independent trades or narrow market conditions require longer observation. No edge found is a valid completion result.

## Live gate design
Paper runtime contains no trade-capable key. A boolean paper/live switch alone is insufficient.
Separate live process and OS identity where practicable; restrict credential storage using OS facilities outside the repo and logs. Development sessions should not read trading secrets.
User must enable a reviewed strategy version, account, BTC/USD product, capital ceiling, maximum order and daily/total loss-stop thresholds. A code/config change invalidates prior activation until reviewed.
Initially only a small isolated funded allocation; disabling withdrawals alone does not cap losses from bad trades.
Before each order: verify freshness, venue trading status, position/open-order reconciliation, cash, min sizes, max exposure and unique client order ID.
After timeout: query by order ID before retrying. Unknown state blocks new orders. One active runner per account.
Handle open orders separately from new-entry bans. Define cancellation and recovery policies; no forced market liquidation solely because a data feed failed.
Stop triggers are actions, not guaranteed loss limits: gaps, outages and failed orders can exceed them.
Never enable withdrawal, transfer or borrowing permission for the bot. Where exchange scopes cannot restrict product/capital sufficiently, enforce dedicated funding and independent gateway constraints.
No self-editing production strategy or autonomous capital increases.

## Legal and accounting gate
Own-account spot investing only. FinCEN distinguishes own-account investment from providing transmission/exchange services to others; this does not settle all state or business-model questions:
https://www.fincen.gov/resources/statutes-regulations/administrative-rulings/application-fincens-regulations-virtual
Before live use confirm residency/account eligibility, platform/API terms and applicable state requirements. No leverage/derivatives execution.
Keep original acquisition basis/date across transfers; record every fill, fee and disposal. Selling for USD or exchanging crypto can trigger capital gains/loss reporting. Compare after-tax scenarios explicitly:
https://www.irs.gov/filing/digital-assets

## Manual user steps
Now: send preflight output, rough proposed bankroll and whether PC can remain on. Open/install official desktop local Codex workflow and select the repository folder if local agent access is desired.
Next: verify selected exchange account, KYC and 2FA; inspect actual fees and minimums. No funding necessary for paper testing.
Later: create a read-only API key locally; do not paste secrets into chat. At micro-live gate only, create a distinct order-capable/no-withdrawal key and manually fund the approved small allocation.
Agent work: source code, research harness, paper engine, reports, tests, scheduler scripts and operating instructions. No claim of installation until verified on the real PC.
