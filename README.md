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
- **Three-Strike Rule:** If an error or failing test persists across three consecutive attempts, the agent must halt immediately, summarize hypotheses, and request human feedback.

### 3. Deterministic Builds (Pinning and Stability)
- Floating dependency ranges (`>=`, `~>`) are prohibited in requirements and manifests.
- Stable versions must be verified via documentation lookup (such as Context7) and pinned to exact versions (`package==X.Y.Z`) to guarantee reproducible builds across reboots and deployments.

### 4. Autonomous Subagent Audit Gates (AI Automation Module)
- **AI Security & Injection Auditor (Red Team):** Audits ingestion points and parsers for prompt injection vectors, content boundary separation, and SSRF protections.
- **AI Reliability & Cost Auditor:** Enforces Pydantic `response_schema` validation, mandatory execution timeouts, bounded retry limits (maximum 3), and default `dry_run = True` flags for functions with external side-effects.

---

## Repository Structure

```text
.
|-- GEMINI.md               # Universal production-grade agent constitution
|-- profile.template.md     # Developer profile template (stack, goals, preferences)
|-- install.sh              # One-click environment installer and git hook setup
|-- skills/
|   `-- onboarding/         # Interactive onboarding wizard for Antigravity
|-- templates/              # Standard templates for session logs and notes
`-- README.md               # Repository documentation
```

---

## Manual Installation (CLI)

To install configurations manually without conversational onboarding:

```bash
git clone https://github.com/<your-username>/agent-starter-kit.git
cd agent-starter-kit

# Run the installer (installs constitution to ~/.gemini and configures git hooks)
./install.sh
```

---

## Cross-IDE Compatibility

All operational rules are written in standard GitHub Flavored Markdown and operate across developer environments:
- **Google Antigravity:** Native execution via `GEMINI.md` and `skills/`.
- **Cursor:** Symlink configuration via `ln -s ~/.gemini/GEMINI.md .cursorrules`.
- **Claude Code:** Import directly as `CLAUDE.md`.
- **Windsurf / Cline / Roo Code:** Reference in workspace rules or system instructions.

---

## License

MIT License. Free to use, modify, and distribute.
