param(
  [string]$Root = ".",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

$resolvedRoot = (Resolve-Path $Root).Path
$agentsRoot = Join-Path $resolvedRoot ".agents"
$frameworkConfigPath = Join-Path $agentsRoot "config/framework.yaml"
$frameworkVersion = "unknown"
if (Test-Path -LiteralPath $frameworkConfigPath) {
  $frameworkConfigText = Get-Content -LiteralPath $frameworkConfigPath -Raw
  if ($frameworkConfigText -match 'version:\s*"([^"]+)"') {
    $frameworkVersion = $Matches[1]
  }
}
$score = 100
$findings = New-Object System.Collections.Generic.List[string]

function Invoke-Check {
  param([string]$Command)
  $output = & powershell -ExecutionPolicy Bypass -Command $Command 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output | Out-String)
  }
}

if (-not (Test-Path -LiteralPath $agentsRoot)) {
  throw "Missing .agents directory."
}

$integrity = Invoke-Check ".agents/tools/validate-framework.ps1 -StrictReferences"
if ($integrity.ExitCode -ne 0) {
  $score -= 30
  $findings.Add("Integrity validation failed.") | Out-Null
} else {
  $findings.Add("Integrity validation passed.") | Out-Null
}

$telemetry = Invoke-Check ".agents/tools/validate-telemetry.ps1"
if ($telemetry.ExitCode -ne 0) {
  $score -= 20
  $findings.Add("Telemetry validation failed.") | Out-Null
} elseif ($telemetry.Output -match "WARN=") {
  $score -= 5
  $findings.Add("Telemetry validation passed with warnings.") | Out-Null
} else {
  $findings.Add("Telemetry validation passed.") | Out-Null
}

$loading = Invoke-Check ".agents/tools/estimate-loading.ps1 -Tier lite"
if ($loading.ExitCode -ne 0) {
  $score -= 15
  $findings.Add("LITE loading estimate failed.") | Out-Null
} else {
  $findings.Add("LITE loading estimate passed.") | Out-Null
}

$checkpoint = Join-Path $agentsRoot "memory/context-db/session-checkpoint.md"
if (-not (Test-Path -LiteralPath $checkpoint)) {
  $score -= 10
  $findings.Add("Session checkpoint missing.") | Out-Null
} else {
  $findings.Add("Session checkpoint exists.") | Out-Null
}

$logs = @(Get-ChildItem -LiteralPath (Join-Path $agentsRoot "telemetry/logs") -Recurse -File -Filter "*.md" -ErrorAction SilentlyContinue)
if ($logs.Count -eq 0) {
  $score -= 5
  $findings.Add("No telemetry logs found.") | Out-Null
} else {
  $findings.Add("Telemetry logs found: $($logs.Count).") | Out-Null
}

if ($score -lt 0) { $score = 0 }
$status = if ($score -ge 90) { "HEALTHY" } elseif ($score -ge 70) { "WARNING" } else { "CRITICAL" }

$findingLines = ($findings | ForEach-Object { "- $_" }) -join "`n"
$report = @(
  "# HEPHAESTUS Health Report",
  "",
  "---",
  'log_type: "health"',
  ('timestamp: "' + (Get-Date -Format o) + '"'),
  ('status: "' + $status.ToLower() + '"'),
  "framework_version: `"$frameworkVersion`"",
  "---",
  "",
  "## Score",
  "",
  "$score/100 - $status",
  "",
  "## Findings",
  "",
  $findingLines,
  "",
  "## Validation Summary",
  "",
  "### Integrity",
  "",
  '```text',
  $integrity.Output.Trim(),
  '```',
  "",
  "### Telemetry",
  "",
  '```text',
  $telemetry.Output.Trim(),
  '```',
  "",
  "### Loading",
  "",
  '```text',
  $loading.Output.Trim(),
  '```'
) -join "`n"

Write-Host "HEPHAESTUS HEALTH: $score/100 - $status"
$findings | ForEach-Object { Write-Host "- $_" }

if ($WriteReport) {
  $reportDir = Join-Path $agentsRoot "reports/health"
  New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
  $reportPath = Join-Path $reportDir "latest.md"
  Set-Content -LiteralPath $reportPath -Value $report -Encoding UTF8
  Write-Host "Report written: .agents/reports/health/latest.md"
}

if ($score -lt 70) {
  exit 1
}

exit 0
