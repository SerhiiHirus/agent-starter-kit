# ==============================================================================
# Agent Starter Kit: One-Click Environment & Constitution Installer (Windows)
# PowerShell 5.1+ / PowerShell Core
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetGeminiDir = Join-Path $HOME ".gemini"
$TargetGeminiMd = Join-Path $TargetGeminiDir "GEMINI.md"
$TargetProfileMd = Join-Path $TargetGeminiDir "profile.md"
$TargetSkillsDir = Join-Path $TargetGeminiDir "antigravity\skills"
$TargetTemplatesDir = Join-Path $TargetGeminiDir "templates"
$TargetHooksDir = Join-Path $HOME ".git-hooks"

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "`n=== Agent Starter Kit Installer (Windows) ===`n" -ForegroundColor Cyan

# 1. Create Gemini Directories
if (-not (Test-Path $TargetGeminiDir)) { New-Item -ItemType Directory -Path $TargetGeminiDir -Force | Out-Null }
if (-not (Test-Path $TargetSkillsDir)) { New-Item -ItemType Directory -Path $TargetSkillsDir -Force | Out-Null }
if (-not (Test-Path $TargetTemplatesDir)) { New-Item -ItemType Directory -Path $TargetTemplatesDir -Force | Out-Null }

# 2. Install Constitution (GEMINI.md)
$SrcGeminiMd = Join-Path $ScriptDir "GEMINI.md"
if (Test-Path $SrcGeminiMd) {
    if (Test-Path $TargetGeminiMd) {
        $BackupFile = "$TargetGeminiMd.$Timestamp.bak"
        Write-Host "[Backup] Existing GEMINI.md found. Backing up to $BackupFile" -ForegroundColor Yellow
        Copy-Item -Path $TargetGeminiMd -Destination $BackupFile -Force
    }
    Copy-Item -Path $SrcGeminiMd -Destination $TargetGeminiMd -Force
    Write-Host "[OK] Installed global constitution -> $TargetGeminiMd" -ForegroundColor Green
}

# 3. Install Profile Template
$SrcProfile = Join-Path $ScriptDir "profile.template.md"
if (-not (Test-Path $TargetProfileMd) -and (Test-Path $SrcProfile)) {
    Copy-Item -Path $SrcProfile -Destination $TargetProfileMd -Force
    Write-Host "[OK] Initialized developer profile -> $TargetProfileMd" -ForegroundColor Green
} else {
    Write-Host "[Info] Developer profile already exists. Keeping current $TargetProfileMd" -ForegroundColor Cyan
}

# 4. Install Skills
$SrcSkills = Join-Path $ScriptDir "skills"
if (Test-Path $SrcSkills) {
    Copy-Item -Path "$SrcSkills\*" -Destination $TargetSkillsDir -Recurse -Force
    Write-Host "[OK] Installed skills -> $TargetSkillsDir" -ForegroundColor Green
}

# 5. Install Templates & Domain Modules
$SrcTemplates = Join-Path $ScriptDir "templates"
if (Test-Path $SrcTemplates) {
    Copy-Item -Path "$SrcTemplates\*" -Destination $TargetTemplatesDir -Recurse -Force
    Write-Host "[OK] Installed templates and domain modules -> $TargetTemplatesDir" -ForegroundColor Green
}

# 6. Install Zero-Leak Git Pre-Commit Hook
Write-Host "`n--- Setting up Zero-Leak Git Protection ---" -ForegroundColor Cyan
if (-not (Test-Path $TargetHooksDir)) { New-Item -ItemType Directory -Path $TargetHooksDir -Force | Out-Null }

$HookScript = @'
#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
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
fi

if [ -n "$GITLEAKS_BIN" ]; then
    if ! "$GITLEAKS_BIN" protect --staged --verbose --redact; then
        echo -e "\n${RED}[ABORTED] Gitleaks detected credentials in staged diff!${NC}\n"
        exit 1
    fi
fi

echo -e "${GREEN}[OK] Zero-leak pre-commit verification passed.${NC}"
exit 0
'@

$PreCommitPath = Join-Path $TargetHooksDir "pre-commit"
# Write with Unix line endings (LF) for Git's bash
$HookScriptLF = $HookScript -replace "`r`n", "`n"
[System.IO.File]::WriteAllText($PreCommitPath, $HookScriptLF, (New-Object System.Text.UTF8Encoding($false)))

$PrePushPath = Join-Path $TargetHooksDir "pre-push"
Copy-Item -Path $PreCommitPath -Destination $PrePushPath -Force

# Backup existing core.hooksPath if set
$PrevHooks = $(git config --global core.hooksPath 2>$null)
$TargetHooksUnix = ($TargetHooksDir -replace '\\', '/')

if ($PrevHooks -and ($PrevHooks -ne $TargetHooksDir) -and ($PrevHooks -ne $TargetHooksUnix)) {
    $PrevHooksFile = Join-Path $TargetGeminiDir "previous_hooks_path"
    $PrevHooks | Out-File -FilePath $PrevHooksFile -Encoding utf8
    Write-Host "[Backup] Saved existing git core.hooksPath -> $PrevHooksFile" -ForegroundColor Yellow
}

git config --global core.hooksPath "$TargetHooksUnix"
Write-Host "[OK] Universal Git Pre-Commit & Pre-Push hooks configured -> $TargetHooksDir" -ForegroundColor Green
Write-Host "[OK] Git configured globally with core.hooksPath" -ForegroundColor Green

# Check Gitleaks
if (-not (Get-Command gitleaks -ErrorAction SilentlyContinue)) {
    Write-Host "`n[Notice] Gitleaks binary not found." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Install via winget: winget install Gitleaks.Gitleaks" -ForegroundColor Yellow
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Install via Chocolatey: choco install gitleaks" -ForegroundColor Yellow
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Install via Scoop: scoop install gitleaks" -ForegroundColor Yellow
    } else {
        Write-Host "Download from: https://github.com/gitleaks/gitleaks/releases" -ForegroundColor Yellow
    }
}

Write-Host "`nSetup Complete. Your AI Agent is configured with production guardrails." -ForegroundColor Green
Write-Host "Open Antigravity and type: ""Set up my configuration"" to run interactive onboarding.`n"
