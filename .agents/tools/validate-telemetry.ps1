param(
  [string]$Root = ".",
  [switch]$Strict
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

function Get-YamlList {
  param([string[]]$Lines, [string]$Section)

  $items = New-Object System.Collections.Generic.List[string]
  $inSection = $false
  $sectionIndent = $null

  foreach ($line in $Lines) {
    if ($line -match "^(\s*)$([regex]::Escape($Section)):\s*$") {
      $inSection = $true
      $sectionIndent = $Matches[1].Length
      continue
    }

    if ($inSection) {
      if ($line -match "^(\s*)[A-Za-z0-9_-]+:\s*" -and $Matches[1].Length -le $sectionIndent) {
        break
      }
      if ($line -match '^\s*-\s+"?([^"]+)"?\s*$') {
        $items.Add($Matches[1]) | Out-Null
      }
    }
  }

  return $items
}

function Get-Frontmatter {
  param([string]$Text)

  $map = @{}
  if (-not $Text.StartsWith("---")) {
    return $null
  }

  $lines = $Text -split "`r?`n"
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -eq "---") {
      return $map
    }
    if ($lines[$i] -match '^([A-Za-z0-9_-]+):\s*"?([^"]*)"?\s*$') {
      $map[$Matches[1]] = $Matches[2]
    }
  }

  return $null
}

$resolvedRoot = (Resolve-Path $Root).Path
$schemaPath = Join-Path $resolvedRoot ".agents/config/telemetry-schema.yaml"
$logsPath = Join-Path $resolvedRoot ".agents/telemetry/logs"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $schemaPath)) {
  Add-Result $results "FAIL" "schema" "Missing .agents/config/telemetry-schema.yaml"
  $results | Format-Table -AutoSize
  exit 1
}

if (-not (Test-Path -LiteralPath $logsPath)) {
  Add-Result $results "FAIL" "logs" "Missing .agents/telemetry/logs"
  $results | Format-Table -AutoSize
  exit 1
}

$schemaLines = Get-Content -LiteralPath $schemaPath
$required = Get-YamlList $schemaLines "required_frontmatter"
$allowedTypes = Get-YamlList $schemaLines "allowed_log_types"
$allowedStatuses = Get-YamlList $schemaLines "allowed_statuses"
$logs = @(Get-ChildItem -LiteralPath $logsPath -Recurse -File -Filter "*.md")

if ($logs.Count -eq 0) {
  Add-Result $results "WARN" "logs" "No telemetry logs found"
} else {
  Add-Result $results "PASS" "logs" "Found $($logs.Count) telemetry log(s)"
}

foreach ($log in $logs) {
  $relative = $log.FullName.Substring($resolvedRoot.Length + 1)
  $text = Get-Content -LiteralPath $log.FullName -Raw
  $frontmatter = Get-Frontmatter $text

  if ($null -eq $frontmatter) {
    $level = if ($Strict) { "FAIL" } else { "WARN" }
    Add-Result $results $level "frontmatter" "$relative has no YAML frontmatter"
    continue
  }

  foreach ($field in $required) {
    if (-not $frontmatter.ContainsKey($field) -or [string]::IsNullOrWhiteSpace($frontmatter[$field])) {
      Add-Result $results "FAIL" "required-field" "$relative missing $field"
    }
  }

  if ($frontmatter.ContainsKey("log_type") -and -not $allowedTypes.Contains($frontmatter["log_type"])) {
    Add-Result $results "FAIL" "log-type" "$relative invalid log_type=$($frontmatter["log_type"])"
  }

  if ($frontmatter.ContainsKey("status") -and -not $allowedStatuses.Contains($frontmatter["status"])) {
    Add-Result $results "FAIL" "status" "$relative invalid status=$($frontmatter["status"])"
  }

  if ($frontmatter.ContainsKey("timestamp")) {
    try {
      [datetimeoffset]::Parse($frontmatter["timestamp"]) | Out-Null
      Add-Result $results "PASS" "timestamp" "$relative timestamp ok"
    } catch {
      Add-Result $results "FAIL" "timestamp" "$relative invalid timestamp=$($frontmatter["timestamp"])"
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
