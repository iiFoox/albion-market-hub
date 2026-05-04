param(
  [string]$Root = ".",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Row {
  param(
    [System.Collections.Generic.List[object]]$Rows,
    [string]$Check,
    [string]$Status,
    [string]$Message
  )

  $Rows.Add([pscustomobject]@{
    Check = $Check
    Status = $Status
    Message = $Message
  }) | Out-Null
}

function Get-YamlList {
  param([string[]]$Lines, [string]$Section)

  $items = @()
  $inSection = $false
  $indent = 0
  foreach ($line in $Lines) {
    if ($line -match "^(\s*)$([regex]::Escape($Section)):\s*$") {
      $inSection = $true
      $indent = $Matches[1].Length
      continue
    }
    if ($inSection -and $line -match "^(\s*)[A-Za-z0-9_-]+:\s*" -and $Matches[1].Length -le $indent) {
      break
    }
    if ($inSection -and $line -match '^\s*-\s+"?([^"]+)"?\s*$') {
      $items += $Matches[1]
    }
  }
  return $items
}

function Get-YamlScalar {
  param([string[]]$Lines, [string]$Key)

  foreach ($line in $Lines) {
    if ($line -match "^\s*$([regex]::Escape($Key)):\s*`"?([^`"`r`n]+)`"?\s*$") {
      return $Matches[1].Trim()
    }
  }
  return ""
}

function Get-CapabilityBlocks {
  param([string[]]$Lines)

  $items = @()
  $current = $null
  foreach ($line in $Lines) {
    if ($line -match '^\s*-\s+id:\s+"?([^"]+)"?\s*$') {
      if ($null -ne $current) { $items += [pscustomobject]$current }
      $current = [ordered]@{ id = $Matches[1]; config_marker = ""; checker = ""; protocol = "" }
      continue
    }
    if ($null -ne $current -and $line -match '^\s+config_marker:\s+"?([^"]+)"?\s*$') { $current.config_marker = $Matches[1]; continue }
    if ($null -ne $current -and $line -match '^\s+checker:\s+"?([^"]+)"?\s*$') { $current.checker = $Matches[1]; continue }
    if ($null -ne $current -and $line -match '^\s+protocol:\s+"?([^"]+)"?\s*$') { $current.protocol = $Matches[1]; continue }
  }
  if ($null -ne $current) { $items += [pscustomobject]$current }
  return $items
}

$resolvedRoot = (Resolve-Path $Root).Path
$baselinePath = Join-Path $resolvedRoot ".agents/config/stability-baseline.yaml"
$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$manifestPath = Join-Path $resolvedRoot ".agents/config/framework-manifest.yaml"
$cliPath = Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/operational/stability-baseline-latest.md"
$rows = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $baselinePath)) {
  Add-Row $rows "baseline-file" "FAIL" "Missing .agents/config/stability-baseline.yaml"
} else {
  Add-Row $rows "baseline-file" "PASS" "Found stability baseline"
}

$baselineLines = if (Test-Path -LiteralPath $baselinePath) { Get-Content -LiteralPath $baselinePath } else { @() }
$frameworkText = if (Test-Path -LiteralPath $frameworkPath) { Get-Content -LiteralPath $frameworkPath -Raw } else { "" }
$cliText = if (Test-Path -LiteralPath $cliPath) { Get-Content -LiteralPath $cliPath -Raw } else { "" }

$baselineVersion = Get-YamlScalar $baselineLines "version"
$manifestVersion = ""
if (Test-Path -LiteralPath $manifestPath) {
  $manifestText = Get-Content -LiteralPath $manifestPath -Raw
  if ($manifestText -match 'framework_version:\s*"([^"]+)"') { $manifestVersion = $Matches[1] }
}

if ($baselineVersion -eq $manifestVersion -and -not [string]::IsNullOrWhiteSpace($baselineVersion)) {
  Add-Row $rows "version" "PASS" "baseline=$baselineVersion"
} else {
  Add-Row $rows "version" "FAIL" "baseline=$baselineVersion manifest=$manifestVersion"
}

$counts = @{
  agents = @(Get-ChildItem -LiteralPath (Join-Path $resolvedRoot ".agents/agents") -Directory).Count
  protocols = @(Get-ChildItem -LiteralPath (Join-Path $resolvedRoot ".agents/protocols") -File -Filter "*.md").Count
  workflows = @(Get-ChildItem -LiteralPath (Join-Path $resolvedRoot ".agents/workflows") -File -Filter "*.md").Count
  docs_languages = @(Get-ChildItem -LiteralPath (Join-Path $resolvedRoot ".agents/docs") -Directory | Where-Object { $_.Name -in @("en","pt-br") }).Count
}

foreach ($key in @("agents","protocols","workflows","docs_languages")) {
  $expected = [int](Get-YamlScalar $baselineLines $key)
  if ($counts[$key] -ge $expected) {
    Add-Row $rows "count-$key" "PASS" "actual=$($counts[$key]) minimum=$expected"
  } else {
    Add-Row $rows "count-$key" "FAIL" "actual=$($counts[$key]) minimum=$expected"
  }
}

foreach ($action in (Get-YamlList $baselineLines "cli_actions")) {
  if ($cliText -match "`"$([regex]::Escape($action))`"") {
    Add-Row $rows "cli-$action" "PASS" "Action present"
  } else {
    Add-Row $rows "cli-$action" "FAIL" "Action missing"
  }
}

foreach ($capability in (Get-CapabilityBlocks $baselineLines)) {
  if ($frameworkText.Contains($capability.config_marker)) {
    Add-Row $rows "capability-$($capability.id)-config" "PASS" $capability.config_marker
  } else {
    Add-Row $rows "capability-$($capability.id)-config" "FAIL" "Missing $($capability.config_marker)"
  }

  foreach ($field in @("checker","protocol")) {
    $relative = $capability.$field
    $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
    if (Test-Path -LiteralPath $path) {
      Add-Row $rows "capability-$($capability.id)-$field" "PASS" $relative
    } else {
      Add-Row $rows "capability-$($capability.id)-$field" "FAIL" "Missing $relative"
    }
  }
}

$status = if (@($rows | Where-Object { $_.Status -eq "FAIL" }).Count -eq 0) { "PASS" } else { "FAIL" }

if ($WriteReport) {
  $reportDir = Split-Path -Parent $reportPath
  if (-not (Test-Path -LiteralPath $reportDir)) { New-Item -ItemType Directory -Path $reportDir -Force | Out-Null }
  $timestamp = (Get-Date).ToString("o")
  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("---") | Out-Null
  $lines.Add('log_type: "stability-baseline"') | Out-Null
  $lines.Add("framework_version: `"$manifestVersion`"") | Out-Null
  $lines.Add("status: `"$status`"") | Out-Null
  $lines.Add("generated_at: `"$timestamp`"") | Out-Null
  $lines.Add("---") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("# Stability Baseline Report") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("| Check | Status | Message |") | Out-Null
  $lines.Add("|---|---:|---|") | Out-Null
  foreach ($row in $rows) {
    $lines.Add("| $($row.Check) | $($row.Status) | $($row.Message.Replace("|","/")) |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $lines -Encoding UTF8
}

$rows | Sort-Object Status, Check | Format-Table -AutoSize
$summary = $rows | Group-Object Status | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Stability baseline summary: $($summary -join ', ')"
Write-Host "Summary: $($summary -join ', ')"

if ($status -eq "FAIL") { exit 1 }
exit 0
