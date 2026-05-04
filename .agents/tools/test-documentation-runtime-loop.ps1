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
$runner = Join-Path $resolvedRoot ".agents/tools/run-documentation-runtime-loop.ps1"
$results = New-Object System.Collections.Generic.List[object]
$fixture = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-doc-runtime-" + [guid]::NewGuid().ToString("N"))

try {
  New-Item -ItemType Directory -Path (Join-Path $fixture ".agents/tools") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixture ".agents/config") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixture ".agents/reports/documentation") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixture "src") -Force | Out-Null

  Copy-Item -LiteralPath $runner -Destination (Join-Path $fixture ".agents/tools/run-documentation-runtime-loop.ps1") -Force
  Copy-Item -LiteralPath (Join-Path $resolvedRoot ".agents/config/documentation-policy.yaml") -Destination (Join-Path $fixture ".agents/config/documentation-policy.yaml") -Force
  Set-Content -LiteralPath (Join-Path $fixture "src/feature.ps1") -Value 'Write-Host "feature changed"' -Encoding UTF8

  $fixtureRunner = Join-Path $fixture ".agents/tools/run-documentation-runtime-loop.ps1"
  $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureRunner -Root $fixture -ChangedFiles "src/feature.ps1" -WriteReport 2>&1
  $reportPath = Join-Path $fixture ".agents/reports/documentation/documentation-runtime-latest.md"
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $reportPath)) {
    $report = Get-Content -LiteralPath $reportPath -Raw
    if ($report.Contains('log_type: "documentation-runtime"') -and $report.Contains('framework_version: "7.5.0"') -and $report.Contains('README.md')) {
      Add-Result $results "PASS" "runtime-report" "Runtime documentation impact report created"
    } else {
      Add-Result $results "FAIL" "runtime-report" "Report missing expected markers"
    }
  } else {
    Add-Result $results "FAIL" "runtime-report" ($output | Out-String).Trim()
  }

  $notImpacted = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureRunner -Root $fixture -ChangedFiles "tmp/cache.txt" -WriteReport 2>&1
  if ($LASTEXITCODE -ne 0 -and (($notImpacted | Out-String) -match "not_impacted requires")) {
    Add-Result $results "PASS" "not-impacted-reason" "Missing reason is rejected for not_impacted"
  } else {
    Add-Result $results "FAIL" "not-impacted-reason" "not_impacted without reason was not rejected"
  }
} finally {
  if (Test-Path -LiteralPath $fixture) {
    Remove-Item -LiteralPath $fixture -Recurse -Force
  }
}

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0



