param(
  [string]$Root = ".",
  [string]$Version = "",
  [string]$PackagePath = "",
  [switch]$StrictTelemetry,
  [switch]$SkipSimulation,
  [switch]$SkipDeveloperExecution,
  [switch]$SkipDeveloperBenchmark
)

$ErrorActionPreference = "Stop"

function Add-GateResult {
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

function Invoke-GateScript {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Name,
    [string]$ScriptPath,
    [string[]]$Arguments = @()
  )

  if (-not (Test-Path -LiteralPath $ScriptPath)) {
    Add-GateResult $List "FAIL" $Name "Missing $ScriptPath"
    return
  }

  $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $ScriptPath @Arguments 2>&1
  $exitCode = $LASTEXITCODE

  if ($exitCode -eq 0) {
    Add-GateResult $List "PASS" $Name "Exit=0"
  } else {
    Add-GateResult $List "FAIL" $Name "Exit=$exitCode"
  }

  $summary = @($output | Where-Object { $_ -match "^Summary:" } | Select-Object -Last 1)
  if ($summary.Count -gt 0) {
    Add-GateResult $List "INFO" "$Name-summary" $summary[0].ToString()
  }
}

function Get-ManifestRequiredFiles {
  param([string]$ManifestPath)

  $items = New-Object System.Collections.Generic.List[string]
  $inSection = $false
  $lines = Get-Content -LiteralPath $ManifestPath

  foreach ($line in $lines) {
    if ($line -match "^required_files:\s*$") {
      $inSection = $true
      continue
    }

    if ($inSection -and $line -match "^[A-Za-z0-9_-]+:\s*") {
      break
    }

    if ($inSection -and $line -match '^\s*-\s+"?([^"]+)"?\s*$') {
      $items.Add($Matches[1]) | Out-Null
    }
  }

  return $items
}

