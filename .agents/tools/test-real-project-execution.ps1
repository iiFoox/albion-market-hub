param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

function Add-Result {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Level,
    [string]$Check,
    [string]$Message
  )

  $List.Add([pscustomobject]@{
    Level = $Level
    Check = $Check
    Message = $Message
  }) | Out-Null
}

$resolvedRoot = (Resolve-Path $Root).Path
$scriptPath = Join-Path $resolvedRoot ".agents/tools/run-real-project-execution.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/executions/real-project-latest.md"
$results = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $scriptPath -PathType Leaf) {
  Add-Result $results "PASS" "tool" "run-real-project-execution.ps1"
} else {
  Add-Result $results "FAIL" "tool" "Missing run-real-project-execution.ps1"
}

$dryRunOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -Root $resolvedRoot -WriteReport 2>&1
if ($LASTEXITCODE -eq 0) {
  Add-Result $results "PASS" "dry-run" "Real project DryRun passed"
} else {
  Add-Result $results "FAIL" "dry-run" ($dryRunOutput | Out-String).Trim()
}

$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-real-exec-fixture-" + [guid]::NewGuid().ToString("N"))
try {
  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot ".agents/tools") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot ".agents/config") -Force | Out-Null
  Copy-Item -LiteralPath $scriptPath -Destination (Join-Path $fixtureRoot ".agents/tools/run-real-project-execution.ps1") -Force
  Set-Content -LiteralPath (Join-Path $fixtureRoot "README.md") -Value "# Fixture`r`n"
  Set-Content -LiteralPath (Join-Path $fixtureRoot ".agents/config/project.yaml") -Value @"
project:
  id: "fixture"
  name: "Fixture"
  root: "."
paths:
  source:
    - "."
  protected:
    - ".git/"
    - ".agents/"
execution:
  mode: "controlled"
  require_plan_before_changes: true
  require_approval_before_apply: true
  backup_before_mutation: true
  allow_destructive_commands: false
quality_gates:
  required:
    - "manual"
"@

  $fixtureScript = Join-Path $fixtureRoot ".agents/tools/run-real-project-execution.ps1"
  $applyOk = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureScript -Root $fixtureRoot -Apply -ApprovalToken "APPROVE_REAL_PROJECT_APPLY" -WriteReport 2>&1
  $markerPath = Join-Path $fixtureRoot "ADAPTER_BOUND_PLAN_ONLY.md"
  $backupDir = Join-Path $fixtureRoot ".agents/backups/real-project-execution"
  $backupCount = @(Get-ChildItem -LiteralPath $backupDir -Filter "real-project-backup-*.zip" -File -ErrorAction SilentlyContinue).Count
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $markerPath) -and $backupCount -gt 0) {
    Add-Result $results "PASS" "controlled-apply" "Controlled Apply created marker and backup artifact"
  } else {
    Add-Result $results "FAIL" "controlled-apply" ($applyOk | Out-String).Trim()
  }

  $restoreOk = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureScript -Root $fixtureRoot -RestoreLatest -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $fixtureRoot "README.md"))) {
    Add-Result $results "PASS" "restore" "Latest backup restored in fixture"
  } else {
    Add-Result $results "FAIL" "restore" ($restoreOk | Out-String).Trim()
  }
} finally {
  if (Test-Path -LiteralPath $fixtureRoot) {
    Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
  }
}

$applyOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -Root $resolvedRoot -Apply 2>&1
if ($LASTEXITCODE -ne 0 -and (($applyOutput | Out-String) -match "Apply blocked")) {
  Add-Result $results "PASS" "apply-block" "Apply without controlled mode/approval is blocked"
} else {
  Add-Result $results "FAIL" "apply-block" "Apply was not blocked as expected"
}

if (Test-Path -LiteralPath $reportPath) {
  $report = Get-Content -LiteralPath $reportPath -Raw
  if ($report.Contains('log_type: "real-project-execution"') -and $report.Contains('framework_version: "7.5.0"')) {
    Add-Result $results "PASS" "report" "Real project execution report has schema-compatible frontmatter"
  } else {
    Add-Result $results "FAIL" "report" "Real project execution report frontmatter is incomplete"
  }
} else {
  Add-Result $results "FAIL" "report" "Missing .agents/reports/executions/real-project-latest.md"
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0





