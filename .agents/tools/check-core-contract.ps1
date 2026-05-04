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

function Get-Scalar {
  param([string]$Text, [string]$Key)

  $pattern = "(?m)^\s*$([regex]::Escape($Key)):\s*`"?([^`"`r`n]+)`"?\s*$"
  $match = [regex]::Match($Text, $pattern)
  if ($match.Success) {
    return $match.Groups[1].Value.Trim()
  }
  return $null
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
  ".agents/AGENTS.md",
  ".agents/protocols/core-contract-drift-guard-protocol.md",
  ".agents/tools/check-core-contract.ps1",
  ".agents/docs/en/25-CORE-CONTRACT-DRIFT-GUARD.md",
  ".agents/docs/pt-br/25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot ($file -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$manifestPath = Join-Path $resolvedRoot ".agents/config/framework-manifest.yaml"
$translationMapPath = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"
$agentsPath = Join-Path $resolvedRoot ".agents/AGENTS.md"

$frameworkText = Get-Content -LiteralPath $frameworkPath -Raw
$manifestText = Get-Content -LiteralPath $manifestPath -Raw
$translationMapText = Get-Content -LiteralPath $translationMapPath -Raw
$agentsText = Get-Content -LiteralPath $agentsPath -Raw

$versions = [ordered]@{
  "framework.yaml" = Get-Scalar $frameworkText "version"
  "framework-manifest.yaml" = Get-Scalar $manifestText "framework_version"
  "_translation-map.yaml" = Get-Scalar $translationMapText "framework_version"
}

$expectedVersion = $versions["framework-manifest.yaml"]
foreach ($entry in $versions.GetEnumerator()) {
  if ($entry.Value -eq $expectedVersion -and -not [string]::IsNullOrWhiteSpace($entry.Value)) {
    Add-Result $results "PASS" "version-alignment" "$($entry.Key)=$($entry.Value)"
  } else {
    Add-Result $results "FAIL" "version-alignment" "$($entry.Key)=$($entry.Value), expected=$expectedVersion"
  }
}

if ($agentsText -match [regex]::Escape($expectedVersion)) {
  Add-Result $results "PASS" "version-alignment" "AGENTS.md contains $expectedVersion"
} else {
  Add-Result $results "FAIL" "version-alignment" "AGENTS.md missing $expectedVersion"
}

$forbiddenMarkers = @(
  "Relational: PostgreSQL",
  "Document: MongoDB",
  "Cloud & Infrastructure:",
  "CI/CD: GitHub Actions",
  "Mobile: iOS",
  "Desktop: Windows"
)

foreach ($marker in $forbiddenMarkers) {
  if ($agentsText -match [regex]::Escape($marker)) {
    Add-Result $results "FAIL" "core-token-economy" "Broad catalog marker still present: $marker"
  } else {
    Add-Result $results "PASS" "core-token-economy" "Absent broad catalog marker: $marker"
  }
}

Test-Contains $results $agentsPath "Core Contract Drift Guard" "agents-core-guard"
Test-Contains $results $agentsPath "inter-agent-communication-bus-protocol\.md" "agents-communication-bus"
Test-Contains $results $frameworkPath "core_contract_drift_guard:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "core-contract:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "core-contract" "pre-release-check"
Test-Contains $results $translationMapPath "25-CORE-CONTRACT-DRIFT-GUARD.md" "translation-map-en"
Test-Contains $results $translationMapPath "25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md" "translation-map-pt-br"

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
