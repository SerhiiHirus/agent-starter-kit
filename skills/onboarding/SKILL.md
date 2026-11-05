---
name: onboarding
description: Interactive onboarding wizard that interviews the user, personalizes GEMINI.md and profile.md, and activates zero-leak security guardrails.
---

# Agent Onboarding & Personalization Wizard

Use this skill whenever the user asks to configure, customize, or adapt the agent starter kit (e.g., "Set up my configuration", "onboard", "setup", "налаштуй під мене", or "/onboard").

## Operational Workflow

### Step 1: Welcome & Interactive Interview
Greet the user and use the `ask_question` tool to ask the following questions:

1. **Primary Specialization & Tech Stack**:
   - `(Recommended) Python & AI Automation (Pydantic, FastAPI, LLM agents)`
   - `Full-Stack Web (TypeScript, React, Next.js, Node.js)`
   - `Backend Engineering (Go / Rust / Java / C#)`
   - `Data Science & Machine Learning (Pandas, PyTorch)`
   - `Mobile Development (Flutter / Swift / Kotlin)`

2. **Communication Language**:
   - `(Recommended) English`
   - `Russian`
   - `Ukrainian`

3. **Response Style**:
   - `(Recommended) Concise, bottom-line first (no filler or verbose lectures)`
   - `Balanced with short explanations`
   - `Detailed and educational`

4. **Enable AI Automation & LLM Pipelines Module (Security & Reliability Subagents)?**:
   - `(Recommended) Yes, enable (Prompt Injection defense, Pydantic response_schema, token cost controls)`
   - `No, I develop classical software without LLM API calls`

5. **Knowledge Base (Obsidian / Markdown Vault)**:
   - `(Recommended) None / Skip`
   - `Specify local path to notes directory`

---

### Step 2: Generate Personalized Configurations
Based on user responses:

1. **Generate `profile.md`**:
   - Fill in `profile.template.md` with user choices.
   - Save to `~/.gemini/profile.md`.

2. **Generate `GEMINI.md`**:
   - Set the communication language.
   - If AI Automation was chosen, retain the `## AI AUTOMATION & LLM PIPELINES` section and subagent rules.
   - If not chosen, remove the AI Automation section to keep the constitution ultra-lean.
   - Save to `~/.gemini/GEMINI.md`.

3. **Install Pre-Commit Zero-Leak Hook**:
   - Run `./install.sh` to ensure the user's machine is protected against secret leaks.

---

### Step 3: Confirmation & Next Steps
Provide a concise summary:
- Active rules and persona;
- Status of security hooks;
- Quick operational tip for starting development.
