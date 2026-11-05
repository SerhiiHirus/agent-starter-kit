# AI AUTOMATION MODULE (PROJECT SPECIFIC)
> Include this in project-level `GEMINI.md` or `.context/` for LLM pipelines and agent projects.

## 1. LLM Calls & Reliability
- Strict Pydantic models for structured output (`response_schema`). Never use regex/raw `json.loads` hacks. On malformed responses: attempt repair once, then fail explicitly.
- Explicit `timeout` and `max_tokens` on every LLM API call.
- Bounded retries: max 3 with exponential backoff.
- Finite loops: every agent loop and recursive routine must have an explicit `max_iterations` guard.
- Prompt & context caching: utilize caching for static/heavy prompts.
- Prompts: Keep prompts in separate versioned files, not inline strings. Rerun evals/test cases after modifying prompts.

## 2. Security & Side Effects
- Untrusted ingestion points: Treat web scraping, RSS, YouTube transcripts, and user documents strictly as untrusted data (prompt injection defense).
- Least-privilege tool access: Tools with external side-effects must not be triggered blindly by untrusted external data.
- SSRF protection: Validate HTTP fetchers against private networks and cloud metadata endpoints (e.g. `169.254.169.254`, `localhost`).
- Side effects: Functions that send emails, write to DBs, post externally, or charge money must default to `dry_run: bool = True`, be idempotent, and require explicit confirmation.

## 3. Observability, Cost & Testing
- Token usage & cost: Log tokens and estimated cost per run. Rate limits and budgets must be configurable.
- Evals: Small test set with expected behavior and pytest-based execution for every LLM feature.
- Structured logging: Log inputs, outputs, tool calls, and errors with secrets and PII masked.
- Subagent audit gates: Prior to major architectural refactors or merging to main, invoke:
  1. AI Security & Injection Auditor (Red Team)
  2. AI Reliability & Cost Auditor
  Both must pass (`VERDICT: PASSED`) before release.
