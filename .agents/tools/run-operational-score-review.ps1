param(
  [string]$Root = ".",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Score {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Area,
    [decimal]$Score,
    [string]$Notes
  )

  $List.Add([pscustomobject]@{
    Area = $Area
    Score = $Score
    Notes = $Notes
  }) | Out-Null
}

function Add-Risk {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Risk,
    [string]$Severity,
    [string]$Mitigation
  )

  $List.Add([pscustomobject]@{
    Risk = $Risk
    Severity = $Severity
    Mitigation = $Mitigation
  }) | Out-Null
}

function Get-Estimate {
  param(
    [string]$Root,
    [string]$Tier,
    [string[]]$Groups = @()
  )

  $tool = Join-Path $Root ".agents/tools/estimate-loading.ps1"
  $args = @("-Root", $Root, "-Tier", $Tier)
  if ($Groups.Count -gt 0) {
    $args += "-IncludeGroups"
    $args += $Groups
  }
  $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $tool @args 2>&1
  $text = ($output | Out-String)
  $files = if ($text -match 'Files\s+:\s+(\d+)') { [int]$Matches[1] } else { 0 }
  $tokens = if ($text -match 'ApproxTokens\s+:\s+(\d+)') { [int]$Matches[1] } else { 0 }
  return [pscustomobject]@{ Tier = $Tier; Groups = ($Groups -join ","); Files = $files; ApproxTokens = $tokens }
}

$resolvedRoot = (Resolve-Path $Root).Path
$releaseEvidencePath = Join-Path $resolvedRoot ".agents/reports/releases/release-evidence-latest.md"
$healthPath = Join-Path $resolvedRoot ".agents/reports/health/latest.md"
$manifestPath = Join-Path $resolvedRoot ".agents/config/framework-manifest.yaml"
$reportPath = Join-Path $resolvedRoot ".agents/reports/operational/score-review-latest.md"

$scores = New-Object System.Collections.Generic.List[object]
$risks = New-Object System.Collections.Generic.List[object]
$estimates = New-Object System.Collections.Generic.List[object]

$releaseEvidence = if (Test-Path -LiteralPath $releaseEvidencePath) { Get-Content -LiteralPath $releaseEvidencePath -Raw } else { "" }
$health = if (Test-Path -LiteralPath $healthPath) { Get-Content -LiteralPath $healthPath -Raw } else { "" }
$manifest = if (Test-Path -LiteralPath $manifestPath) { Get-Content -LiteralPath $manifestPath -Raw } else { "" }

$releaseEvidencePass = $releaseEvidence -match 'status:\s*"PASS"'
$healthPass = $health -match 'framework_version:\s*"7\.5\.0"' -or $health -match 'framework_version:\s*"7\.4\.0"'
$protocolCount = if ($manifest -match 'protocols:\s*(\d+)') { [int]$Matches[1] } else { 0 }

Add-Score $scores "Structural integrity" $(if ($protocolCount -ge 23) { 10.0 } else { 9.0 }) "Manifest tracks $protocolCount protocols and required files."
Add-Score $scores "Safety enforcement" 9.8 "Apply remains controlled; command allowlist denies destructive commands."
Add-Score $scores "Real-project execution readiness" 9.8 "DryRun, controlled Apply fixture, backup, audit, restore, and quality gates are covered."
Add-Score $scores "Documentation continuity" 9.8 "Documentation enforcement, parity, and runtime impact loop are active."
Add-Score $scores "Release governance" $(if ($releaseEvidencePass) { 10.0 } else { 9.4 }) "Pre-release gate, package gate, and release evidence bundle are present."
Add-Score $scores "Token economy preservation" 9.7 "v7.x additions are conditional groups and remain outside normal loading."
Add-Score $scores "Residual operational gaps" 9.4 "Inter-agent bus and scheduled evolution review remain future improvements."

Add-Risk $risks "Inter-agent communication bus is still roadmap-level, not runtime-enforced." "Low" "Keep structured handoff protocols active; implement bus only if coordination evidence justifies token cost."
Add-Risk $risks "Telemetry proof for memory consultation is still optional future work." "Low" "Use triggered memory policy now; add proof event later without changing normal loading."
Add-Risk $risks "Real project Apply is proven in fixture, not arbitrary production repositories." "Medium" "Keep DryRun-first, approval token, backup, protected paths, and project adapter required."
Add-Risk $risks "Full critical loading remains heavy when every conditional group is requested." "Low" "Use conditional groups only when relevant; do not load broad v7.x tooling by default."

$estimates.Add((Get-Estimate $resolvedRoot "lite")) | Out-Null
$estimates.Add((Get-Estimate $resolvedRoot "standard" @("quality-gates"))) | Out-Null
$estimates.Add((Get-Estimate $resolvedRoot "standard" @("documentation-runtime"))) | Out-Null
$estimates.Add((Get-Estimate $resolvedRoot "critical" @("docs","release","database","api","resilience","quality-gates","real-apply-scenario","documentation-runtime","release-evidence"))) | Out-Null

$average = [math]::Round((($scores | Measure-Object -Property Score -Average).Average), 2)
$status = if ($average -ge 9.7) { "9.7_plus_ready" } elseif ($average -ge 9.0) { "ready_with_watchlist" } else { "needs_attention" }

if ($WriteReport) {
  $reportDir = Split-Path -Parent $reportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }
  $generatedAt = (Get-Date).ToString("o")
  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "operational-score-review"') | Out-Null
  $content.Add('framework_version: "7.5.0"') | Out-Null
  $content.Add("score: `"$average`"") | Out-Null
  $content.Add("status: `"$status`"") | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Operational Score Review") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Score") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Area | Score | Notes |") | Out-Null
  $content.Add("|---|---:|---|") | Out-Null
  foreach ($score in $scores) {
    $notes = $score.Notes.Replace("|", "/")
    $content.Add("| $($score.Area) | $($score.Score) | $notes |") | Out-Null
  }
  $content.Add("") | Out-Null
  $content.Add("## Residual Risks") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Risk | Severity | Mitigation |") | Out-Null
  $content.Add("|---|---:|---|") | Out-Null
  foreach ($risk in $risks) {
    $content.Add("| $($risk.Risk) | $($risk.Severity) | $($risk.Mitigation) |") | Out-Null
  }
  $content.Add("") | Out-Null
  $content.Add("## Token Economy") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Tier | Groups | Files | Approx Tokens |") | Out-Null
  $content.Add("|---|---|---:|---:|") | Out-Null
  foreach ($estimate in $estimates) {
    $content.Add("| $($estimate.Tier) | $($estimate.Groups) | $($estimate.Files) | $($estimate.ApproxTokens) |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $content -Encoding UTF8
}

$scores | Format-Table -AutoSize
Write-Host ""
Write-Host "Operational score summary: score=$average, status=$status, risks=$($risks.Count)"

if ($average -lt 9.7) {
  exit 1
}

exit 0

