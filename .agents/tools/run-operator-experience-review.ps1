param(
  [string]$Root = ".",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Evidence {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Name,
    [string]$Status,
    [string]$Notes
  )

  $List.Add([pscustomobject]@{
    Name = $Name
    Status = $Status
    Notes = $Notes
  }) | Out-Null
}

function Test-PathEvidence {
  param(
    [System.Collections.Generic.List[object]]$Evidence,
    [string]$Root,
    [string]$Name,
    [string]$RelativePath
  )
  $path = Join-Path $Root ($RelativePath -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Evidence $Evidence $Name "PASS" "$RelativePath present"
  } else {
    Add-Evidence $Evidence $Name "FAIL" "Missing $RelativePath"
  }
}

function Test-NoStaleVersion {
  param(
    [System.Collections.Generic.List[object]]$Evidence,
    [string]$Root,
    [string]$Name,
    [string[]]$RelativePaths
  )

  $stale = New-Object System.Collections.Generic.List[string]
  foreach ($relative in $RelativePaths) {
    $path = Join-Path $Root ($relative -replace "/", "\")
    if (-not (Test-Path -LiteralPath $path)) {
      $stale.Add("missing:$relative") | Out-Null
      continue
    }
    $text = Get-Content -LiteralPath $path -Raw
    if ($text -match "HEPHAESTUS v[1-6]\." -or $text -match "HEPHAESTUS v7\.[0-7]\." -or $text -match "Framework Version:\s*7\.[0-7]\.0") {
      $stale.Add($relative) | Out-Null
    }
  }

  if ($stale.Count -eq 0) {
    Add-Evidence $Evidence $Name "PASS" "No stale framework versions found"
  } else {
    Add-Evidence $Evidence $Name "FAIL" "Stale version markers: $($stale -join ', ')"
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$reportPath = Join-Path $resolvedRoot ".agents/reports/operator/operator-experience-latest.md"
$evidence = New-Object System.Collections.Generic.List[object]

Test-PathEvidence $evidence $resolvedRoot "operator-map-en" ".agents/docs/en/22-OPERATOR-EXPERIENCE-MAP.md"
Test-PathEvidence $evidence $resolvedRoot "operator-map-pt-br" ".agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md"
Test-PathEvidence $evidence $resolvedRoot "install-update-guide" ".agents/docs/en/20-INSTALL-UPDATE-WIZARD.md"
Test-PathEvidence $evidence $resolvedRoot "project-discovery-guide" ".agents/docs/en/12-PROJECT-DISCOVERY.md"
Test-PathEvidence $evidence $resolvedRoot "real-project-execution-guide" ".agents/docs/en/14-REAL-PROJECT-EXECUTION.md"
Test-PathEvidence $evidence $resolvedRoot "release-evidence-guide" ".agents/docs/en/18-RELEASE-EVIDENCE-BUNDLE.md"
Test-PathEvidence $evidence $resolvedRoot "memory-proof-guide" ".agents/docs/en/21-OPTIONAL-TELEMETRY-MEMORY-PROOF.md"
Test-PathEvidence $evidence $resolvedRoot "communication-bus-guide" ".agents/docs/en/23-INTER-AGENT-COMMUNICATION-BUS.md"
Test-PathEvidence $evidence $resolvedRoot "unified-cli-guide" ".agents/docs/en/24-UNIFIED-OPERATOR-CLI.md"

Test-NoStaleVersion $evidence $resolvedRoot "ready-prompts-current" @(
  ".agents/docs/en/prompts/READY-PROMPTS.md",
  ".agents/docs/pt-br/prompts/PROMPTS-PRONTOS.md"
)

Test-NoStaleVersion $evidence $resolvedRoot "legacy-bridges-current" @(
  ".agents/Tutorial/README.md",
  ".agents/daily-prompts/README.md"
)

$status = "PASS"
if (@($evidence | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) {
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
  $content.Add('log_type: "operator-experience"') | Out-Null
  $content.Add("status: `"$($status.ToLowerInvariant())`"") | Out-Null
  $content.Add('framework_version: "7.9.0"') | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Final Operator Experience Review") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Status: $status") | Out-Null
  $content.Add("- Generated at: $generatedAt") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Evidence") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Evidence | Status | Notes |") | Out-Null
  $content.Add("|---|---:|---|") | Out-Null
  foreach ($item in $evidence) {
    $notes = $item.Notes.Replace("|", "/")
    $content.Add("| $($item.Name) | $($item.Status) | $notes |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $content -Encoding UTF8
}

$evidence | Format-Table -AutoSize
Write-Host ""
Write-Host "Operator experience summary: status=$status, evidence=$($evidence.Count)"

if ($status -eq "FAIL") {
  exit 1
}

exit 0
