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
  ".agents/protocols/install-update-wizard-protocol.md",
  ".agents/docs/en/20-INSTALL-UPDATE-WIZARD.md",
  ".agents/docs/pt-br/20-WIZARD-DE-INSTALACAO-E-UPDATE.md",
  ".agents/kernel/INSTALL-UPDATE.md",
  ".agents/tools/install-framework.ps1",
  ".agents/tools/update-framework.ps1",
  ".agents/tools/compare-framework-version.ps1"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot $file
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "install_update_wizard:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "install-update-wizard:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "20-INSTALL-UPDATE-WIZARD.md" "translation-map-en"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "20-WIZARD-DE-INSTALACAO-E-UPDATE.md" "translation-map-pt-br"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "install-update-wizard" "pre-release-check"

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0

