# ==============================================================================
# Agent Starter Kit: Project Initializer (Windows)
# Scaffolds cross-IDE rules, session memory, and domain modules in any project
# ==============================================================================

[CmdletBinding()]
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$ProjectPath,

    [ValidateSet("all", "cursor", "claude", "antigravity")]
    [string]$Ide = "all",

    [ValidateSet("none", "ai", "trading")]
    [string]$Module = "none"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplatesDir = Join-Path $ScriptDir "templates"
$ModulesDir = Join-Path $TemplatesDir "modules"

if (-not (Test-Path $ProjectPath)) {
    New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
}

$TargetDir = (Resolve-Path $ProjectPath).Path
$ProjectName = Split-Path -Leaf $TargetDir

Write-Host "`n=== Scaffolding Agent Configuration for: $ProjectName ===`n" -ForegroundColor Cyan

# 1. Initialize .context\PROJECT_LOG.md
$ContextDir = Join-Path $TargetDir ".context"
if (-not (Test-Path $ContextDir)) { New-Item -ItemType Directory -Path $ContextDir -Force | Out-Null }

$ProjectLogPath = Join-Path $ContextDir "PROJECT_LOG.md"
$TemplateLog = Join-Path $TemplatesDir "PROJECT_LOG.template.md"
$DateNow = (Get-Date -Format "yyyy-MM-dd")

if (-not (Test-Path $ProjectLogPath)) {
    if (Test-Path $TemplateLog) {
        $Content = (Get-Content $TemplateLog -Raw)
        $Content = $Content -replace '\[Project Name\]', $ProjectName -replace '\[YYYY-MM-DD\]', $DateNow
        [System.IO.File]::WriteAllText($ProjectLogPath, $Content, [System.Text.Encoding]::UTF8)
    } else {
        $BasicLog = @"
# Project Log: $ProjectName

## Current Status & Next Steps
- Status: Initialized
- Next: Implement initial feature / setup

## Architecture Decisions
- $DateNow: Project initialized with Agent Starter Kit.

## Session History
- $DateNow: Repository configuration scaffolded.
"@
        [System.IO.File]::WriteAllText($ProjectLogPath, $BasicLog, [System.Text.Encoding]::UTF8)
    }
    Write-Host "[OK] Initialized session memory -> .context\PROJECT_LOG.md" -ForegroundColor Green
} else {
    Write-Host "[Info] .context\PROJECT_LOG.md already exists. Preserved." -ForegroundColor Cyan
}

# 2. Add .env.example if missing
$EnvExample = Join-Path $TargetDir ".env.example"
$SrcEnvExample = Join-Path $TemplatesDir ".env.example"
if (-not (Test-Path $EnvExample) -and (Test-Path $SrcEnvExample)) {
    Copy-Item -Path $SrcEnvExample -Destination $EnvExample -Force
    Write-Host "[OK] Added template -> .env.example" -ForegroundColor Green
}

# 3. Build Project Instructions (GEMINI.md)
$ProjectRulesFile = Join-Path $TargetDir "GEMINI.md"

$BaseHeader = @"
# Project Guidelines: $ProjectName
> Initialized: $DateNow via Agent Starter Kit.
> Global protocol (~/.gemini/GEMINI.md) applies by default.

## Project Scope & Conventions
- Language & Style: English for code/docs; concise and result-oriented.
- Testing & Quality: Run test suites and linters configured in this repo before proposing commits.
"@

if ($Module -eq "ai") {
    $AiModule = Join-Path $ModulesDir "ai_automation.md"
    if (Test-Path $AiModule) {
        $BaseHeader += "`n`n" + (Get-Content $AiModule -Raw)
        Write-Host "[OK] Attached domain pack -> AI Automation & LLM Pipelines" -ForegroundColor Green
    }
} elseif ($Module -eq "trading") {
    $TradingModule = Join-Path $ModulesDir "trading_safety.md"
    if (Test-Path $TradingModule) {
        $BaseHeader += "`n`n" + (Get-Content $TradingModule -Raw)
        Write-Host "[OK] Attached domain pack -> Trading Safety & Precision" -ForegroundColor Green
    }
}

[System.IO.File]::WriteAllText($ProjectRulesFile, $BaseHeader, [System.Text.Encoding]::UTF8)
Write-Host "[OK] Generated project instructions -> GEMINI.md" -ForegroundColor Green

# 4. Configure IDE Links (Fallback to copy if symlink fails on Windows)
function Create-Or-Copy-Link($source, $target) {
    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force -ErrorAction Stop | Out-Null
    } catch {
        Copy-Item -Path $source -Destination $target -Force
    }
}

$CursorRules = Join-Path $TargetDir ".cursorrules"
$ClaudeMd = Join-Path $TargetDir "CLAUDE.md"

switch ($Ide) {
    "cursor" {
        Create-Or-Copy-Link $ProjectRulesFile $CursorRules
        Write-Host "[OK] Linked Cursor rules -> .cursorrules" -ForegroundColor Green
    }
    "claude" {
        Create-Or-Copy-Link $ProjectRulesFile $ClaudeMd
        Write-Host "[OK] Linked Claude Code rules -> CLAUDE.md" -ForegroundColor Green
    }
    "antigravity" {
        # GEMINI.md already created
    }
    "all" {
        Create-Or-Copy-Link $ProjectRulesFile $CursorRules
        Create-Or-Copy-Link $ProjectRulesFile $ClaudeMd
        Write-Host "[OK] Linked Cursor rules -> .cursorrules" -ForegroundColor Green
        Write-Host "[OK] Linked Claude Code rules -> CLAUDE.md" -ForegroundColor Green
    }
}

Write-Host "`nProject Scaffolding Complete!" -ForegroundColor Green
Write-Host "Location: $TargetDir`n"
