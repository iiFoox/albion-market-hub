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
$scriptPath = Join-Path $resolvedRoot ".agents/tools/run-developer-benchmark.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/executions/benchmark-latest.md"
$results = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $scriptPath -PathType Leaf) {
  Add-Result $results "PASS" "tool" "run-developer-benchmark.ps1"
} else {
  Add-Result $results "FAIL" "tool" "Missing run-developer-benchmark.ps1"
}

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -Root $resolvedRoot -WriteReport 2>&1
if ($LASTEXITCODE -eq 0) {
  Add-Result $results "PASS" "benchmark" "developer benchmark passed"
} else {
  Add-Result $results "FAIL" "benchmark" ($output | Out-String).Trim()
}

if (Test-Path -LiteralPath $reportPath) {
  $report = Get-Content -LiteralPath $reportPath -Raw
  $requiredScenarios = @("profile-card", "docs-update", "bug-fix", "validation-failure", "api", "database-migration", "refactor", "security-fix", "failing-tests", "docs-only-release")
  $missingScenarios = @($requiredScenarios | Where-Object { -not $report.Contains("- $_") })
  if ($report.Contains('log_type: "developer-benchmark"') -and $report.Contains('framework_version: "7.5.0"') -and $missingScenarios.Count -eq 0) {
    Add-Result $results "PASS" "report" "Developer benchmark report has schema-compatible frontmatter"
  } else {
    Add-Result $results "FAIL" "report" "Developer benchmark report frontmatter or scenarios are incomplete"
  }
} else {
  Add-Result $results "FAIL" "report" "Missing .agents/reports/executions/benchmark-latest.md"
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





