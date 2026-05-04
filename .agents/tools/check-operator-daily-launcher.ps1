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
  ".agents/protocols/operator-daily-launcher-protocol.md",
  ".agents/tools/operator-daily.ps1",
  ".agents/tools/install-hephaestus-launcher.ps1",
  ".agents/tools/install-hephaestus.bat",
  ".agents/tools/check-operator-daily-launcher.ps1",
  ".agents/docs/en/26-OPERATOR-DAILY-LAUNCHER.md",
  ".agents/docs/pt-br/26-LANCADOR-DIARIO-DO-OPERADOR.md"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot ($file -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

$cliPath = Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1"
Test-Contains $results $cliPath '"daily"' "cli-action-daily"
Test-Contains $results $cliPath 'DailyMode' "cli-daily-mode"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/operator-daily.ps1") '"start","validate","release"' "daily-modes"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/install-hephaestus-launcher.ps1") "HEPHAESTUS-FIRST-CALL.md" "first-call-doc"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/install-hephaestus.bat") "install-hephaestus-launcher.ps1" "bat-launcher"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "operator_daily_launcher:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "operator-daily:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "26-OPERATOR-DAILY-LAUNCHER.md" "translation-map-en"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "26-LANCADOR-DIARIO-DO-OPERADOR.md" "translation-map-pt-br"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "operator-daily-launcher" "pre-release-check"

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
