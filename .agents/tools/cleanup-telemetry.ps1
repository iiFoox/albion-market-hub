param(
  [string]$Root = ".",
  [int]$RetentionDays = 365,
  [switch]$Archive,
  [switch]$Apply
)

$ErrorActionPreference = "Stop"

function Add-CleanupResult {
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

$resolvedRoot = (Resolve-Path $Root).Path
$logsPath = Join-Path $resolvedRoot ".agents/telemetry/logs"
$archivePath = Join-Path $resolvedRoot ".agents/telemetry/archive"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $logsPath)) {
  Add-CleanupResult $results "FAIL" "logs" "Missing .agents/telemetry/logs"
  $results | Format-Table -AutoSize
  exit 1
}

$cutoff = (Get-Date).AddDays(-1 * $RetentionDays)
$logs = @(Get-ChildItem -LiteralPath $logsPath -Recurse -File -Filter "*.md" | Where-Object { $_.LastWriteTime -lt $cutoff })

if ($logs.Count -eq 0) {
  Add-CleanupResult $results "PASS" "retention" "No telemetry logs older than $RetentionDays days"
} else {
  Add-CleanupResult $results "INFO" "retention" "Found $($logs.Count) telemetry log(s) older than $RetentionDays days"
}

foreach ($log in $logs) {
  $relative = $log.FullName.Substring($resolvedRoot.Length + 1)

  if (-not $Apply) {
    Add-CleanupResult $results "DRYRUN" "candidate" $relative
    continue
  }

  if ($Archive) {
    $yearPath = Join-Path $archivePath $log.LastWriteTime.ToString("yyyy")
    if (-not (Test-Path -LiteralPath $yearPath)) {
      New-Item -ItemType Directory -Path $yearPath | Out-Null
    }

    $destination = Join-Path $yearPath $log.Name
    Move-Item -LiteralPath $log.FullName -Destination $destination -Force
    Add-CleanupResult $results "PASS" "archived" "$relative -> $($destination.Substring($resolvedRoot.Length + 1))"
  } else {
    Add-CleanupResult $results "WARN" "skipped" "$relative requires -Archive or a future delete policy"
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Telemetry cleanup summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0
