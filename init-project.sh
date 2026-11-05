#!/usr/bin/env bash
# ==============================================================================
# Agent Starter Kit: Project Initializer
# Scaffolds cross-IDE rules, session memory, and domain modules in any project
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
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
MODULES_DIR="${TEMPLATES_DIR}/modules"

usage() {
    cat << EOF
Usage: $(basename "$0") <project_directory> [OPTIONS]

Arguments:
  <project_directory>       Path to the target project directory

Options:
  --ide <all|cursor|claude|antigravity>
                            Target AI tool/IDE (default: all)
  --module <ai|trading|none>
                            Domain module to include (default: none)
  -h, --help                Show this help message

Examples:
  $(basename "$0") ~/my-web-app --ide cursor
  $(basename "$0") ~/my-agent --ide all --module ai
  $(basename "$0") ~/algo-trader --ide claude --module trading
EOF
    exit 1
}

[ $# -lt 1 ] && usage

TARGET_DIR=""
IDE="all"
MODULE="none"

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        --ide)
            IDE="${2:-all}"
            shift 2
            ;;
        --module)
            MODULE="${2:-none}"
            shift 2
            ;;
        *)
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
                shift
            else
                echo -e "${RED}[Error] Unknown argument: $1${NC}"
                usage
            fi
            ;;
    esac
done

if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}[Error] Project directory is required.${NC}"
    usage
fi

# Resolve absolute path
mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
PROJECT_NAME="$(basename "$TARGET_DIR")"

echo -e "\n${BOLD}${BLUE}=== Scaffolding Agent Configuration for: ${PROJECT_NAME} ===${NC}\n"

# 1. Initialize .context/PROJECT_LOG.md
CONTEXT_DIR="${TARGET_DIR}/.context"
mkdir -p "$CONTEXT_DIR"
if [ ! -f "${CONTEXT_DIR}/PROJECT_LOG.md" ]; then
    if [ -f "${TEMPLATES_DIR}/PROJECT_LOG.template.md" ]; then
        sed "s/\[Project Name\]/${PROJECT_NAME}/g; s/\[YYYY-MM-DD\]/$(date +%Y-%m-%d)/g" \
            "${TEMPLATES_DIR}/PROJECT_LOG.template.md" > "${CONTEXT_DIR}/PROJECT_LOG.md"
    else
        cat << EOF > "${CONTEXT_DIR}/PROJECT_LOG.md"
# Project Log: ${PROJECT_NAME}

## Current Status & Next Steps
- Status: Initialized
- Next: Implement initial feature / setup

## Architecture Decisions
- $(date +%Y-%m-%d): Project initialized with Agent Starter Kit.

## Session History
- $(date +%Y-%m-%d): Repository configuration scaffolded.
EOF
    fi
    echo -e "${GREEN}[OK]${NC} Initialized session memory -> .context/PROJECT_LOG.md"
else
    echo -e "${BLUE}[Info]${NC} .context/PROJECT_LOG.md already exists. Preserved."
fi

# 2. Add .env.example if missing
if [ ! -f "${TARGET_DIR}/.env.example" ] && [ -f "${TEMPLATES_DIR}/.env.example" ]; then
    cp "${TEMPLATES_DIR}/.env.example" "${TARGET_DIR}/.env.example"
    echo -e "${GREEN}[OK]${NC} Added template -> .env.example"
fi

# 3. Build Project Instructions (Base + Optional Domain Module)
PROJECT_RULES_FILE="${TARGET_DIR}/GEMINI.md"
DATE_NOW="$(date +%Y-%m-%d)"

cat << EOF > "$PROJECT_RULES_FILE"
# Project Guidelines: ${PROJECT_NAME}
> Initialized: ${DATE_NOW} via Agent Starter Kit.
> Global protocol (~/.gemini/GEMINI.md) applies by default.

## Project Scope & Conventions
- Language & Style: English for code/docs; concise and result-oriented.
- Testing & Quality: Run test suites and linters configured in this repo before proposing commits.
EOF

if [ "$MODULE" = "ai" ]; then
    if [ -f "${MODULES_DIR}/ai_automation.md" ]; then
        echo -e "\n" >> "$PROJECT_RULES_FILE"
        cat "${MODULES_DIR}/ai_automation.md" >> "$PROJECT_RULES_FILE"
        echo -e "${GREEN}[OK]${NC} Attached domain pack -> AI Automation & LLM Pipelines"
    fi
elif [ "$MODULE" = "trading" ]; then
    if [ -f "${MODULES_DIR}/trading_safety.md" ]; then
        echo -e "\n" >> "$PROJECT_RULES_FILE"
        cat "${MODULES_DIR}/trading_safety.md" >> "$PROJECT_RULES_FILE"
        echo -e "${GREEN}[OK]${NC} Attached domain pack -> Trading Safety & Precision"
    fi
fi

echo -e "${GREEN}[OK]${NC} Generated project instructions -> GEMINI.md"

# 4. Configure IDE Links
case "$IDE" in
    cursor)
        ln -sf "GEMINI.md" "${TARGET_DIR}/.cursorrules"
        echo -e "${GREEN}[OK]${NC} Linked Cursor rules -> .cursorrules"
        ;;
    claude)
        ln -sf "GEMINI.md" "${TARGET_DIR}/CLAUDE.md"
        echo -e "${GREEN}[OK]${NC} Linked Claude Code rules -> CLAUDE.md"
        ;;
    antigravity)
        # Already written to GEMINI.md
        ;;
    all)
        ln -sf "GEMINI.md" "${TARGET_DIR}/.cursorrules"
        ln -sf "GEMINI.md" "${TARGET_DIR}/CLAUDE.md"
        echo -e "${GREEN}[OK]${NC} Linked Cursor rules -> .cursorrules"
        echo -e "${GREEN}[OK]${NC} Linked Claude Code rules -> CLAUDE.md"
        ;;
    *)
        echo -e "${YELLOW}[Warning]${NC} Unknown IDE: ${IDE}. Generated GEMINI.md only."
        ;;
esac

echo -e "\n${BOLD}${GREEN}Project Scaffolding Complete!${NC}"
echo -e "Location: ${TARGET_DIR}\n"
