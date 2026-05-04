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
  ".agents/protocols/command-allowlist-quality-gate-protocol.md",
  ".agents/tools/run-quality-gates.ps1",
  ".agents/tools/test-quality-gate-runner.ps1",
  ".agents/reports/executions/command-quality-gate-report-template.md",
  ".agents/docs/en/15-COMMAND-QUALITY-GATES.md",
  ".agents/docs/pt-br/15-COMANDOS-E-QUALITY-GATES.md"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $resolvedRoot $file
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $file
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $file"
  }
}

Test-Contains $results (Join-Path $resolvedRoot ".agents/config/framework.yaml") "command_allowlist_quality_gates:" "framework-config"
Test-Contains $results (Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml") "quality-gates:" "loading-group"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/run-quality-gates.ps1") "Test-DangerousCommand" "runner-denylist"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/run-quality-gates.ps1") "Read-AdapterCommands" "runner-adapter-parser"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/test-quality-gate-runner.ps1") "Remove-Item -Recurse -Force" "destructive-fixture"
Test-Contains $results (Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1") "command-allowlist" "pre-release-check"

$results | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0

