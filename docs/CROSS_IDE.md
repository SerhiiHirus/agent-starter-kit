# Cross-IDE Integration Guide

The **Agent Starter Kit** uses clean GitHub Flavored Markdown rules that are native to all modern AI coding assistants.

---

## 1. Google Antigravity
Antigravity automatically discovers:
- Global constitution: `~/.gemini/GEMINI.md`
- Global developer profile: `~/.gemini/profile.md`
- Skills: `~/.gemini/antigravity/skills/`
- Workspace instructions: `./GEMINI.md` in your repository root.

**Zero setup needed:** Once installed via `./install.sh`, Antigravity picks up the configuration on its next turn.

---

## 2. Cursor IDE
Cursor looks for rules in `.cursorrules` or `.cursor/rules/`.

To configure a repository for Cursor:
```bash
# Automated via starter kit:
./init-project.sh /path/to/project --ide cursor

# Or manual symlink:
cd /path/to/project
ln -s ~/.gemini/GEMINI.md .cursorrules
```

---

## 3. Claude Code CLI
Claude Code reads `CLAUDE.md` in the current working directory.

To configure for Claude Code:
```bash
# Automated:
./init-project.sh /path/to/project --ide claude

# Or manual symlink:
cd /path/to/project
ln -s ~/.gemini/GEMINI.md CLAUDE.md
```

---

## 4. Windsurf, Cline & Roo Code
- **Windsurf:** Reads `.windsurfrules` in the workspace root. Symlink or copy `GEMINI.md`:
  ```bash
  ln -s ~/.gemini/GEMINI.md .windsurfrules
  ```
- **Cline / Roo Code:** Add the contents of `~/.gemini/GEMINI.md` to your Custom Instructions in the extension settings.

---

## 5. Domain Modules
If a specific project requires stricter guidelines (such as AI pipeline safety or algorithmic trading precision), plug them in via `./init-project.sh`:

```bash
# Attach AI pipeline safety pack (Pydantic validation, bounded retries, SSRF defense)
./init-project.sh /path/to/my-agent --module ai

# Attach Algorithmic Trading pack (Decimal precision, paper trading, slippage modeling)
./init-project.sh /path/to/my-quant-bot --module trading
```
