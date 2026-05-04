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
$runner = Join-Path $resolvedRoot ".agents/tools/run-release-evidence-bundle.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/releases/release-evidence-latest.md"
$results = New-Object System.Collections.Generic.List[object]

$output = & powershell -NoProfile -ExecutionPolicy Bypass -File $runner -Root $resolvedRoot -Version "7.5.0" -PackagePath "HEPHAESTUS-Framework-v7.5.0.zip" -WriteReport 2>&1
if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $reportPath)) {
  $report = Get-Content -LiteralPath $reportPath -Raw
  if ($report.Contains('log_type: "release-evidence"') -and $report.Contains('framework_version: "7.5.0"') -and $report.Contains("quality-gates")) {
    Add-Result $results "PASS" "release-evidence-report" "Release evidence report created"
  } else {
    Add-Result $results "FAIL" "release-evidence-report" "Report missing expected markers"
  }
} else {
  Add-Result $results "FAIL" "release-evidence-report" ($output | Out-String).Trim()
}

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0


