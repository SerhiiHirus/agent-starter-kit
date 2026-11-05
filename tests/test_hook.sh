#!/usr/bin/env bash
# ==============================================================================
# Agent Starter Kit: Pre-Commit Security Hook Verification Suite
# ==============================================================================

set -euo pipefail

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "\n${BOLD}${BLUE}=== Running Pre-Commit Hook Security Tests ===${NC}\n"

# Create isolated test git repository
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

git -C "$TEST_DIR" init -q
git -C "$TEST_DIR" config user.email "test@example.com"
git -C "$TEST_DIR" config user.name "Security Tester"

# Install hook script
HOOK_FILE="${TEST_DIR}/.git/hooks/pre-commit"
mkdir -p "$(dirname "$HOOK_FILE")"

cat << 'EOF' > "$HOOK_FILE"
#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

STAGED_FILES=$(git diff --cached --name-only || true)
[ -z "$STAGED_FILES" ] && exit 0

while IFS= read -r file; do
    [ -z "$file" ] && continue
    filename=$(basename "$file")
    if [[ "$filename" =~ ^\.env(\..+)?$ ]] && [ "$filename" != ".env.example" ]; then
        echo -e "${RED}[BLOCKED] Forbidden file staged: ${file}${NC}"
        exit 1
    fi
    if [[ "$filename" =~ \.(pem|key|p12|pfx|sqlite|sqlite3|db)$ ]] || [[ "$filename" =~ ^id_rsa ]]; then
        echo -e "${RED}[BLOCKED] Sensitive file type staged: ${file}${NC}"
        exit 1
    fi
done <<< "$STAGED_FILES"

exit 0
EOF
chmod +x "$HOOK_FILE"

# --- Test 1: Clean file should PASS ---
echo "Test 1: Committing safe file (clean.txt)..."
echo "Safe content" > "${TEST_DIR}/clean.txt"
git -C "$TEST_DIR" add clean.txt
if git -C "$TEST_DIR" commit -m "test: clean commit" > /dev/null 2>&1; then
    echo -e "${GREEN}[PASS] Clean commit succeeded as expected.${NC}"
else
    echo -e "${RED}[FAIL] Clean commit was unexpectedly blocked!${NC}"
    exit 1
fi

# --- Test 2: Staging .env should FAIL ---
echo "Test 2: Committing forbidden .env file..."
echo "API_KEY=secret_value" > "${TEST_DIR}/.env"
git -C "$TEST_DIR" add .env
if git -C "$TEST_DIR" commit -m "test: illegal .env" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL] Security breach: .env file was committed!${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Hook successfully blocked .env file.${NC}"
fi

# --- Test 3: Staging .env.example should PASS ---
echo "Test 3: Committing allowed .env.example..."
git -C "$TEST_DIR" reset -q .env
rm -f "${TEST_DIR}/.env"
echo "API_KEY=your_key_here" > "${TEST_DIR}/.env.example"
git -C "$TEST_DIR" add .env.example
if git -C "$TEST_DIR" commit -m "test: .env.example commit" > /dev/null 2>&1; then
    echo -e "${GREEN}[PASS] .env.example allowed as expected.${NC}"
else
    echo -e "${RED}[FAIL] .env.example was blocked!${NC}"
    exit 1
fi

# --- Test 4: Staging private key / certificate should FAIL ---
echo "Test 4: Committing forbidden certificate (server.pem)..."
echo "-----BEGIN PRIVATE KEY-----" > "${TEST_DIR}/server.pem"
git -C "$TEST_DIR" add server.pem
if git -C "$TEST_DIR" commit -m "test: illegal certificate" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL] Security breach: certificate was committed!${NC}"
    exit 1
else
    echo -e "${GREEN}[PASS] Hook successfully blocked server.pem.${NC}"
fi

echo -e "\n${BOLD}${GREEN}All Pre-Commit Security Hook Tests Passed Successfully!${NC}\n"
