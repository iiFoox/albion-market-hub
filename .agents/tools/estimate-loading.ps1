param(
  [ValidateSet("lite", "standard", "deep", "critical")]
  [string]$Tier = "lite",
  [string[]]$IncludeGroups = @(),
  [string]$Root = ".",
  [switch]$ShowFiles
)

$ErrorActionPreference = "Stop"

function Get-ManifestSectionFiles {
  param(
    [string[]]$Lines,
    [string]$SectionPath,
    [string[]]$Keys
  )

  $files = New-Object System.Collections.Generic.List[string]
  $parts = $SectionPath.Split(".")
  $sectionIndent = $null
  $inSection = $false
  $capture = $false
  $captureIndent = $null
  $stack = @{}

  foreach ($line in $Lines) {
    if ($line -match '^(\s*)([A-Za-z0-9_-]+):\s*$') {
      $indent = $Matches[1].Length
      $name = $Matches[2]
      $stack[$indent] = $name
      foreach ($key in @($stack.Keys)) {
        if ([int]$key -gt $indent) {
          $stack.Remove($key)
        }
      }

      $currentPath = ($stack.Keys | Sort-Object {[int]$_} | ForEach-Object { $stack[$_] }) -join "."

      if ($currentPath -eq $SectionPath) {
        $inSection = $true
        $sectionIndent = $indent
        $capture = $false
        continue
      }

      if ($inSection -and $indent -le $sectionIndent) {
        $inSection = $false
        $capture = $false
      }

      if ($inSection -and $Keys -contains $name) {
        if ($Keys -contains $name) {
          $capture = $true
          $captureIndent = $indent
        }
        continue
      }

      if ($capture -and $indent -le $captureIndent) {
        $capture = $false
      }
    } elseif ($capture -and $line -match '^\s*-\s+"?([^"]+)"?\s*$') {
      $files.Add($Matches[1]) | Out-Null
    }
  }

  return $files
}

function Add-Unique {
  param(
    [System.Collections.Generic.List[string]]$List,
    [string[]]$Items
  )

  foreach ($item in $Items) {
    if ($item -and -not $List.Contains($item)) {
      $List.Add($item) | Out-Null
    }
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$manifestPath = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"

if (-not (Test-Path -LiteralPath $manifestPath)) {
  throw "Missing loading tier manifest: $manifestPath"
}

$lines = Get-Content -LiteralPath $manifestPath
$tierOrder = @("lite", "standard", "deep", "critical")
$targetIndex = [array]::IndexOf($tierOrder, $Tier)
$selected = New-Object System.Collections.Generic.List[string]

Add-Unique $selected (Get-ManifestSectionFiles -Lines $lines -SectionPath "core" -Keys @("files"))

for ($i = 0; $i -le $targetIndex; $i++) {
  $tierName = $tierOrder[$i]
  Add-Unique $selected (Get-ManifestSectionFiles -Lines $lines -SectionPath "tiers.$tierName" -Keys @("files", "delta_files"))
}

foreach ($group in $IncludeGroups) {
  Add-Unique $selected (Get-ManifestSectionFiles -Lines $lines -SectionPath "conditional_groups.$group" -Keys @("files"))
}

$rows = New-Object System.Collections.Generic.List[object]
$missing = New-Object System.Collections.Generic.List[string]
$totalBytes = 0

foreach ($relative in $selected) {
  $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    $item = Get-Item -LiteralPath $path
    $totalBytes += $item.Length
    $rows.Add([pscustomobject]@{
      Path = $relative
      Bytes = $item.Length
      ApproxTokens = [math]::Ceiling($item.Length / 4)
    }) | Out-Null
  } else {
    $missing.Add($relative) | Out-Null
  }
}

$summary = [pscustomobject]@{
  Tier = $Tier
  ConditionalGroups = if ($IncludeGroups.Count -gt 0) { $IncludeGroups -join "," } else { "(none)" }
  Files = $selected.Count
  ExistingFiles = $rows.Count
  MissingFiles = $missing.Count
  Bytes = $totalBytes
  ApproxTokens = [math]::Ceiling($totalBytes / 4)
}

$summary | Format-List

if ($ShowFiles) {
  $rows | Sort-Object Path | Format-Table -AutoSize
}

if ($missing.Count -gt 0) {
  Write-Host ""
  Write-Host "Missing files:" -ForegroundColor Red
  $missing | Sort-Object | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
  exit 1
}

exit 0
