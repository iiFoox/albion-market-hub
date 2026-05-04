param(
  [string]$Root = ".",
  [string]$Request = "Prepare a controlled real-project execution plan.",
  [switch]$Apply,
  [switch]$RestoreLatest,
  [string]$ApprovalToken = "",
  [string]$OverrideReason = "",
  [switch]$WriteReport
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

function Get-ScalarValue {
  param(
    [string]$Content,
    [string]$Key,
    [string]$Default = ""
  )

  if ($Content -match "(?m)^\s*$([regex]::Escape($Key)):\s*`"?([^`"\r\n#]+)") {
    return $Matches[1].Trim()
  }
  return $Default
}

function Add-AuditEntry {
  param(
    [string]$Path,
    [string]$Event,
    [string]$Status,
    [string]$Message
  )

  $dir = Split-Path -Parent $Path
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }

  $timestamp = (Get-Date).ToString("o")
  Add-Content -LiteralPath $Path -Value "- $timestamp | $Event | $Status | $Message"
}

function New-ProjectBackup {
  param(
    [string]$SourcePath,
    [string]$BackupDirectory
  )

  if (-not (Test-Path -LiteralPath $BackupDirectory)) {
    New-Item -ItemType Directory -Path $BackupDirectory -Force | Out-Null
  }

  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $backupPath = Join-Path $BackupDirectory "real-project-backup-$stamp.zip"
  Compress-Archive -Path (Join-Path $SourcePath "*") -DestinationPath $backupPath -Force
  return $backupPath
}

function Restore-ProjectBackup {
  param(
    [string]$BackupDirectory,
    [string]$DestinationPath
  )

  $latest = Get-ChildItem -LiteralPath $BackupDirectory -Filter "real-project-backup-*.zip" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

  if (-not $latest) {
    throw "No backup artifact found in $BackupDirectory"
  }

  Expand-Archive -LiteralPath $latest.FullName -DestinationPath $DestinationPath -Force
  return $latest.FullName
}

$resolvedRoot = (Resolve-Path $Root).Path
$projectConfigPath = Join-Path $resolvedRoot ".agents/config/project.yaml"
$reportDir = Join-Path $resolvedRoot ".agents/reports/executions"
$reportPath = Join-Path $reportDir "real-project-latest.md"
$auditPath = Join-Path $reportDir "real-project-audit-latest.md"
$backupDir = Join-Path $resolvedRoot ".agents/backups/real-project-execution"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $projectConfigPath -PathType Leaf)) {
  Add-Result $results "FAIL" "adapter" "Missing .agents/config/project.yaml"
} else {
  Add-Result $results "PASS" "adapter" ".agents/config/project.yaml"
}

$projectConfig = ""
if (Test-Path -LiteralPath $projectConfigPath) {
  $projectConfig = Get-Content -LiteralPath $projectConfigPath -Raw
}

$projectRoot = Get-ScalarValue $projectConfig "root" "."
$executionMode = Get-ScalarValue $projectConfig "mode" "analysis_only"
$requirePlan = $projectConfig -match "require_plan_before_changes:\s*true"
$requireApproval = $projectConfig -match "require_approval_before_apply:\s*true"
$backupBeforeMutation = $projectConfig -match "backup_before_mutation:\s*true"
$allowDestructive = $projectConfig -match "allow_destructive_commands:\s*true"
$hasSource = $projectConfig -match "(?s)source:\s*\r?\n\s*-\s+"
$hasQualityGate = $projectConfig -match "(?s)quality_gates:\s*\r?\n\s*required:\s*\[?\]?"
$protectedDefaults = @(".git/", ".agents/", ".env", ".env.*", "secrets.*", "credentials.*")
$plannedFiles = @("ADAPTER_BOUND_PLAN_ONLY.md")
$protectedConflict = $false
$resolvedProjectRoot = [System.IO.Path]::GetFullPath((Join-Path $resolvedRoot $projectRoot))

foreach ($protected in $protectedDefaults) {
  foreach ($file in $plannedFiles) {
    if ($file.StartsWith($protected.TrimEnd("*"), [System.StringComparison]::OrdinalIgnoreCase)) {
      $protectedConflict = $true
    }
  }
}

if ($allowDestructive) {
  Add-Result $results "FAIL" "safety" "allow_destructive_commands must remain false"
} else {
  Add-Result $results "PASS" "safety" "Destructive commands disabled"
}

if ($requirePlan) {
  Add-Result $results "PASS" "plan-gate" "Plan required before changes"
} else {
  Add-Result $results "FAIL" "plan-gate" "Plan must be required before changes"
}

if ($requireApproval) {
  Add-Result $results "PASS" "approval-gate" "Approval required before apply"
} else {
  Add-Result $results "FAIL" "approval-gate" "Approval must be required before apply"
}

if ($backupBeforeMutation) {
  Add-Result $results "PASS" "backup-gate" "Backup required before mutation"
} else {
  Add-Result $results "FAIL" "backup-gate" "Backup must be required before mutation"
}

if ($protectedConflict) {
  Add-Result $results "FAIL" "protected-paths" "Planned files conflict with protected paths"
} else {
  Add-Result $results "PASS" "protected-paths" "No protected path conflicts in DryRun plan"
}

if ($RestoreLatest) {
  try {
    $restored = Restore-ProjectBackup -BackupDirectory $backupDir -DestinationPath $resolvedProjectRoot
    Add-Result $results "PASS" "restore" "Restored latest backup: $restored"
    Add-AuditEntry -Path $auditPath -Event "restore" -Status "PASS" -Message "Restored $restored"
  } catch {
    Add-Result $results "FAIL" "restore" $_.Exception.Message
    Add-AuditEntry -Path $auditPath -Event "restore" -Status "FAIL" -Message $_.Exception.Message
  }
} elseif ($Apply) {
  if ($executionMode -ne "controlled") {
    Add-Result $results "FAIL" "apply" "Apply blocked because execution.mode is $executionMode"
    Add-AuditEntry -Path $auditPath -Event "apply" -Status "BLOCKED" -Message "execution.mode=$executionMode"
  } elseif ($ApprovalToken -ne "APPROVE_REAL_PROJECT_APPLY") {
    Add-Result $results "FAIL" "apply" "Apply blocked because approval token is missing or invalid"
    Add-AuditEntry -Path $auditPath -Event "apply" -Status "BLOCKED" -Message "missing approval token"
  } elseif ($protectedConflict -and [string]::IsNullOrWhiteSpace($OverrideReason)) {
    Add-Result $results "FAIL" "apply" "Apply blocked because protected path override reason is missing"
    Add-AuditEntry -Path $auditPath -Event "apply" -Status "BLOCKED" -Message "protected path override reason missing"
  } else {
    $backupPath = New-ProjectBackup -SourcePath $resolvedProjectRoot -BackupDirectory $backupDir
    Add-Result $results "PASS" "backup-artifact" $backupPath
    Add-AuditEntry -Path $auditPath -Event "backup" -Status "PASS" -Message $backupPath

    $markerPath = Join-Path $resolvedProjectRoot "ADAPTER_BOUND_PLAN_ONLY.md"
    Set-Content -LiteralPath $markerPath -Value "# Adapter-Bound Apply Marker`r`n`r`nRequest: $Request`r`n"
    Add-Result $results "PASS" "apply" "Controlled Apply wrote adapter-bound marker"
    Add-AuditEntry -Path $auditPath -Event "apply" -Status "PASS" -Message "Wrote $markerPath"
  }
} else {
  Add-Result $results "PASS" "dry-run" "DryRun plan generated without modifying project files"
  Add-AuditEntry -Path $auditPath -Event "dry-run" -Status "PASS" -Message "No project files modified"
}

$status = "dry_run"
if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  $status = "blocked"
}
if ($Apply -and $status -ne "blocked") {
  $status = "applied"
}
if ($RestoreLatest -and $status -ne "blocked") {
  $status = "restored"
}

if ($WriteReport) {
  New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  $timestamp = (Get-Date).ToString("o")
  $summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
  $report = @(
    "# HEPHAESTUS Real Project Execution Report",
    "",
    "---",
    'log_type: "real-project-execution"',
    "timestamp: `"$timestamp`"",
    "status: `"$status`"",
    'event: "real_project_execution.completed"',
    'framework_version: "7.5.0"',
    'complexity: "DEEP"',
    'workflow: "real-project-execution"',
    "---",
    "",
    "## Request",
    "",
    $Request,
    "",
    "## Real Project Execution Status",
    "",
    "- Status: $status",
    "- Project root: $projectRoot",
    "- Adapter status: adapter_present",
    "- Execution mode: $executionMode",
    "- Planned files: $($plannedFiles -join ', ')",
    "- Protected path conflicts: $protectedConflict",
    "- Backup required: $backupBeforeMutation",
    "- Backup directory: $backupDir",
    "- Approval required: $requireApproval",
    "- Audit log: $auditPath",
    "- Quality gates configured: $hasQualityGate",
    "- Source paths configured: $hasSource",
    "- Summary: $($summary -join ', ')",
    "",
    "## Checks"
  )
  foreach ($result in ($results | Sort-Object Level, Check, Message)) {
    $report += "- $($result.Level) $($result.Check): $($result.Message)"
  }
  $report | Set-Content -LiteralPath $reportPath
  Add-Result $results "PASS" "report" ".agents/reports/executions/real-project-latest.md"
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$finalSummary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Real project execution summary: $($finalSummary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0





