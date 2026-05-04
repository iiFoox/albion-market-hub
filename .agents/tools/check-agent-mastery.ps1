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
$agentsRoot = Join-Path $resolvedRoot ".agents/agents"
$results = New-Object System.Collections.Generic.List[object]
$agentFiles = @(Get-ChildItem -LiteralPath $agentsRoot -Directory | ForEach-Object { Join-Path $_.FullName "AGENT.md" } | Where-Object { Test-Path -LiteralPath $_ })

foreach ($file in $agentFiles) {
  $relative = $file.Substring($resolvedRoot.Length + 1)
  $text = Get-Content -LiteralPath $file -Raw
  if ($text.Contains("Master-level") -and $text.Contains("30+ years")) {
    Add-Result $results "PASS" "mastery" $relative
  } else {
    Add-Result $results "FAIL" "mastery" "$relative missing Master-level / 30+ years calibration"
  }
}

$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("30+ years") -and $framework.Contains("master")) {
    Add-Result $results "PASS" "framework-principle" "Mastery calibration configured"
  } else {
    Add-Result $results "FAIL" "framework-principle" "framework.yaml missing mastery calibration"
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
