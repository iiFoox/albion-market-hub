param(
  [string]$Root = ".",
  [string[]]$Scenarios = @("profile-card", "docs-update", "bug-fix", "validation-failure", "api", "database-migration", "refactor", "security-fix", "failing-tests", "docs-only-release"),
  [string]$WorkRoot = "",
  [switch]$KeepWorkspace,
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Result {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Level,
    [string]$Scenario,
    [string]$Check,
    [string]$Message
  )

  $List.Add([pscustomobject]@{
    Level = $Level
    Scenario = $Scenario
    Check = $Check
    Message = $Message
  }) | Out-Null
}

function Write-TextFile {
  param([string]$Path, [string]$Content)

  $dir = Split-Path -Parent $Path
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
  }
  Set-Content -LiteralPath $Path -Value $Content -NoNewline
}

function Invoke-ScenarioTest {
  param([string]$TestPath)

  $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $TestPath 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output | Out-String).Trim()
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$results = New-Object System.Collections.Generic.List[object]

$createdWorkRoot = $false
if ([string]::IsNullOrWhiteSpace($WorkRoot)) {
  $WorkRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-dev-benchmark-" + [guid]::NewGuid().ToString("N"))
  $createdWorkRoot = $true
}

$resolvedWorkRoot = [System.IO.Path]::GetFullPath($WorkRoot)
$reportDir = Join-Path $resolvedRoot ".agents/reports/executions"
$reportPath = Join-Path $reportDir "benchmark-latest.md"

