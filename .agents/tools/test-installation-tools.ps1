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

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$results = New-Object System.Collections.Generic.List[object]

$required = @(
  "install-framework.ps1",
  "update-framework.ps1",
  "compare-framework-version.ps1"
)

foreach ($tool in $required) {
  $path = Join-Path $toolsRoot $tool
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "tool" $tool
  } else {
    Add-Result $results "FAIL" "tool" "Missing $tool"
  }
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-install-test-" + [guid]::NewGuid().ToString("N"))
$installTarget = Join-Path $tempRoot "install-target"
$updateTarget = Join-Path $tempRoot "update-target"

try {
  New-Item -ItemType Directory -Path $installTarget | Out-Null
  New-Item -ItemType Directory -Path $updateTarget | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $updateTarget ".agents/config") -Force | Out-Null
  Copy-Item -LiteralPath (Join-Path $resolvedRoot ".agents/config/framework.yaml") -Destination (Join-Path $updateTarget ".agents/config/framework.yaml") -Force

  $installOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "install-framework.ps1") -SourceRoot $resolvedRoot -TargetRoot $installTarget 2>&1
  if ($LASTEXITCODE -eq 0 -and -not (Test-Path -LiteralPath (Join-Path $installTarget ".agents"))) {
    Add-Result $results "PASS" "install-dryrun" "Dry run did not copy files"
  } else {
    Add-Result $results "FAIL" "install-dryrun" ($installOutput | Out-String).Trim()
  }

  $updateOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "update-framework.ps1") -SourceRoot $resolvedRoot -TargetRoot $updateTarget 2>&1
  if ($LASTEXITCODE -eq 0 -and -not (Test-Path -LiteralPath (Join-Path $updateTarget ".agents-backups"))) {
    Add-Result $results "PASS" "update-dryrun" "Dry run did not create backup or copy files"
  } else {
    Add-Result $results "FAIL" "update-dryrun" ($updateOutput | Out-String).Trim()
  }

  $compareOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "compare-framework-version.ps1") -SourceRoot $resolvedRoot -TargetRoot $updateTarget 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "compare" "Version comparison executed"
  } else {
    Add-Result $results "FAIL" "compare" ($compareOutput | Out-String).Trim()
  }
} finally {
  if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
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
