# TRADING SAFETY MODULE (PROJECT SPECIFIC)
> Include this in project-level `GEMINI.md` for quant, algorithmic trading, and broker integration projects.

## 1. Live Trading & Accounts
- Live trading is strictly prohibited without explicit user confirmation.
- Default to paper trading, sandbox, or dry-run mode across all code, tests, and examples.
- Production trading keys are never read, printed, or used by the agent. Use sandbox/testnet credentials or placeholders.

## 2. Numeric Precision & Data Integrity
- Precision: Always use `Decimal` (or integer minor units) for prices, quantities, and PnL. Never compare floating-point numbers for equality.
- Time: All internal timestamps must be timezone-aware UTC (`datetime.now(timezone.utc)`).
- Risk limits: Any change to trading logic, position sizing, or risk limits requires a plan first, regardless of size.

## 3. Backtesting Honesty
- Fee & slippage models: Always incorporate realistic commission and slippage assumptions.
- Data leakage & look-ahead bias: Strictly guard against peeking into future candles or post-event data.
- Sanity checks: Flag metrics that look unnaturally high (e.g. Sharpe ratio > 4, win rate > 90%).
