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
  ".agents/protocols/project-bootstrap-assistant-protocol.md",
  ".agents/tools/run-project-bootstrap.ps1",
  ".agents/tools/check-project-bootstrap.ps1",
  ".agents/reports/adapters/project-bootstrap-template.md",
  ".agents/docs/en/27-PROJECT-BOOTSTRAP-ASSISTANT.md",
  ".agents/docs/pt-br/27-ASSISTENTE-DE-BOOTSTRAP-DE-PROJETO.md"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot ($file -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1") '"bootstrap"' "cli-action-bootstrap"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "project_bootstrap_assistant:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "project-bootstrap:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "project-bootstrap" "pre-release-check"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "27-PROJECT-BOOTSTRAP-ASSISTANT.md" "translation-map-en"
Test-Contains $results (Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml") "27-ASSISTENTE-DE-BOOTSTRAP-DE-PROJETO.md" "translation-map-pt-br"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/run-project-bootstrap.ps1") "Project Discovery remains the source" "discovery-bridge"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/run-project-bootstrap.ps1") "Real Project Adapter remains the source" "adapter-bridge"

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
