# ==============================================================================
# Agent Starter Kit: Clean Uninstaller (Windows)
# PowerShell 5.1+ / PowerShell Core
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$TargetGeminiDir = Join-Path $HOME ".gemini"
$TargetHooksDir = Join-Path $HOME ".git-hooks"
$BackupHooksFile = Join-Path $TargetGeminiDir "previous_hooks_path"

Write-Host "`n=== Agent Starter Kit Uninstaller (Windows) ===`n" -ForegroundColor Cyan

# 1. Restore Git core.hooksPath
if (Test-Path $BackupHooksFile) {
    $RestoredPath = (Get-Content $BackupHooksFile -Raw).Trim()
    git config --global core.hooksPath "$RestoredPath"
    Remove-Item -Path $BackupHooksFile -Force
    Write-Host "[OK] Restored original git core.hooksPath -> $RestoredPath" -ForegroundColor Green
} else {
    $CurrentHooks = $(git config --global core.hooksPath 2>$null)
    $TargetHooksUnix = ($TargetHooksDir -replace '\\', '/')
    if ($CurrentHooks -eq $TargetHooksDir -or $CurrentHooks -eq $TargetHooksUnix) {
        git config --global --unset core.hooksPath
        Write-Host "[OK] Unset global git core.hooksPath (reverted to default .git/hooks)" -ForegroundColor Green
    } else {
        Write-Host "[Info] Global git core.hooksPath was not pointing to $TargetHooksDir. Left untouched." -ForegroundColor Cyan
    }
}

# 2. Remove Starter Kit Hooks
if (Test-Path $TargetHooksDir) {
    Remove-Item -Path (Join-Path $TargetHooksDir "pre-commit") -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $TargetHooksDir "pre-push") -Force -ErrorAction SilentlyContinue
    if (-not (Get-ChildItem $TargetHooksDir)) {
        Remove-Item -Path $TargetHooksDir -Force -ErrorAction SilentlyContinue
    }
    Write-Host "[OK] Removed git hooks from $TargetHooksDir" -ForegroundColor Green
}

Write-Host "`nUninstall Complete." -ForegroundColor Green
Write-Host "Your git pre-commit hooks have been restored to their previous state."
Write-Host "Note: Files in $TargetGeminiDir were kept intact to preserve any custom notes or profiles.`n"
