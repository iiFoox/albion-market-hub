param(
  [string]$SourceRoot = ".",
  [string]$TargetRoot = "."
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

function Get-FrameworkVersion {
  param([string]$Root)

  $path = Join-Path $Root ".agents/config/framework.yaml"
  if (-not (Test-Path -LiteralPath $path)) {
    return ""
  }

  $text = Get-Content -LiteralPath $path -Raw
  if ($text -match 'version:\s*"([^"]+)"') {
    return $Matches[1]
  }

  return ""
}

function Convert-Version {
  param([string]$Version)

  try {
    return [version]$Version
  } catch {
    return $null
  }
}

$resolvedSource = (Resolve-Path $SourceRoot).Path
$resolvedTarget = (Resolve-Path $TargetRoot).Path
$results = New-Object System.Collections.Generic.List[object]

$sourceVersion = Get-FrameworkVersion $resolvedSource
$targetVersion = Get-FrameworkVersion $resolvedTarget

if ([string]::IsNullOrWhiteSpace($sourceVersion)) {
  Add-Result $results "FAIL" "source-version" "Missing source .agents/config/framework.yaml version"
} else {
  Add-Result $results "PASS" "source-version" $sourceVersion
}

if ([string]::IsNullOrWhiteSpace($targetVersion)) {
  Add-Result $results "WARN" "target-version" "Target has no framework version"
} else {
  Add-Result $results "PASS" "target-version" $targetVersion
}

$sourceParsed = Convert-Version $sourceVersion
$targetParsed = Convert-Version $targetVersion

if ($null -ne $sourceParsed -and $null -ne $targetParsed) {
  if ($sourceParsed -gt $targetParsed) {
    Add-Result $results "INFO" "comparison" "Source is newer than target"
  } elseif ($sourceParsed -eq $targetParsed) {
    Add-Result $results "INFO" "comparison" "Source and target versions match"
  } else {
    Add-Result $results "WARN" "comparison" "Target is newer than source"
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
