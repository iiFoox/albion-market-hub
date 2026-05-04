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
$scriptPath = Join-Path $resolvedRoot ".agents/tools/run-framework-simulation.ps1"
$results = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $scriptPath -PathType Leaf) {
  Add-Result $results "PASS" "tool" "run-framework-simulation.ps1"
} else {
  Add-Result $results "FAIL" "tool" "Missing run-framework-simulation.ps1"
}

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -Root $resolvedRoot -Scenario "ui-feature" -WriteReport 2>&1
if ($LASTEXITCODE -eq 0) {
  Add-Result $results "PASS" "simulation" "ui-feature simulation passed"
} else {
  Add-Result $results "FAIL" "simulation" ($output | Out-String).Trim()
}

$reportPath = Join-Path $resolvedRoot ".agents/reports/simulations/latest.md"
if (Test-Path -LiteralPath $reportPath) {
  $report = Get-Content -LiteralPath $reportPath -Raw
  if ($report.Contains('log_type: "simulation"') -and $report.Contains('framework_version: "7.5.0"')) {
    Add-Result $results "PASS" "report" "Simulation report has schema-compatible frontmatter"
  } else {
    Add-Result $results "FAIL" "report" "Simulation report frontmatter is incomplete"
  }
} else {
  Add-Result $results "FAIL" "report" "Missing .agents/reports/simulations/latest.md"
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





