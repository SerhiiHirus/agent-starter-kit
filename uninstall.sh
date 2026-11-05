#!/usr/bin/env bash
# ==============================================================================
# Agent Starter Kit: Clean Uninstaller
# Safely restores git hooks configuration and cleans up installed hooks
# ==============================================================================

set -euo pipefail

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

TARGET_GEMINI_DIR="${HOME}/.gemini"
TARGET_HOOKS_DIR="${HOME}/.git-hooks"
BACKUP_HOOKS_FILE="${TARGET_GEMINI_DIR}/previous_hooks_path"

echo -e "\n${BOLD}${BLUE}=== Agent Starter Kit Uninstaller ===${NC}\n"

# 1. Restore Git core.hooksPath
if [ -f "${BACKUP_HOOKS_FILE}" ]; then
    RESTORED_PATH="$(cat "${BACKUP_HOOKS_FILE}")"
    git config --global core.hooksPath "${RESTORED_PATH}"
    rm -f "${BACKUP_HOOKS_FILE}"
    echo -e "${GREEN}[OK]${NC} Restored original git core.hooksPath -> ${RESTORED_PATH}"
else
    CURRENT_HOOKS="$(git config --global core.hooksPath 2>/dev/null || true)"
    if [ "$CURRENT_HOOKS" = "${TARGET_HOOKS_DIR}" ]; then
        git config --global --unset core.hooksPath
        echo -e "${GREEN}[OK]${NC} Unset global git core.hooksPath (reverted to default .git/hooks)"
    else
        echo -e "${BLUE}[Info]${NC} Global git core.hooksPath was not pointing to ${TARGET_HOOKS_DIR}. Left untouched."
    fi
fi

# 2. Remove Starter Kit Hooks
if [ -d "${TARGET_HOOKS_DIR}" ]; then
    rm -f "${TARGET_HOOKS_DIR}/pre-commit"
    rm -f "${TARGET_HOOKS_DIR}/pre-push"
    rmdir "${TARGET_HOOKS_DIR}" 2>/dev/null || true
    echo -e "${GREEN}[OK]${NC} Removed git hooks from ${TARGET_HOOKS_DIR}"
fi

echo -e "\n${BOLD}${GREEN}Uninstall Complete.${NC}"
echo -e "Your git pre-commit hooks have been restored to their previous state."
echo -e "Note: Files in ~/.gemini were kept intact to preserve any custom notes or profiles."
echo -e "If you wish to remove ~/.gemini completely, run: ${YELLOW}rm -rf ~/.gemini${NC}\n"
