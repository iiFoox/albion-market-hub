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

function Test-File {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Root,
    [string]$RelativePath
  )

  $path = Join-Path $Root ($RelativePath -replace "/", "\")
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $Results "PASS" "required-file" $RelativePath
    return
  }

  Add-Result $Results "FAIL" "required-file" "Missing $RelativePath"
}

function Test-Contains {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Path,
    [string]$Pattern,
    [string]$Check
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
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
  ".agents/protocols/operator-runbook-recovery-protocol.md",
  ".agents/tools/check-operator-runbook.ps1",
  ".agents/docs/en/29-OPERATOR-RUNBOOK-RECOVERY.md",
  ".agents/docs/pt-br/29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md"
)

foreach ($file in $requiredFiles) {
  Test-File $results $resolvedRoot $file
}

$framework = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$loading = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$gate = Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1"
$cli = Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1"
$map = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"
$enGuide = Join-Path $resolvedRoot ".agents/docs/en/29-OPERATOR-RUNBOOK-RECOVERY.md"
$ptGuide = Join-Path $resolvedRoot ".agents/docs/pt-br/29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md"

Test-Contains $results $framework "operator_runbook_recovery:" "framework-config"
Test-Contains $results $framework "check-operator-runbook.ps1" "framework-checker"
Test-Contains $results $framework "operator-runbook-recovery-protocol.md" "framework-protocol"
Test-Contains $results $loading "operator-runbook:" "loading-group"
Test-Contains $results $gate "operator-runbook" "pre-release-check"
Test-Contains $results $cli "check-operator-runbook.ps1" "doctor-check"
Test-Contains $results $map "29-OPERATOR-RUNBOOK-RECOVERY.md" "translation-map-en"
Test-Contains $results $map "29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md" "translation-map-pt-br"

$actions = @("doctor", "validate", "gate", "package", "evidence", "install", "update", "daily", "bootstrap")
foreach ($action in $actions) {
  Test-Contains $results $enGuide "-Action $action" "en-action-$action"
  Test-Contains $results $ptGuide "-Action $action" "pt-br-action-$action"
}

$recoveryMarkers = @(
  "failed validation",
  "failed validation, gate, package, install, or update",
  "package gate",
  "documentation parity",
  "dry-run"
)

foreach ($marker in $recoveryMarkers) {
  Test-Contains $results $enGuide ([regex]::Escape($marker)) "en-recovery-$marker"
}

Test-Contains $results $ptGuide "gate do pacote" "pt-br-package-gate"
Test-Contains $results $ptGuide "paridade documental" "pt-br-doc-parity"
Test-Contains $results $ptGuide "dry-run" "pt-br-dry-run"

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0

