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

function Get-ManifestScalar {
  param([string[]]$Lines, [string]$Key)

  foreach ($line in $Lines) {
    if ($line -match "^\s*$([regex]::Escape($Key)):\s+`"?([^`"]+)`"?\s*$") {
      return $Matches[1]
    }
  }

  return ""
}

$resolvedRoot = (Resolve-Path $Root).Path
$agentsRoot = Join-Path $resolvedRoot ".agents"
$manifestPath = Join-Path $agentsRoot "config/framework-manifest.yaml"
$kernelRoot = Join-Path $agentsRoot "kernel"
$results = New-Object System.Collections.Generic.List[object]

$kernelDirs = @(
  ".agents/agents",
  ".agents/config",
  ".agents/docs",
  ".agents/kernel",
  ".agents/memory",
  ".agents/protocols",
  ".agents/releases",
  ".agents/reports",
  ".agents/tests",
  ".agents/tools",
  ".agents/workflows"
)

$kernelFiles = @(
  ".agents/AGENTS.md",
  ".agents/config/framework.yaml",
  ".agents/config/agent-registry.yaml",
  ".agents/config/framework-manifest.yaml",
  ".agents/tools/pre-release-gate.ps1",
  ".agents/tools/check-kernel-contract.ps1",
  ".agents/tools/compare-framework-version.ps1",
  ".agents/tools/install-framework.ps1",
  ".agents/tools/update-framework.ps1",
  ".agents/tools/test-installation-tools.ps1",
  ".agents/releases/CHANGELOG.md",
  ".agents/kernel/KERNEL.md",
  ".agents/kernel/COMPATIBILITY.md",
  ".agents/kernel/MIGRATION-v5-to-v6.md",
  ".agents/kernel/HOST-MATRIX.md",
  ".agents/kernel/INSTALL-UPDATE.md"
)

foreach ($dir in $kernelDirs) {
  $path = Join-Path $resolvedRoot $dir
  if (Test-Path -LiteralPath $path -PathType Container) {
    Add-Result $results "PASS" "kernel-directory" $dir
  } else {
    Add-Result $results "FAIL" "kernel-directory" "Missing $dir"
  }
}

foreach ($file in $kernelFiles) {
  $path = Join-Path $resolvedRoot $file
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "kernel-file" $file
  } else {
    Add-Result $results "FAIL" "kernel-file" "Missing $file"
  }
}

if (Test-Path -LiteralPath $manifestPath) {
  $manifestText = Get-Content -LiteralPath $manifestPath -Raw
  $manifestLines = $manifestText -split "`r?`n"
  $frameworkVersion = Get-ManifestScalar $manifestLines "framework_version"

  if ($frameworkVersion -match "^(6|7|8)\.\d+\.\d+$") {
    Add-Result $results "PASS" "kernel-version" "framework_version=$frameworkVersion"
  } else {
    Add-Result $results "FAIL" "kernel-version" "Expected framework_version in 6.x, 7.x, or 8.x, got $frameworkVersion"
  }

  foreach ($file in $kernelFiles) {
    if ($manifestText.Contains($file)) {
      Add-Result $results "PASS" "manifest-kernel-file" $file
    } else {
      Add-Result $results "FAIL" "manifest-kernel-file" "Manifest missing $file"
    }
  }
} else {
  Add-Result $results "FAIL" "manifest" "Missing .agents/config/framework-manifest.yaml"
}

foreach ($doc in @("KERNEL.md", "COMPATIBILITY.md", "MIGRATION-v5-to-v6.md", "HOST-MATRIX.md", "INSTALL-UPDATE.md")) {
  $path = Join-Path $kernelRoot $doc
  if (Test-Path -LiteralPath $path) {
    $text = Get-Content -LiteralPath $path -Raw
    if ($text.Contains($frameworkVersion) -or $text.Contains("6.0.0") -or $text.Contains("7.0.0")) {
      Add-Result $results "PASS" "kernel-doc-version" "$doc contains compatible kernel version"
    } else {
      Add-Result $results "FAIL" "kernel-doc-version" "$doc missing compatible kernel version"
    }
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0
