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
  ".agents/protocols/real-project-apply-scenario-protocol.md",
  ".agents/tools/test-real-project-apply-scenario.ps1",
  ".agents/tools/check-real-project-apply-scenario.ps1",
  ".agents/reports/executions/real-project-apply-scenario-template.md",
  ".agents/docs/en/16-REAL-PROJECT-APPLY-SCENARIO.md",
  ".agents/docs/pt-br/16-CENARIO-DE-APPLY-EM-PROJETO-REAL.md"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot $file
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "real_project_apply_scenario:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "real-apply-scenario:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/test-real-project-apply-scenario.ps1") "pre-apply-quality-gate" "pre-gate"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/test-real-project-apply-scenario.ps1") "post-apply-quality-gate" "post-gate"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/test-real-project-apply-scenario.ps1") "APPROVE_REAL_PROJECT_APPLY" "approval-token"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "real-project-apply-scenario" "pre-release-check"

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0

