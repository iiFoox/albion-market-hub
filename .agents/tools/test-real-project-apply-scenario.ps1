param(
  [string]$Root = ".",
  [switch]$KeepFixture
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

function Write-ScenarioReport {
  param(
    [string]$ReportPath,
    [string]$FixtureRoot,
    [System.Collections.Generic.List[object]]$Results
  )

  $status = "PASS"
  if (@($Results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
    $status = "FAIL"
  }

  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "real-project-apply-scenario"') | Out-Null
  $content.Add('framework_version: "7.5.0"') | Out-Null
  $content.Add("status: `"$status`"") | Out-Null
  $content.Add("generated_at: `"$((Get-Date).ToString("o"))`"") | Out-Null
  $content.Add("fixture_root: `"$FixtureRoot`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Real Project Apply Scenario Report") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Checks") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Check | Status | Notes |") | Out-Null
  $content.Add("|---|---:|---|") | Out-Null

  foreach ($result in ($Results | Sort-Object Level, Check, Message)) {
    $message = $result.Message.Replace("|", "/")
    $content.Add("| $($result.Check) | $($result.Level) | $message |") | Out-Null
  }

  $reportDir = Split-Path -Parent $ReportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }
  Set-Content -LiteralPath $ReportPath -Value $content -Encoding UTF8
}

$resolvedRoot = (Resolve-Path $Root).Path
$realExecutionTool = Join-Path $resolvedRoot ".agents/tools/run-real-project-execution.ps1"
$qualityGateTool = Join-Path $resolvedRoot ".agents/tools/run-quality-gates.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/executions/real-project-apply-scenario-latest.md"
$results = New-Object System.Collections.Generic.List[object]
$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-real-apply-scenario-" + [guid]::NewGuid().ToString("N"))

try {
  foreach ($tool in @($realExecutionTool, $qualityGateTool)) {
    if (-not (Test-Path -LiteralPath $tool -PathType Leaf)) {
      Add-Result $results "FAIL" "tooling" "Missing $tool"
    }
  }

  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot ".agents/tools") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot ".agents/config") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot ".agents/reports/executions") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixtureRoot "tests") -Force | Out-Null

  Copy-Item -LiteralPath $realExecutionTool -Destination (Join-Path $fixtureRoot ".agents/tools/run-real-project-execution.ps1") -Force
  Copy-Item -LiteralPath $qualityGateTool -Destination (Join-Path $fixtureRoot ".agents/tools/run-quality-gates.ps1") -Force

  Set-Content -LiteralPath (Join-Path $fixtureRoot "README.md") -Value "# Apply Scenario Fixture`r`n" -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $fixtureRoot "tests/quality.test.ps1") -Value @(
    '$ErrorActionPreference = "Stop"',
    'if (-not (Test-Path -LiteralPath "README.md")) { throw "README missing" }',
    'Write-Host "quality gate passed"'
  ) -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $fixtureRoot ".agents/config/project.yaml") -Value @(
    'project:',
    '  id: "apply-scenario-fixture"',
    '  name: "Apply Scenario Fixture"',
    '  root: "."',
    '',
    'commands:',
    '  test:',
    '    command: "powershell -NoProfile -ExecutionPolicy Bypass -File tests/quality.test.ps1"',
    '    allowed: true',
    '  lint:',
    '    command: ""',
    '    allowed: false',
    '',
    'paths:',
    '  source:',
    '    - "."',
    '  protected:',
    '    - ".git/"',
    '    - ".agents/"',
    '',
    'execution:',
    '  mode: "controlled"',
    '  require_plan_before_changes: true',
    '  require_approval_before_apply: true',
    '  backup_before_mutation: true',
    '  allow_destructive_commands: false',
    '',
    'quality_gates:',
    '  required:',
    '    - "test"'
  ) -Encoding UTF8

  $fixtureRealExecutionTool = Join-Path $fixtureRoot ".agents/tools/run-real-project-execution.ps1"
  $fixtureQualityGateTool = Join-Path $fixtureRoot ".agents/tools/run-quality-gates.ps1"

  $preGate = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureQualityGateTool -Root $fixtureRoot -GateNames test -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "pre-apply-quality-gate" "Quality gate passed before Apply"
  } else {
    Add-Result $results "FAIL" "pre-apply-quality-gate" ($preGate | Out-String).Trim()
  }

  $dryRun = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureRealExecutionTool -Root $fixtureRoot -Request "Scenario DryRun" -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0 -and -not (Test-Path -LiteralPath (Join-Path $fixtureRoot "ADAPTER_BOUND_PLAN_ONLY.md"))) {
    Add-Result $results "PASS" "dry-run" "DryRun completed without marker mutation"
  } else {
    Add-Result $results "FAIL" "dry-run" ($dryRun | Out-String).Trim()
  }

  $apply = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureRealExecutionTool -Root $fixtureRoot -Request "Scenario controlled Apply" -Apply -ApprovalToken "APPROVE_REAL_PROJECT_APPLY" -WriteReport 2>&1
  $markerPath = Join-Path $fixtureRoot "ADAPTER_BOUND_PLAN_ONLY.md"
  $backupDir = Join-Path $fixtureRoot ".agents/backups/real-project-execution"
  $backupArtifacts = @(Get-ChildItem -LiteralPath $backupDir -Filter "real-project-backup-*.zip" -File -ErrorAction SilentlyContinue)
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $markerPath) -and $backupArtifacts.Count -gt 0) {
    Add-Result $results "PASS" "controlled-apply" "Apply created marker and backup artifact"
  } else {
    Add-Result $results "FAIL" "controlled-apply" ($apply | Out-String).Trim()
  }

  $postGate = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureQualityGateTool -Root $fixtureRoot -GateNames test -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "post-apply-quality-gate" "Quality gate passed after Apply"
  } else {
    Add-Result $results "FAIL" "post-apply-quality-gate" ($postGate | Out-String).Trim()
  }

  $restore = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureRealExecutionTool -Root $fixtureRoot -RestoreLatest -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $fixtureRoot "README.md"))) {
    Add-Result $results "PASS" "restore" "Restore command succeeded against latest backup"
  } else {
    Add-Result $results "FAIL" "restore" ($restore | Out-String).Trim()
  }

  $auditPath = Join-Path $fixtureRoot ".agents/reports/executions/real-project-audit-latest.md"
  if (Test-Path -LiteralPath $auditPath) {
    $audit = Get-Content -LiteralPath $auditPath -Raw
    if ($audit -match "dry-run" -and $audit -match "backup" -and $audit -match "apply" -and $audit -match "restore") {
      Add-Result $results "PASS" "audit-trail" "Audit trail contains DryRun, backup, Apply, and restore events"
    } else {
      Add-Result $results "FAIL" "audit-trail" "Audit trail missing expected events"
    }
  } else {
    Add-Result $results "FAIL" "audit-trail" "Missing audit trail"
  }

  $realReport = Join-Path $fixtureRoot ".agents/reports/executions/real-project-latest.md"
  $gateReport = Join-Path $fixtureRoot ".agents/reports/executions/quality-gates-latest.md"
  if ((Test-Path -LiteralPath $realReport) -and (Test-Path -LiteralPath $gateReport)) {
    Add-Result $results "PASS" "evidence-reports" "Real execution and quality gate reports created"
  } else {
    Add-Result $results "FAIL" "evidence-reports" "Missing scenario evidence reports"
  }
} finally {
  Write-ScenarioReport -ReportPath $reportPath -FixtureRoot $fixtureRoot -Results $results
  if ((Test-Path -LiteralPath $fixtureRoot) -and -not $KeepFixture) {
    Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0




