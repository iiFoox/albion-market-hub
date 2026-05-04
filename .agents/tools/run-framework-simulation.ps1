param(
  [string]$Root = ".",
  [string]$Scenario = "ui-feature",
  [string]$WorkRoot = "",
  [switch]$KeepWorkspace,
  [switch]$WriteReport
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
  param([string[]]$Lines, [string]$Key)

  foreach ($line in $Lines) {
    if ($line -match "^\s*$([regex]::Escape($Key)):\s*`"?([^`"]+)`"?\s*$") {
      return $Matches[1].Trim()
    }
  }

  return ""
}

function Get-SectionScalar {
  param([string[]]$Lines, [string]$Section, [string]$Key)

  $inSection = $false
  $indent = $null
  foreach ($line in $Lines) {
    if ($line -match "^(\s*)$([regex]::Escape($Section)):\s*$") {
      $inSection = $true
      $indent = $Matches[1].Length
      continue
    }

    if ($inSection) {
      if ($line -match "^(\s*)[A-Za-z0-9_-]+:\s*" -and $Matches[1].Length -le $indent) {
        break
      }
      if ($line -match "^\s*$([regex]::Escape($Key)):\s*`"?([^`"]+)`"?\s*$") {
        return $Matches[1].Trim()
      }
    }
  }

  return ""
}

function Get-SectionList {
  param([string[]]$Lines, [string]$SectionPath)

  $items = New-Object System.Collections.Generic.List[string]
  $stack = @{}
  $capture = $false
  $captureIndent = $null

  foreach ($line in $Lines) {
    if ($line -match '^(\s*)([A-Za-z0-9_-]+):\s*$') {
      $indent = $Matches[1].Length
      $name = $Matches[2]
      $stack[$indent] = $name
      foreach ($key in @($stack.Keys)) {
        if ([int]$key -gt $indent) { $stack.Remove($key) }
      }

      $path = ($stack.Keys | Sort-Object {[int]$_} | ForEach-Object { $stack[$_] }) -join "."
      if ($path -eq $SectionPath) {
        $capture = $true
        $captureIndent = $indent
        continue
      }
      if ($capture -and $indent -le $captureIndent) {
        $capture = $false
      }
    } elseif ($capture -and $line -match '^\s*-\s+"?([^"]+)"?\s*$') {
      $items.Add($Matches[1]) | Out-Null
    }
  }

  return $items
}

function Invoke-Captured {
  param([string]$Command)

  $output = & powershell -NoProfile -ExecutionPolicy Bypass -Command $Command 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output | Out-String).Trim()
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$fixturePath = Join-Path $resolvedRoot ".agents/tests/fixtures/$Scenario.yaml"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $fixturePath)) {
  Add-Result $results "FAIL" "scenario" "Missing fixture .agents/tests/fixtures/$Scenario.yaml"
  $results | Format-Table -AutoSize
  exit 1
}

$createdWorkRoot = $false
if ([string]::IsNullOrWhiteSpace($WorkRoot)) {
  $WorkRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-simulation-" + [guid]::NewGuid().ToString("N"))
  $createdWorkRoot = $true
}

$resolvedWorkRoot = [System.IO.Path]::GetFullPath($WorkRoot)
$targetProject = Join-Path $resolvedWorkRoot "simulated-project"
$scenarioDir = Join-Path $targetProject "simulation"
$reportDir = Join-Path $resolvedRoot ".agents/reports/simulations"
$reportPath = Join-Path $reportDir "latest.md"

try {
  New-Item -ItemType Directory -Path $scenarioDir -Force | Out-Null

  $lines = Get-Content -LiteralPath $fixturePath
  $request = Get-Scalar $lines "request"
  $expectedLevel = Get-SectionScalar $lines "expected" "min_level"
  $expectedWorkflow = Get-SectionScalar $lines "expected" "workflow"
  $requiredAgents = @(Get-SectionList $lines "expected.required_agents")

  @(
    "# Simulated Project Request",
    "",
    "Scenario: $Scenario",
    "",
    "Request:",
    "",
    $request
  ) | Set-Content -LiteralPath (Join-Path $scenarioDir "request.md")

  Add-Result $results "PASS" "workspace" $resolvedWorkRoot

  $install = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "install-framework.ps1") -SourceRoot $resolvedRoot -TargetRoot $targetProject -Apply 2>&1
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $targetProject ".agents"))) {
    Add-Result $results "PASS" "install" "Framework installed into isolated workspace"
  } else {
    Add-Result $results "FAIL" "install" ($install | Out-String).Trim()
  }

  $compare = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "compare-framework-version.ps1") -SourceRoot $resolvedRoot -TargetRoot $targetProject 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "version-compare" "Installed framework version is readable"
  } else {
    Add-Result $results "FAIL" "version-compare" ($compare | Out-String).Trim()
  }

  $routing = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $targetProject ".agents/tools/test-routing.ps1") -Root $targetProject 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "routing-suite" "Routing fixtures pass in isolated workspace"
  } else {
    Add-Result $results "FAIL" "routing-suite" ($routing | Out-String).Trim()
  }

  $loading = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $targetProject ".agents/tools/estimate-loading.ps1") -Root $targetProject -Tier standard -IncludeGroups "ui","flutter" 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "loading-estimate" "STANDARD loading estimate executed"
  } else {
    Add-Result $results "FAIL" "loading-estimate" ($loading | Out-String).Trim()
  }

  $gate = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $targetProject ".agents/tools/pre-release-gate.ps1") -Root $targetProject -Version "7.5.0" -StrictTelemetry -SkipSimulation -SkipDeveloperExecution -SkipDeveloperBenchmark 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "isolated-gate" "Pre-release gate passes in isolated workspace"
  } else {
    Add-Result $results "FAIL" "isolated-gate" ($gate | Out-String).Trim()
  }

  Add-Result $results "INFO" "expected-level" $expectedLevel
  Add-Result $results "INFO" "expected-workflow" $expectedWorkflow
  Add-Result $results "INFO" "expected-agents" ($requiredAgents -join ",")

  if ($WriteReport) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    $timestamp = (Get-Date).ToString("o")
    $status = if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -eq 0) { "success" } else { "failure" }
    $summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }

    $report = New-Object System.Collections.Generic.List[string]
    $report.Add("# HEPHAESTUS Simulation Report") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("---") | Out-Null
    $report.Add('log_type: "simulation"') | Out-Null
    $report.Add("timestamp: `"$timestamp`"") | Out-Null
    $report.Add("status: `"$status`"") | Out-Null
    $report.Add('event: "simulation.completed"') | Out-Null
    $report.Add('framework_version: "7.5.0"') | Out-Null
    $report.Add("---") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Scenario") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("- Scenario: $Scenario") | Out-Null
    $report.Add("- Expected level: $expectedLevel") | Out-Null
    $report.Add("- Expected workflow: $expectedWorkflow") | Out-Null
    $report.Add("- Expected agents: $($requiredAgents -join ', ')") | Out-Null
    $report.Add("- Workspace kept: $KeepWorkspace") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Result") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("- Summary: $($summary -join ', ')") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Checks") | Out-Null
    $report.Add("") | Out-Null
    foreach ($result in ($results | Sort-Object Level, Check, Message)) {
      $report.Add("- $($result.Level) $($result.Check): $($result.Message)") | Out-Null
    }
    $report | Set-Content -LiteralPath $reportPath
    Add-Result $results "PASS" "report" ".agents/reports/simulations/latest.md"
  }
} finally {
  if ($createdWorkRoot -and -not $KeepWorkspace -and (Test-Path -LiteralPath $resolvedWorkRoot)) {
    Remove-Item -LiteralPath $resolvedWorkRoot -Recurse -Force
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Simulation summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0





