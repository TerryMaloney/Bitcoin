# Bitcoin

A small, transparent Bitcoin tracking and decision-support project.

## Purpose

This repository is the source of truth for a deliberately small Bitcoin experiment. It is intended to:

- record the actual BTC quantity held;
- record verified purchase/sale details when available;
- fetch independent BTC/USD market prices;
- calculate current position value and gain/loss;
- evaluate pre-defined decision rules;
- support notifications without automatically trading.

## Safety boundary

This project does **not** place trades, hold credentials, connect to PayPal, or make automatic buy/sell decisions. Any transaction remains a manual user action.

## Current known holding

- Asset: Bitcoin (BTC)
- Custodian: PayPal
- Quantity currently known: `0.00032692 BTC`
- Exact cash outlay / fee / executed price: pending verification from the PayPal receipt

## Project state

Bootstrap in progress. See `docs/STATUS.md` once the initial setup branch is merged.
