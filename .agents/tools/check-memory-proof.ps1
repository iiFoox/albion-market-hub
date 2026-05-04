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

function Test-Contains {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Path,
    [string]$Pattern,
    [string]$Check
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    Add-Result $Results "FAIL" $Check "Missing $Path"
    return
  }

  $text = Get-Content -LiteralPath $Path -Raw
  if ($text -match $Pattern) {
    Add-Result $Results "PASS" $Check "Found expected marker"
  } else {
    Add-Result $Results "FAIL" $Check "Missing expected marker: $Pattern"
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$results = New-Object System.Collections.Generic.List[object]

$requiredFiles = @(
  ".agents/protocols/optional-telemetry-memory-proof-protocol.md",
  ".agents/tools/run-memory-proof.ps1",
  ".agents/tools/check-memory-proof.ps1",
  ".agents/reports/memory/README.md",
  ".agents/reports/memory/memory-proof-template.md",
  ".agents/config/memory-policy.yaml",
  ".agents/config/telemetry-schema.yaml",
  ".agents/tools/cleanup-telemetry.ps1"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot $file
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "optional_telemetry_memory_proof:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "memory-proof:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/memory-policy.yaml") "proof:" "memory-policy-proof"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/telemetry-schema.yaml") "memory-proof" "telemetry-schema"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "memory-proof" "pre-release-check"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/run-memory-proof.ps1") "Memory proof summary" "runner-summary"

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0

