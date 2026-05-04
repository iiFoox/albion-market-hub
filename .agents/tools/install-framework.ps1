param(
  [string]$SourceRoot = ".",
  [Parameter(Mandatory=$true)]
  [string]$TargetRoot,
  [switch]$Apply
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

$resolvedSource = (Resolve-Path $SourceRoot).Path
$sourceAgents = Join-Path $resolvedSource ".agents"
$targetRootPath = if (Test-Path -LiteralPath $TargetRoot) { (Resolve-Path $TargetRoot).Path } else { [System.IO.Path]::GetFullPath($TargetRoot) }
$targetAgents = Join-Path $targetRootPath ".agents"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
  Add-Result $results "FAIL" "source" "Missing source .agents directory"
} else {
  Add-Result $results "PASS" "source" $sourceAgents
}

if (Test-Path -LiteralPath $targetAgents) {
  Add-Result $results "FAIL" "target" "Target already has .agents; use update-framework.ps1 instead"
} else {
  Add-Result $results "PASS" "target" "Target is ready for install"
}

$fileCount = 0
if (Test-Path -LiteralPath $sourceAgents) {
  $fileCount = @(Get-ChildItem -LiteralPath $sourceAgents -Recurse -File).Count
  Add-Result $results "INFO" "files" "Would install $fileCount file(s)"
}

if ($Apply -and @($results | Where-Object { $_.Level -eq "FAIL" }).Count -eq 0) {
  if (-not (Test-Path -LiteralPath $targetRootPath)) {
    New-Item -ItemType Directory -Path $targetRootPath | Out-Null
  }

  Copy-Item -LiteralPath $sourceAgents -Destination $targetRootPath -Recurse -Force
  Add-Result $results "PASS" "apply" "Installed framework into $targetAgents"
} elseif (-not $Apply) {
  Add-Result $results "DRYRUN" "apply" "No files copied. Re-run with -Apply to install."
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Install summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0
