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
$scriptPath = Join-Path $resolvedRoot ".agents/tools/run-developer-execution-simulation.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/executions/latest.md"
$results = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $scriptPath -PathType Leaf) {
  Add-Result $results "PASS" "tool" "run-developer-execution-simulation.ps1"
} else {
  Add-Result $results "FAIL" "tool" "Missing run-developer-execution-simulation.ps1"
}

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -Root $resolvedRoot -WriteReport 2>&1
if ($LASTEXITCODE -eq 0) {
  Add-Result $results "PASS" "developer-execution" "profile-card execution passed"
} else {
  Add-Result $results "FAIL" "developer-execution" ($output | Out-String).Trim()
}

if (Test-Path -LiteralPath $reportPath) {
  $report = Get-Content -LiteralPath $reportPath -Raw
  if ($report.Contains('log_type: "developer-execution"') -and $report.Contains('framework_version: "7.5.0"')) {
    Add-Result $results "PASS" "report" "Developer execution report has schema-compatible frontmatter"
  } else {
    Add-Result $results "FAIL" "report" "Developer execution report frontmatter is incomplete"
  }
} else {
  Add-Result $results "FAIL" "report" "Missing .agents/reports/executions/latest.md"
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





