param(
  [string]$SourceRoot = ".",
  [Parameter(Mandatory=$true)]
  [string]$TargetRoot,
  [switch]$Apply,
  [switch]$NoBackup,
  [switch]$OverwriteProjectConfig
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

function Test-PreservedPath {
  param([string]$RelativePath)

  $normalized = $RelativePath.Replace("\", "/")
  if ($OverwriteProjectConfig) {
    return $false
  }

  return @(
    ".agents/config/project.yaml",
    ".agents/config/multi-project.yaml",
    ".agents/memory/context-db/session-checkpoint.md",
    ".agents/memory/context-db/session-brief.md",
    ".agents/memory/context-db/next-chat-activation-prompt.md"
  ).Contains($normalized)
}

$resolvedSource = (Resolve-Path $SourceRoot).Path
$resolvedTarget = (Resolve-Path $TargetRoot).Path
$sourceAgents = Join-Path $resolvedSource ".agents"
$targetAgents = Join-Path $resolvedTarget ".agents"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
  Add-Result $results "FAIL" "source" "Missing source .agents directory"
}

if (-not (Test-Path -LiteralPath $targetAgents -PathType Container)) {
  Add-Result $results "FAIL" "target" "Target has no .agents; use install-framework.ps1 first"
}

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -eq 0) {
  $sourceFiles = @(Get-ChildItem -LiteralPath $sourceAgents -Recurse -File)
  $copyCount = 0
  $preserveCount = 0

  foreach ($file in $sourceFiles) {
    $relative = ".agents/" + $file.FullName.Substring($sourceAgents.Length + 1).Replace("\", "/")
    if (Test-PreservedPath $relative) {
      $preserveCount++
    } else {
      $copyCount++
    }
  }

  Add-Result $results "INFO" "copy-plan" "Would copy/update $copyCount file(s)"
  Add-Result $results "INFO" "preserve-plan" "Would preserve $preserveCount project-specific file(s)"

  if ($Apply) {
    if (-not $NoBackup) {
      $backupRoot = Join-Path $resolvedTarget ".agents-backups"
      if (-not (Test-Path -LiteralPath $backupRoot)) {
        New-Item -ItemType Directory -Path $backupRoot | Out-Null
      }

      $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
      $backupPath = Join-Path $backupRoot "agents-backup-$stamp.zip"
      Compress-Archive -Path (Join-Path $targetAgents "*") -DestinationPath $backupPath -Force
      Add-Result $results "PASS" "backup" $backupPath
    }

    foreach ($file in $sourceFiles) {
      $relativeInsideAgents = $file.FullName.Substring($sourceAgents.Length + 1)
      $relative = ".agents/" + $relativeInsideAgents.Replace("\", "/")
      if (Test-PreservedPath $relative) {
        continue
      }

      $destination = Join-Path $targetAgents $relativeInsideAgents
      $destinationDir = Split-Path -Parent $destination
      if (-not (Test-Path -LiteralPath $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir | Out-Null
      }

      Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
    }

    Add-Result $results "PASS" "apply" "Updated framework in $targetAgents"
  } else {
    Add-Result $results "DRYRUN" "apply" "No files copied. Re-run with -Apply to update."
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Update summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0