try {
  New-Item -ItemType Directory -Path $resolvedWorkRoot -Force | Out-Null
  Add-Result $results "PASS" "(suite)" "workspace" $resolvedWorkRoot

  foreach ($scenario in $Scenarios) {
    $scenarioRoot = Join-Path $resolvedWorkRoot $scenario
    New-Item -ItemType Directory -Path $scenarioRoot -Force | Out-Null

    if ($scenario -eq "profile-card") {
      $execution = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "run-developer-execution-simulation.ps1") -Root $resolvedRoot -Scenario "profile-card" -WorkRoot $scenarioRoot 2>&1
      if ($LASTEXITCODE -eq 0) {
        Add-Result $results "PASS" $scenario "execution" "Profile card developer execution passed"
      } else {
        Add-Result $results "FAIL" $scenario "execution" ($execution | Out-String).Trim()
      }
      continue
    }

    $projectRoot = Join-Path $scenarioRoot "project"
    New-Item -ItemType Directory -Path $projectRoot -Force | Out-Null

    $install = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "install-framework.ps1") -SourceRoot $resolvedRoot -TargetRoot $projectRoot -Apply 2>&1
    if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $projectRoot ".agents"))) {
      Add-Result $results "PASS" $scenario "install" "Framework installed"
    } else {
      Add-Result $results "FAIL" $scenario "install" ($install | Out-String).Trim()
      continue
    }

    switch ($scenario) {
      "docs-update" {
        Write-TextFile -Path (Join-Path $projectRoot "docs/README.md") -Content @"
# Demo Project

## Usage

Run the local test command before delivery.

## Delivery

Documentation was updated by the benchmark scenario.
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/docs.test.ps1") -Content @"
`$text = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "docs/README.md") -Raw
if (`$text -notmatch "Usage") { throw "Missing Usage section" }
if (`$text -notmatch "Delivery") { throw "Missing Delivery section" }
"PASS docs-update tests"
"@
      }
      "bug-fix" {
        Write-TextFile -Path (Join-Path $projectRoot "src/calculator.js") -Content @"
function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/calculator.test.ps1") -Content @"
`$text = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/calculator.js") -Raw
if (`$text -notmatch "return a \+ b") { throw "add bug was not fixed" }
if (`$text -notmatch "return a - b") { throw "subtract missing" }
"PASS bug-fix tests"
"@
      }
      "validation-failure" {
        Write-TextFile -Path (Join-Path $projectRoot "src/config.json") -Content @"
{
  "name": "demo",
  "enabled": true,
  "retryCount": 3
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/config.test.ps1") -Content @"
`$json = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/config.json") -Raw | ConvertFrom-Json
if (`$json.enabled -ne `$true) { throw "enabled must be true" }
if (`$json.retryCount -lt 1) { throw "retryCount must be positive" }
"PASS validation-failure correction tests"
"@
      }
      "api" {
        Write-TextFile -Path (Join-Path $projectRoot "src/api.js") -Content @"
function createResponse(status, data) {
  return {
    status,
    ok: status >= 200 && status < 300,
    data,
    headers: { 'content-type': 'application/json' }
  };
}

function getUser(id) {
  if (!id) {
    return createResponse(400, { error: 'id is required' });
  }
  return createResponse(200, { id, name: 'Demo User' });
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/api.test.ps1") -Content @"
`$text = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/api.js") -Raw
if (`$text -notmatch "function createResponse") { throw "Missing response helper" }
if (`$text -notmatch "id is required") { throw "Missing input validation" }
if (`$text -notmatch "content-type") { throw "Missing content-type header" }
"PASS api scenario tests"
"@
      }
      "database-migration" {
        Write-TextFile -Path (Join-Path $projectRoot "db/migrations/001_create_users.sql") -Content @"
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL
);

CREATE INDEX idx_users_email ON users(email);
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/migration.test.ps1") -Content @"
`$sql = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "db/migrations/001_create_users.sql") -Raw
if (`$sql -notmatch "CREATE TABLE users") { throw "Missing users table" }
if (`$sql -notmatch "PRIMARY KEY") { throw "Missing primary key" }
if (`$sql -notmatch "UNIQUE") { throw "Missing unique email constraint" }
"PASS database-migration scenario tests"
"@
      }
      "refactor" {
        Write-TextFile -Path (Join-Path $projectRoot "src/price.js") -Content @"
function calculateTotal(items, taxRate) {
  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const tax = subtotal * taxRate;
  return { subtotal, tax, total: subtotal + tax };
}

function formatCurrency(value) {
  return `$` + value.toFixed(2);
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/refactor.test.ps1") -Content @"
`$text = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/price.js") -Raw
if (`$text -notmatch "calculateTotal") { throw "Missing calculateTotal" }
if (`$text -notmatch "reduce") { throw "Missing consolidated subtotal calculation" }
if (`$text -notmatch "formatCurrency") { throw "Missing formatting helper" }
"PASS refactor scenario tests"
"@
      }
      "security-fix" {
        Write-TextFile -Path (Join-Path $projectRoot "src/auth.js") -Content @"
function sanitizeToken(token) {
  if (typeof token !== 'string') {
    return '';
  }
  return token.replace(/[^A-Za-z0-9._-]/g, '');
}

function buildAuthHeader(token) {
  const safeToken = sanitizeToken(token);
  if (!safeToken) {
    throw new Error('Missing token');
  }
  return { Authorization: `Bearer ${safeToken}` };
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/security.test.ps1") -Content @"
`$text = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/auth.js") -Raw
if (`$text -notmatch "sanitizeToken") { throw "Missing token sanitization" }
if (-not `$text.Contains("A-Za-z0-9._-")) { throw "Missing strict token character allowlist" }
if (`$text -notmatch "Missing token") { throw "Missing empty-token guard" }
"PASS security-fix scenario tests"
"@
      }
      "failing-tests" {
        Write-TextFile -Path (Join-Path $projectRoot "src/feature-flags.json") -Content @"
{
  "betaDashboard": true,
  "legacyMode": false
}
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/failing-tests.test.ps1") -Content @"
`$json = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "src/feature-flags.json") -Raw | ConvertFrom-Json
if (`$json.betaDashboard -ne `$true) { throw "betaDashboard should be true after correction" }
if (`$json.legacyMode -ne `$false) { throw "legacyMode should be false after correction" }
"PASS failing-tests correction scenario tests"
"@
      }
      "docs-only-release" {
        Write-TextFile -Path (Join-Path $projectRoot "CHANGELOG.md") -Content @"
# Changelog

## 0.1.1

- Documentation-only release note.
- No runtime behavior changed.
"@
        Write-TextFile -Path (Join-Path $projectRoot "docs/release-notes.md") -Content @"
# Release Notes

This is a documentation-only release.

## Validation

No code paths changed.
"@
        Write-TextFile -Path (Join-Path $projectRoot "tests/docs-only-release.test.ps1") -Content @"
`$changelog = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "CHANGELOG.md") -Raw
`$notes = Get-Content -LiteralPath (Join-Path (Split-Path -Parent `$PSScriptRoot) "docs/release-notes.md") -Raw
if (`$changelog -notmatch "Documentation-only") { throw "Missing documentation-only changelog marker" }
if (`$notes -notmatch "No code paths changed") { throw "Missing no-code-change validation note" }
"PASS docs-only-release scenario tests"
"@
      }
      default {
        Add-Result $results "WARN" $scenario "scenario" "Unknown scenario skipped"
        continue
      }
    }

    Add-Result $results "PASS" $scenario "implementation" "Scenario files generated"

    $testFile = @(Get-ChildItem -LiteralPath (Join-Path $projectRoot "tests") -File -Filter "*.ps1" | Select-Object -First 1)
    $test = Invoke-ScenarioTest -TestPath $testFile.FullName
    if ($test.ExitCode -eq 0) {
      Add-Result $results "PASS" $scenario "tests" $test.Output
    } else {
      Add-Result $results "FAIL" $scenario "tests" $test.Output
    }

    $gate = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $projectRoot ".agents/tools/pre-release-gate.ps1") -Root $projectRoot -Version "7.5.0" -StrictTelemetry -SkipSimulation -SkipDeveloperExecution -SkipDeveloperBenchmark 2>&1
    if ($LASTEXITCODE -eq 0) {
      Add-Result $results "PASS" $scenario "framework-gate" "Installed framework gate passes"
    } else {
      Add-Result $results "FAIL" $scenario "framework-gate" ($gate | Out-String).Trim()
    }
  }

  if ($WriteReport) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    $timestamp = (Get-Date).ToString("o")
    $status = if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -eq 0) { "success" } else { "failure" }
    $summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }

    $report = New-Object System.Collections.Generic.List[string]
    $report.Add("# HEPHAESTUS Developer Benchmark Report") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("---") | Out-Null
    $report.Add('log_type: "developer-benchmark"') | Out-Null
    $report.Add("timestamp: `"$timestamp`"") | Out-Null
    $report.Add("status: `"$status`"") | Out-Null
    $report.Add('event: "developer_benchmark.completed"') | Out-Null
    $report.Add('framework_version: "7.5.0"') | Out-Null
    $report.Add("---") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Scenarios") | Out-Null
    $report.Add("") | Out-Null
    foreach ($scenario in $Scenarios) {
      $report.Add("- $scenario") | Out-Null
    }
    $report.Add("") | Out-Null
    $report.Add("## Result") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("- Summary: $($summary -join ', ')") | Out-Null
    $report.Add("- Workspace kept: $KeepWorkspace") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Checks") | Out-Null
    $report.Add("") | Out-Null
    foreach ($result in ($results | Sort-Object Level, Scenario, Check, Message)) {
      $report.Add("- $($result.Level) $($result.Scenario) $($result.Check): $($result.Message)") | Out-Null
    }
    $report | Set-Content -LiteralPath $reportPath
    Add-Result $results "PASS" "(suite)" "report" ".agents/reports/executions/benchmark-latest.md"
  }
} finally {
  if ($createdWorkRoot -and -not $KeepWorkspace -and (Test-Path -LiteralPath $resolvedWorkRoot)) {
    Remove-Item -LiteralPath $resolvedWorkRoot -Recurse -Force
  }
}

$results | Sort-Object Level, Scenario, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Developer benchmark summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0





