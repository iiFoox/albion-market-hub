param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("doctor","validate","gate","package","evidence","compare","install","update","daily","bootstrap")]
  [string]$Action,

  [string]$Root = ".",
  [string]$SourceRoot = ".",
  [string]$TargetRoot = "",
  [string]$Version = "",
  [string]$PackagePath = "",
  [ValidateSet("none","local","github","gitlab","bitbucket","other","existing")]
  [string]$RepositoryMode = "none",
  [string]$RemoteUrl = "",
  [string]$DefaultBranch = "main",
  [ValidateSet("start","validate","release")]
  [string]$DailyMode = "start",
  [switch]$OpenFirstCall,
  [switch]$Apply,
  [switch]$StrictTelemetry,
  [switch]$SkipSimulation,
  [switch]$SkipDeveloperExecution,
  [switch]$SkipDeveloperBenchmark
)

$ErrorActionPreference = "Stop"

function Invoke-Tool {
  param(
    [string]$Script,
    [string[]]$Arguments
  )

  if (-not (Test-Path -LiteralPath $Script)) {
    Write-Error "Missing tool: $Script"
    exit 1
  }

  & powershell -NoProfile -ExecutionPolicy Bypass -File $Script @Arguments
  exit $LASTEXITCODE
}

function Get-FrameworkVersion {
  param([string]$ResolvedRoot)

  $manifestPath = Join-Path $ResolvedRoot ".agents/config/framework-manifest.yaml"
  if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw
    if ($manifest -match 'framework_version:\s*"([^"]+)"') {
      return $Matches[1]
    }
  }

  return "unknown"
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$resolvedVersion = if ([string]::IsNullOrWhiteSpace($Version)) { Get-FrameworkVersion $resolvedRoot } else { $Version }

switch ($Action) {
  "doctor" {
    $checks = @(
      "validate-framework.ps1",
      "check-doc-parity.ps1",
      "check-kernel-contract.ps1",
      "check-install-update-wizard.ps1",
      "check-operator-experience.ps1",
      "check-communication-bus.ps1",
      "check-core-contract.ps1",
      "check-operator-daily-launcher.ps1",
      "check-project-bootstrap.ps1",
      "check-stability-baseline.ps1",
      "check-operator-runbook.ps1",
      "check-guided-installer.ps1",
      "check-first-project-walkthrough.ps1"
    )

    $failures = 0
    foreach ($check in $checks) {
      $script = Join-Path $toolsRoot $check
      $args = @("-Root", $resolvedRoot)
      if ($check -eq "validate-framework.ps1") {
        $args += "-StrictReferences"
      }
      & powershell -NoProfile -ExecutionPolicy Bypass -File $script @args
      if ($LASTEXITCODE -ne 0) { $failures++ }
    }

    if ($failures -gt 0) {
      Write-Host "HEPHAESTUS doctor summary: FAIL=$failures"
      exit 1
    }
    Write-Host "HEPHAESTUS doctor summary: PASS"
    exit 0
  }

  "validate" {
    Invoke-Tool (Join-Path $toolsRoot "validate-framework.ps1") @("-Root", $resolvedRoot, "-StrictReferences")
  }

  "gate" {
    $args = @("-Root", $resolvedRoot, "-Version", $resolvedVersion)
    if (-not [string]::IsNullOrWhiteSpace($PackagePath)) { $args += @("-PackagePath", $PackagePath) }
    if ($StrictTelemetry) { $args += "-StrictTelemetry" }
    if ($SkipSimulation) { $args += "-SkipSimulation" }
    if ($SkipDeveloperExecution) { $args += "-SkipDeveloperExecution" }
    if ($SkipDeveloperBenchmark) { $args += "-SkipDeveloperBenchmark" }
    Invoke-Tool (Join-Path $toolsRoot "pre-release-gate.ps1") $args
  }

  "package" {
    $targetPackage = if ([string]::IsNullOrWhiteSpace($PackagePath)) {
      Join-Path $resolvedRoot "HEPHAESTUS-Framework-v$resolvedVersion.zip"
    } elseif ([System.IO.Path]::IsPathRooted($PackagePath)) {
      $PackagePath
    } else {
      Join-Path $resolvedRoot $PackagePath
    }

    Compress-Archive -Path (Join-Path $resolvedRoot ".agents/*") -DestinationPath $targetPackage -Force
    Write-Host "HEPHAESTUS package summary: created $targetPackage"
    exit 0
  }

  "evidence" {
    $args = @("-Root", $resolvedRoot, "-Version", $resolvedVersion, "-WriteReport")
    if (-not [string]::IsNullOrWhiteSpace($PackagePath)) { $args += @("-PackagePath", $PackagePath) }
    Invoke-Tool (Join-Path $toolsRoot "run-release-evidence-bundle.ps1") $args
  }

  "compare" {
    if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
      Write-Error "TargetRoot is required for compare."
      exit 1
    }
    Invoke-Tool (Join-Path $toolsRoot "compare-framework-version.ps1") @("-SourceRoot", $SourceRoot, "-TargetRoot", $TargetRoot)
  }

  "install" {
    if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
      Write-Error "TargetRoot is required for install."
      exit 1
    }
    $args = @("-SourceRoot", $SourceRoot, "-TargetRoot", $TargetRoot, "-RepositoryMode", $RepositoryMode, "-RemoteUrl", $RemoteUrl, "-DefaultBranch", $DefaultBranch)
    if ($Apply) { $args += "-Apply" }
    if ($OpenFirstCall) { $args += "-OpenFirstCall" }
    Invoke-Tool (Join-Path $toolsRoot "install-hephaestus-launcher.ps1") $args
  }

  "update" {
    if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
      Write-Error "TargetRoot is required for update."
      exit 1
    }
    $args = @("-SourceRoot", $SourceRoot, "-TargetRoot", $TargetRoot)
    if ($Apply) { $args += "-Apply" }
    Invoke-Tool (Join-Path $toolsRoot "update-framework.ps1") $args
  }

  "daily" {
    $args = @("-Root", $resolvedRoot, "-Mode", $DailyMode, "-Version", $resolvedVersion)
    Invoke-Tool (Join-Path $toolsRoot "operator-daily.ps1") $args
  }

  "bootstrap" {
    $target = if ([string]::IsNullOrWhiteSpace($TargetRoot)) { $resolvedRoot } else { $TargetRoot }
    Invoke-Tool (Join-Path $toolsRoot "run-project-bootstrap.ps1") @("-Root", $resolvedRoot, "-TargetRoot", $target, "-WriteReport", "-WriteAdapterDraft")
  }
}
