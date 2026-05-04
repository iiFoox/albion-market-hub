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
$runner = Join-Path $resolvedRoot ".agents/tools/run-quality-gates.ps1"
$results = New-Object System.Collections.Generic.List[object]
$fixture = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-quality-gates-" + [guid]::NewGuid().ToString("N"))

try {
  New-Item -ItemType Directory -Path (Join-Path $fixture ".agents/config") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixture ".agents/reports/executions") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $fixture "tests") -Force | Out-Null

  Set-Content -LiteralPath (Join-Path $fixture "tests/quality.test.ps1") -Value @(
    '$ErrorActionPreference = "Stop"',
    'if (-not (Test-Path -LiteralPath "README.md")) { throw "README missing" }',
    'Write-Host "fixture quality pass"'
  ) -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $fixture "README.md") -Value "# Fixture" -Encoding UTF8

  Set-Content -LiteralPath (Join-Path $fixture ".agents/config/project.yaml") -Value @(
    'project:',
    '  id: "quality-gate-fixture"',
    '  name: "Quality Gate Fixture"',
    '  root: "."',
    '',
    'commands:',
    '  test:',
    '    command: "powershell -NoProfile -ExecutionPolicy Bypass -File tests/quality.test.ps1"',
    '    allowed: true',
    '  lint:',
    '    command: ""',
    '    allowed: false',
    '',
    'execution:',
    '  allow_destructive_commands: false'
  ) -Encoding UTF8

  $passOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $runner -Root $fixture -GateNames test -WriteReport 2>&1
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $fixture ".agents/reports/executions/quality-gates-latest.md"))) {
    $report = Get-Content -LiteralPath (Join-Path $fixture ".agents/reports/executions/quality-gates-latest.md") -Raw
    if ($report.Contains('log_type: "command-quality-gates"') -and $report.Contains('framework_version: "7.5.0"') -and $report.Contains('| test | PASS | 0 |')) {
      Add-Result $results "PASS" "allowed-command-fixture" "Allowed test gate executed and reported"
    } else {
      Add-Result $results "FAIL" "allowed-command-fixture" "Report content missing expected markers"
    }
  } else {
    Add-Result $results "FAIL" "allowed-command-fixture" "Allowed test gate failed: $($passOutput -join ' ')"
  }

  Set-Content -LiteralPath (Join-Path $fixture ".agents/config/project.yaml") -Value @(
    'project:',
    '  id: "quality-gate-fixture"',
    '  name: "Quality Gate Fixture"',
    '  root: "."',
    '',
    'commands:',
    '  test:',
    '    command: "Remove-Item -Recurse -Force ."',
    '    allowed: true',
    '',
    'execution:',
    '  allow_destructive_commands: false'
  ) -Encoding UTF8

  $denyOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $runner -Root $fixture -GateNames test -WriteReport 2>&1
  if ($LASTEXITCODE -ne 0 -and (($denyOutput -join "`n") -match "DENIED")) {
    Add-Result $results "PASS" "destructive-command-denial" "Destructive command was denied"
  } else {
    Add-Result $results "FAIL" "destructive-command-denial" "Destructive command was not denied"
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