function Test-Package {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$ResolvedRoot,
    [string]$PackagePath,
    [string]$ManifestPath,
    [string]$Version
  )

  $resolvedPackage = $PackagePath
  if (-not [System.IO.Path]::IsPathRooted($resolvedPackage)) {
    $resolvedPackage = Join-Path $ResolvedRoot $resolvedPackage
  }

  if (-not (Test-Path -LiteralPath $resolvedPackage)) {
    Add-GateResult $List "FAIL" "package" "Missing package $PackagePath"
    return
  }

  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $archive = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $resolvedPackage).Path)

  try {
    $entries = @($archive.Entries | ForEach-Object { $_.FullName.Replace("\", "/") })
    $missing = New-Object System.Collections.Generic.List[string]
    foreach ($required in (Get-ManifestRequiredFiles $ManifestPath)) {
      $normalized = $required.Replace("\", "/")
      $withoutRoot = $normalized -replace "^\.agents/", ""
      $hasEntry = $entries -contains $normalized -or $entries -contains $withoutRoot
      if (-not $hasEntry) {
        $missing.Add($required) | Out-Null
      }
    }

    if ($missing.Count -eq 0) {
      Add-GateResult $List "PASS" "package-required-files" "All manifest required files are present"
    } else {
      Add-GateResult $List "FAIL" "package-required-files" "Missing: $($missing -join ', ')"
    }

    if (-not [string]::IsNullOrWhiteSpace($Version)) {
      $releaseEntry = @($entries | Where-Object { $_ -eq "releases/v$Version.md" -or $_ -eq ".agents/releases/v$Version.md" })
      if ($releaseEntry.Count -gt 0) {
        Add-GateResult $List "PASS" "package-release-note" "Found release note v$Version"
      } else {
        Add-GateResult $List "FAIL" "package-release-note" "Missing releases/v$Version.md"
      }
    }
  } finally {
    $archive.Dispose()
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$manifestPath = Join-Path $resolvedRoot ".agents/config/framework-manifest.yaml"
$results = New-Object System.Collections.Generic.List[object]

Invoke-GateScript $results "framework-integrity" (Join-Path $toolsRoot "validate-framework.ps1") @("-Root", $resolvedRoot, "-StrictReferences")
Invoke-GateScript $results "kernel-contract" (Join-Path $toolsRoot "check-kernel-contract.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "agent-mastery" (Join-Path $toolsRoot "check-agent-mastery.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "documentation-enforcement" (Join-Path $toolsRoot "check-documentation-enforcement.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "documentation-runtime-loop" (Join-Path $toolsRoot "check-documentation-runtime-loop.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "release-evidence-bundle" (Join-Path $toolsRoot "check-release-evidence-bundle.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "operational-score-review" (Join-Path $toolsRoot "check-operational-score-review.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "install-update-wizard" (Join-Path $toolsRoot "check-install-update-wizard.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "memory-proof" (Join-Path $toolsRoot "check-memory-proof.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "operator-experience" (Join-Path $toolsRoot "check-operator-experience.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "communication-bus" (Join-Path $toolsRoot "check-communication-bus.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "unified-cli" (Join-Path $toolsRoot "check-unified-cli.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "core-contract" (Join-Path $toolsRoot "check-core-contract.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "operator-daily-launcher" (Join-Path $toolsRoot "check-operator-daily-launcher.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "project-bootstrap" (Join-Path $toolsRoot "check-project-bootstrap.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "stability-baseline" (Join-Path $toolsRoot "check-stability-baseline.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "operator-runbook" (Join-Path $toolsRoot "check-operator-runbook.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "guided-installer" (Join-Path $toolsRoot "check-guided-installer.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "first-project-walkthrough" (Join-Path $toolsRoot "check-first-project-walkthrough.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "project-discovery" (Join-Path $toolsRoot "check-project-discovery.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "real-project-adapter" (Join-Path $toolsRoot "check-real-project-adapter.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "real-project-execution" (Join-Path $toolsRoot "check-real-project-execution.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "real-project-hardening" (Join-Path $toolsRoot "check-real-project-hardening.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "command-allowlist" (Join-Path $toolsRoot "check-command-allowlist.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "real-project-apply-scenario" (Join-Path $toolsRoot "check-real-project-apply-scenario.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "documentation-parity" (Join-Path $toolsRoot "check-doc-parity.ps1") @("-Root", $resolvedRoot)

$telemetryArgs = @("-Root", $resolvedRoot)
if ($StrictTelemetry) {
  $telemetryArgs += "-Strict"
}
Invoke-GateScript $results "telemetry" (Join-Path $toolsRoot "validate-telemetry.ps1") $telemetryArgs
Invoke-GateScript $results "routing" (Join-Path $toolsRoot "test-routing.ps1") @("-Root", $resolvedRoot)
Invoke-GateScript $results "installation-tools" (Join-Path $toolsRoot "test-installation-tools.ps1") @("-Root", $resolvedRoot)
if (-not $SkipSimulation -and [string]::IsNullOrWhiteSpace($PackagePath)) {
  Invoke-GateScript $results "simulation-harness" (Join-Path $toolsRoot "test-simulation-harness.ps1") @("-Root", $resolvedRoot)
}
if (-not $SkipDeveloperExecution -and [string]::IsNullOrWhiteSpace($PackagePath)) {
  Invoke-GateScript $results "developer-execution" (Join-Path $toolsRoot "test-developer-execution-mode.ps1") @("-Root", $resolvedRoot)
}
if (-not $SkipDeveloperBenchmark -and [string]::IsNullOrWhiteSpace($PackagePath)) {
  Invoke-GateScript $results "developer-benchmark" (Join-Path $toolsRoot "test-developer-benchmark.ps1") @("-Root", $resolvedRoot)
}
if ([string]::IsNullOrWhiteSpace($PackagePath)) {
  Invoke-GateScript $results "real-project-execution-test" (Join-Path $toolsRoot "test-real-project-execution.ps1") @("-Root", $resolvedRoot)
  Invoke-GateScript $results "quality-gate-runner" (Join-Path $toolsRoot "test-quality-gate-runner.ps1") @("-Root", $resolvedRoot)
  Invoke-GateScript $results "real-project-apply-scenario-test" (Join-Path $toolsRoot "test-real-project-apply-scenario.ps1") @("-Root", $resolvedRoot)
  Invoke-GateScript $results "documentation-runtime-loop-test" (Join-Path $toolsRoot "test-documentation-runtime-loop.ps1") @("-Root", $resolvedRoot)
  Invoke-GateScript $results "release-evidence-bundle-test" (Join-Path $toolsRoot "test-release-evidence-bundle.ps1") @("-Root", $resolvedRoot)
  Invoke-GateScript $results "operational-score-review-run" (Join-Path $toolsRoot "run-operational-score-review.ps1") @("-Root", $resolvedRoot, "-WriteReport")
  Invoke-GateScript $results "memory-proof-run" (Join-Path $toolsRoot "run-memory-proof.ps1") @("-Root", $resolvedRoot, "-WriteReport")
  Invoke-GateScript $results "operator-experience-run" (Join-Path $toolsRoot "run-operator-experience-review.ps1") @("-Root", $resolvedRoot, "-WriteReport")
  Invoke-GateScript $results "communication-bus-run" (Join-Path $toolsRoot "run-communication-bus-proof.ps1") @("-Root", $resolvedRoot, "-WriteReport")
  Invoke-GateScript $results "stability-baseline-run" (Join-Path $toolsRoot "run-stability-baseline.ps1") @("-Root", $resolvedRoot, "-WriteReport")
}
$healthArgs = @("-Root", $resolvedRoot)
if ([string]::IsNullOrWhiteSpace($PackagePath)) {
  $healthArgs += "-WriteReport"
}
Invoke-GateScript $results "health" (Join-Path $toolsRoot "framework-health.ps1") $healthArgs
Invoke-GateScript $results "loading-lite" (Join-Path $toolsRoot "estimate-loading.ps1") @("-Root", $resolvedRoot, "-Tier", "lite")
Invoke-GateScript $results "loading-standard" (Join-Path $toolsRoot "estimate-loading.ps1") @("-Root", $resolvedRoot, "-Tier", "standard", "-IncludeGroups", "ui", "flutter")
Invoke-GateScript $results "loading-deep" (Join-Path $toolsRoot "estimate-loading.ps1") @("-Root", $resolvedRoot, "-Tier", "deep", "-IncludeGroups", "platform")
Invoke-GateScript $results "loading-critical" (Join-Path $toolsRoot "estimate-loading.ps1") @("-Root", $resolvedRoot, "-Tier", "critical", "-IncludeGroups", "docs", "release", "database", "api", "resilience", "quality-gates", "real-apply-scenario", "documentation-runtime", "release-evidence", "operational-review", "install-update-wizard", "memory-proof", "operator-experience", "communication-bus", "operator-cli", "core-contract", "operator-daily", "project-bootstrap", "stability-baseline", "operator-runbook", "guided-installer", "first-project-walkthrough")

if (-not [string]::IsNullOrWhiteSpace($PackagePath)) {
  Test-Package $results $resolvedRoot $PackagePath $manifestPath $Version
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Pre-release gate summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0
