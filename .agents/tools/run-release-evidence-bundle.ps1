param(
  [string]$Root = ".",
  [string]$Version = "",
  [string]$PackagePath = "",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Evidence {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Name,
    [string]$Status,
    [string]$Source,
    [string]$Notes
  )

  $List.Add([pscustomobject]@{
    Name = $Name
    Status = $Status
    Source = $Source
    Notes = $Notes
  }) | Out-Null
}

function Test-ReportMarker {
  param(
    [string]$Root,
    [string]$RelativePath,
    [string]$Marker
  )

  $path = Join-Path $Root ($RelativePath -replace "/", "\")
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    return [pscustomobject]@{ Status = "MISSING"; Notes = "Missing $RelativePath" }
  }

  $text = Get-Content -LiteralPath $path -Raw
  if ($text -match [regex]::Escape($Marker)) {
    return [pscustomobject]@{ Status = "PASS"; Notes = "Found $Marker" }
  }

  return [pscustomobject]@{ Status = "WARN"; Notes = "Marker not found: $Marker" }
}

$resolvedRoot = (Resolve-Path $Root).Path
$evidence = New-Object System.Collections.Generic.List[object]
$reportPath = Join-Path $resolvedRoot ".agents/reports/releases/release-evidence-latest.md"

if ([string]::IsNullOrWhiteSpace($Version)) {
  $manifestPath = Join-Path $resolvedRoot ".agents/config/framework-manifest.yaml"
  if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw
    if ($manifest -match 'framework_version:\s*"([^"]+)"') {
      $Version = $Matches[1]
    }
  }
}

$frameworkVersion = $Version

$checks = @(
  @{ Name = "framework-integrity"; Path = ".agents/reports/health/latest.md"; Marker = "framework_version: `"$Version`"" },
  @{ Name = "documentation-runtime"; Path = ".agents/reports/documentation/documentation-runtime-latest.md"; Marker = 'log_type: "documentation-runtime"' },
  @{ Name = "quality-gates"; Path = ".agents/reports/executions/quality-gates-latest.md"; Marker = 'log_type: "command-quality-gates"' },
  @{ Name = "real-project-execution"; Path = ".agents/reports/executions/real-project-latest.md"; Marker = 'log_type: "real-project-execution"' },
  @{ Name = "real-project-apply-scenario"; Path = ".agents/reports/executions/real-project-apply-scenario-latest.md"; Marker = 'log_type: "real-project-apply-scenario"' },
  @{ Name = "memory-proof"; Path = ".agents/reports/memory/memory-proof-latest.md"; Marker = 'log_type: "memory-proof"' },
  @{ Name = "operator-experience"; Path = ".agents/reports/operator/operator-experience-latest.md"; Marker = 'log_type: "operator-experience"' },
  @{ Name = "communication-bus"; Path = ".agents/reports/communication/communication-bus-latest.md"; Marker = 'log_type: "communication-bus"' },
  @{ Name = "project-bootstrap"; Path = ".agents/reports/adapters/project-bootstrap-latest.md"; Marker = 'log_type: "project-bootstrap"' },
  @{ Name = "stability-baseline"; Path = ".agents/reports/operational/stability-baseline-latest.md"; Marker = 'log_type: "stability-baseline"' },
  @{ Name = "repository-setup"; Path = ".agents/reports/operator/repository-setup-latest.md"; Marker = 'log_type: "repository-setup"' }
)

foreach ($check in $checks) {
  $result = Test-ReportMarker -Root $resolvedRoot -RelativePath $check.Path -Marker $check.Marker
  Add-Evidence $evidence $check.Name $result.Status $check.Path $result.Notes
}

if (-not [string]::IsNullOrWhiteSpace($PackagePath)) {
  $resolvedPackage = $PackagePath
  if (-not [System.IO.Path]::IsPathRooted($resolvedPackage)) {
    $resolvedPackage = Join-Path $resolvedRoot $PackagePath
  }
  if (Test-Path -LiteralPath $resolvedPackage -PathType Leaf) {
    $size = (Get-Item -LiteralPath $resolvedPackage).Length
    Add-Evidence $evidence "package" "PASS" $PackagePath "Package present; bytes=$size"
  } else {
    Add-Evidence $evidence "package" "WARN" $PackagePath "Package path not found yet"
  }
} else {
  Add-Evidence $evidence "package" "WARN" "PackagePath" "No package path supplied"
}

$status = "PASS"
if (@($evidence | Where-Object { $_.Status -eq "MISSING" }).Count -gt 0) {
  $status = "FAIL"
}

if ($WriteReport) {
  $reportDir = Split-Path -Parent $reportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }

  $generatedAt = (Get-Date).ToString("o")
  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "release-evidence"') | Out-Null
  $content.Add("framework_version: `"$frameworkVersion`"") | Out-Null
  $content.Add("version: `"$Version`"") | Out-Null
  $content.Add("status: `"$status`"") | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("package_path: `"$PackagePath`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Release Evidence Bundle") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Version: $Version") | Out-Null
  $content.Add("- Status: $status") | Out-Null
  $content.Add("- Package: $PackagePath") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Evidence") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Evidence | Status | Source | Notes |") | Out-Null
  $content.Add("|---|---:|---|---|") | Out-Null
  foreach ($item in $evidence) {
    $notes = $item.Notes.Replace("|", "/")
    $content.Add("| $($item.Name) | $($item.Status) | $($item.Source) | $notes |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $content -Encoding UTF8
}

$evidence | Format-Table -AutoSize
Write-Host ""
Write-Host "Release evidence summary: status=$status, evidence=$($evidence.Count)"

if ($status -eq "FAIL") {
  exit 1
}

exit 0

