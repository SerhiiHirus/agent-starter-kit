# Agent Starter Kit

> Production-grade operational constitution, zero-leak security gateway, and interactive onboarding for AI coding assistants.  
> Compatible with Google Antigravity, Cursor, Claude Code, Windsurf, Cline, and custom LLM workflows.

---

## Quick Start (2-Minute Setup)

You do not need to manually configure rules or write prompt guidelines from scratch:

1. Click **[Use this template]** (or fork this repository) and clone it locally.
2. Open the project in **Google Antigravity** (or your preferred AI IDE).
3. Send a single prompt in chat:
   ```text
   Set up my configuration
   ```
   *(or `/onboard`, or in Ukrainian: `Налаштуй під мене`)*
4. **The agent conducts a brief interactive interview:**
   - Detects and prompts for your tech stack (Frontend, Backend, AI/Python, Data Science, Mobile);
   - Configures preferred communication language (English, Ukrainian, etc.);
   - Confirms domain audit modules (such as AI Automation & Prompt Injection defense);
   - Automatically generates your personalized `GEMINI.md`, `profile.md`, and activates the global pre-commit security hook.

---

## Core Guardrails

### 1. Zero-Leak Security Gateway
- **Gitleaks Pre-Commit Hook:** Physically blocks git commits at the OS level upon detecting API keys, access tokens, private certificates (`.pem`, `.key`), or `.env` credential files.
- **Strict Bypass Ban:** The agent is programmatically forbidden from utilizing the `--no-verify` flag.

### 2. Absolute Honesty & Verification Protocol (Anti-Hallucination)
- **Terminal Execution Proof:** The agent is prohibited from asserting that code works or tests pass based on conversational self-assessment. Verification requires deterministic execution with exit code 0.
- When an action is not executed in the terminal, the agent is contractually required to state: *"Not verified in terminal"*.
- **Constructive Skepticism:** The agent challenges overengineering, applies Occam's Razor, identifies top failure modes before coding, and bans sycophancy or ungrounded marketing assertions.
- **Three-Strike Rule:** If an error or failing test persists across three consecutive attempts, the agent must halt immediately, summarize hypotheses, and request human feedback.

### 3. Deterministic Builds (Pinning and Stability)
- Floating dependency ranges (`>=`, `~>`) are prohibited in requirements and manifests.
- Stable versions must be verified via documentation lookup (such as Context7) and pinned to exact versions (`package==X.Y.Z`) to guarantee reproducible builds across reboots and deployments.

### 4. Modular Domain Packs & Subagent Audit Gates
- **Lean Global Core:** Routine development remains fast with zero artificial commit blockers. Subagent audits are triggered for major architectural milestones, complex pipelines, or prior to merging to main.
- **Domain Modules (`templates/modules/`):** Plug-and-play guidelines for specialized fields:
  - `ai_automation.md`: Prompt injection defenses, SSRF guards, strict Pydantic `response_schema`, bounded retries, and token cost controls.
  - `trading_safety.md`: High-precision numeric safety (`Decimal`), mandatory paper/sandbox mode, and backtest integrity.

---

## Repository Structure

```text
.
|-- .github/workflows/ci.yml # Automated linting & security hook test suite
|-- GEMINI.md                # Lean universal agent constitution
|-- profile.template.md      # Developer profile template (stack, goals, preferences)
|-- install.sh               # macOS/Linux installer and git hook setup
|-- install.ps1              # Windows PowerShell installer and git hook setup
|-- uninstall.sh             # macOS/Linux uninstaller (restores git config)
|-- uninstall.ps1            # Windows PowerShell uninstaller
|-- init-project.sh          # macOS/Linux CLI tool to scaffold rules into any repo
|-- init-project.ps1         # Windows PowerShell CLI tool to scaffold rules
|-- docs/
|   `-- CROSS_IDE.md         # Integration guide for Cursor, Claude Code, and Windsurf
|-- skills/
|   `-- onboarding/          # Interactive onboarding wizard for Antigravity
|-- templates/
|   |-- .env.example         # Secret configuration template
|   |-- PROJECT_LOG.template.md # Lightweight architectural session memory
|   `-- modules/             # Specialized domain packs (ai_automation, trading_safety)
|-- tests/
|   `-- test_hook.sh         # Deterministic pre-commit hook test suite
`-- README.md                # Repository documentation
```

---

## CLI & Project Scaffolding

### 1. Global Installation
Install global constitution and git pre-commit protection:

**macOS / Linux:**
```bash
./install.sh
# To uninstall: ./uninstall.sh
```

**Windows (PowerShell):**
```powershell
.\install.ps1
# To uninstall: .\uninstall.ps1
```

### 2. Scaffold a New Project
Quickly set up any repository with cross-IDE rules, session memory, and optional domain packs:

**macOS / Linux:**
```bash
# Initialize for Cursor, Claude Code, and Antigravity:
./init-project.sh /path/to/my-project --ide all

# With AI Automation pack (SSRF guards, Pydantic response_schema, bounded retries):
./init-project.sh /path/to/my-agent --module ai

# With Trading Safety pack (Decimal precision, paper trading, slippage guards):
./init-project.sh /path/to/my-quant-bot --module trading
```

**Windows (PowerShell):**
```powershell
# Initialize for Cursor, Claude Code, and Antigravity:
.\init-project.ps1 C:\path\to\my-project -Ide all

# With AI Automation pack:
.\init-project.ps1 C:\path\to\my-agent -Module ai

# With Trading Safety pack:
.\init-project.ps1 C:\path\to\my-quant-bot -Module trading
```

---

## Cross-IDE Compatibility

All operational rules are written in standard GitHub Flavored Markdown and operate across developer environments. See [docs/CROSS_IDE.md](docs/CROSS_IDE.md) for detailed guidelines.
- **Google Antigravity:** Native execution via `GEMINI.md` and `skills/`.
- **Cursor:** Automated setup via `./init-project.sh <path> --ide cursor` (or `.cursorrules`).
- **Claude Code:** Automated setup via `./init-project.sh <path> --ide claude` (or `CLAUDE.md`).
- **Windsurf / Cline / Roo Code:** Reference in workspace rules or system instructions.

---

## Automated Verification

Run the security test suite locally to verify pre-commit secret blocking:
```bash
./tests/test_hook.sh
```

---

## License

MIT License. Free to use, modify, and distribute.
