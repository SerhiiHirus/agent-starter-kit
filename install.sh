#!/usr/bin/env bash
# ==============================================================================
# Agent Starter Kit: One-Click Environment & Constitution Installer
# Works on macOS and Linux
# ==============================================================================

set -euo pipefail

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_GEMINI_DIR="${HOME}/.gemini"
TARGET_GEMINI_MD="${TARGET_GEMINI_DIR}/GEMINI.md"
TARGET_PROFILE_MD="${TARGET_GEMINI_DIR}/profile.md"
TARGET_SKILLS_DIR="${TARGET_GEMINI_DIR}/antigravity/skills"
TARGET_HOOKS_DIR="${HOME}/.git-hooks"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

echo -e "\n${BOLD}${BLUE}=== Agent Starter Kit Installer ===${NC}\n"

# 1. Create Gemini Directory
mkdir -p "${TARGET_GEMINI_DIR}"
mkdir -p "${TARGET_SKILLS_DIR}"

# 2. Install Constitution (GEMINI.md)
if [ -f "${SCRIPT_DIR}/GEMINI.md" ]; then
    if [ -f "${TARGET_GEMINI_MD}" ]; then
        echo -e "${YELLOW}[Backup]${NC} Existing GEMINI.md found. Backing up to GEMINI.md.${TIMESTAMP}.bak"
        cp "${TARGET_GEMINI_MD}" "${TARGET_GEMINI_MD}.${TIMESTAMP}.bak"
    fi
    cp "${SCRIPT_DIR}/GEMINI.md" "${TARGET_GEMINI_MD}"
    echo -e "${GREEN}[OK]${NC} Installed global constitution -> ${TARGET_GEMINI_MD}"
fi

# 3. Install Profile Template
if [ ! -f "${TARGET_PROFILE_MD}" ] && [ -f "${SCRIPT_DIR}/profile.template.md" ]; then
    cp "${SCRIPT_DIR}/profile.template.md" "${TARGET_PROFILE_MD}"
    echo -e "${GREEN}[OK]${NC} Initialized developer profile -> ${TARGET_PROFILE_MD}"
else
    echo -e "${BLUE}[Info]${NC} Developer profile already exists. Keeping current ${TARGET_PROFILE_MD}"
fi

# 4. Install Skills
if [ -d "${SCRIPT_DIR}/skills" ]; then
    cp -R "${SCRIPT_DIR}/skills/"* "${TARGET_SKILLS_DIR}/"
    echo -e "${GREEN}[OK]${NC} Installed skills -> ${TARGET_SKILLS_DIR}"
fi

# 5. Install Zero-Leak Git Pre-Commit Hook
echo -e "\n${BOLD}${BLUE}--- Setting up Zero-Leak Git Protection ---${NC}"
mkdir -p "${TARGET_HOOKS_DIR}"

cat << 'EOF' > "${TARGET_HOOKS_DIR}/pre-commit"
#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

STAGED_FILES=$(git diff --cached --name-only || true)
[ -z "$STAGED_FILES" ] && exit 0

# Level 1: Block sensitive filenames
while IFS= read -r file; do
    [ -z "$file" ] && continue
    filename=$(basename "$file")
    if [[ "$filename" =~ ^\.env(\..+)?$ ]] && [ "$filename" != ".env.example" ]; then
        echo -e "${RED}[BLOCKED] Forbidden file staged: ${file}${NC}"
        echo -e "Never commit .env files. Use .env.example instead."
        exit 1
    fi
    if [[ "$filename" =~ \.(pem|key|p12|pfx|sqlite|sqlite3|db)$ ]] || [[ "$filename" =~ ^id_rsa ]]; then
        echo -e "${RED}[BLOCKED] Sensitive file type staged: ${file}${NC}"
        exit 1
    fi
done <<< "$STAGED_FILES"

# Level 2: Gitleaks scan
GITLEAKS_BIN=""
if command -v gitleaks &> /dev/null; then
    GITLEAKS_BIN=$(command -v gitleaks)
elif [ -x "/opt/homebrew/bin/gitleaks" ]; then
    GITLEAKS_BIN="/opt/homebrew/bin/gitleaks"
elif [ -x "/usr/local/bin/gitleaks" ]; then
    GITLEAKS_BIN="/usr/local/bin/gitleaks"
fi

if [ -n "$GITLEAKS_BIN" ]; then
    if ! "$GITLEAKS_BIN" protect --staged --verbose --redact; then
        echo -e "\n${RED}[ABORTED] Gitleaks detected credentials in staged diff!${NC}\n"
        exit 1
    fi
fi

exit 0
EOF

chmod +x "${TARGET_HOOKS_DIR}/pre-commit"
ln -sf "${TARGET_HOOKS_DIR}/pre-commit" "${TARGET_HOOKS_DIR}/pre-push"
git config --global core.hooksPath "${TARGET_HOOKS_DIR}"
echo -e "${GREEN}[OK]${NC} Universal Git Pre-Commit & Pre-Push hooks configured -> ${TARGET_HOOKS_DIR}"
echo -e "${GREEN}[OK]${NC} Git configured globally with core.hooksPath"

# Check Gitleaks binary
if ! command -v gitleaks &> /dev/null && [ ! -x "/opt/homebrew/bin/gitleaks" ]; then
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}[Notice]${NC} Installing gitleaks via Homebrew for deep secret scanning..."
        brew install gitleaks || true
    else
        echo -e "${YELLOW}[Notice]${NC} Install gitleaks (https://github.com/gitleaks/gitleaks) for entropy scanning."
    fi
fi

echo -e "\n${BOLD}${GREEN}Setup Complete. Your AI Agent is configured with production guardrails.${NC}"
echo -e "Open Antigravity and type: ${BOLD}\"Set up my configuration\"${NC} to run interactive onboarding.\n"
