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
$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/real-project-execution-hardening-protocol.md"
$templatePath = Join-Path $resolvedRoot ".agents/reports/executions/real-project-hardening-template.md"
$runToolPath = Join-Path $resolvedRoot ".agents/tools/run-real-project-execution.ps1"
$testToolPath = Join-Path $resolvedRoot ".agents/tools/test-real-project-execution.ps1"
$results = New-Object System.Collections.Generic.List[object]

foreach ($path in @($frameworkPath, $protocolPath, $templatePath, $runToolPath, $testToolPath)) {
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "required-file" $path.Substring($resolvedRoot.Length + 1)
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $path"
  }
}

if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("real_project_execution_hardening:")) {
    Add-Result $results "PASS" "framework-config" "real_project_execution_hardening configured"
  } else {
    Add-Result $results "FAIL" "framework-config" "Missing real_project_execution_hardening config"
  }
}

if (Test-Path -LiteralPath $runToolPath) {
  $tool = Get-Content -LiteralPath $runToolPath -Raw
  foreach ($capability in @("New-ProjectBackup", "Restore-ProjectBackup", "Add-AuditEntry", "OverrideReason", "RestoreLatest")) {
    if ($tool.Contains($capability)) {
      Add-Result $results "PASS" "run-tool-capability" $capability
    } else {
      Add-Result $results "FAIL" "run-tool-capability" "Missing $capability"
    }
  }
}

if (Test-Path -LiteralPath $testToolPath) {
  $test = Get-Content -LiteralPath $testToolPath -Raw
  foreach ($proof in @("controlled-apply", "restore", "real-exec-fixture", "backup artifact")) {
    if ($test.Contains($proof)) {
      Add-Result $results "PASS" "test-proof" $proof
    } else {
      Add-Result $results "FAIL" "test-proof" "Missing $proof"
    }
  }
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
