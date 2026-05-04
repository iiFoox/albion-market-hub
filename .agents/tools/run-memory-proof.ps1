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

function Test-Text {
  param(
    [string]$Path,
    [string]$Pattern
  )
  if (-not (Test-Path -LiteralPath $Path)) { return $false }
  $text = Get-Content -LiteralPath $Path -Raw
  return ($text -match $Pattern)
}

$resolvedRoot = (Resolve-Path $Root).Path
$policyPath = Join-Path $resolvedRoot ".agents/config/memory-policy.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/memory-consultation-protocol.md"
$schemaPath = Join-Path $resolvedRoot ".agents/config/telemetry-schema.yaml"
$cleanupPath = Join-Path $resolvedRoot ".agents/tools/cleanup-telemetry.ps1"
$reportPath = Join-Path $resolvedRoot ".agents/reports/memory/memory-proof-latest.md"
$evidence = New-Object System.Collections.Generic.List[object]

if (Test-Path -LiteralPath $policyPath) {
  Add-Evidence $evidence "memory-policy" "PASS" ".agents/config/memory-policy.yaml present"
} else {
  Add-Evidence $evidence "memory-policy" "FAIL" "Missing memory policy"
}

if (Test-Path -LiteralPath $protocolPath) {
  Add-Evidence $evidence "memory-protocol" "PASS" ".agents/protocols/memory-consultation-protocol.md present"
} else {
  Add-Evidence $evidence "memory-protocol" "FAIL" "Missing memory consultation protocol"
}

if (Test-Text $policyPath "search_index_first:\s*true") {
  Add-Evidence $evidence "index-first" "PASS" "Memory policy requires index-first consultation"
} else {
  Add-Evidence $evidence "index-first" "FAIL" "Memory policy does not require index-first consultation"
}

if (Test-Text $policyPath "load_full_store_by_default:\s*false") {
  Add-Evidence $evidence "full-store-default" "PASS" "Full memory store loading is disabled by default"
} else {
  Add-Evidence $evidence "full-store-default" "FAIL" "Full memory store loading is not explicitly disabled"
}

if ((Test-Text $policyPath "always_on_session_start:\s*true") -and (Test-Text $policyPath "always_on_session_close:\s*true")) {
  Add-Evidence $evidence "session-boundary" "PASS" "Session start and close consultation are configured"
} else {
  Add-Evidence $evidence "session-boundary" "FAIL" "Session boundary memory consultation is incomplete"
}

if (Test-Text $schemaPath 'memory-proof') {
  Add-Evidence $evidence "telemetry-schema" "PASS" "Telemetry schema accepts memory-proof log type"
} else {
  Add-Evidence $evidence "telemetry-schema" "FAIL" "Telemetry schema missing memory-proof log type"
}

if (Test-Path -LiteralPath $cleanupPath) {
  $cleanupOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $cleanupPath -Root $resolvedRoot -RetentionDays 365 2>&1
  if ($LASTEXITCODE -eq 0) {
    $summary = @($cleanupOutput | Where-Object { $_ -match "^Telemetry cleanup summary:" } | Select-Object -Last 1)
    $note = if ($summary.Count -gt 0) { $summary[0].ToString() } else { "Retention dry-run completed" }
    Add-Evidence $evidence "retention-dry-run" "PASS" $note
  } else {
    Add-Evidence $evidence "retention-dry-run" "FAIL" ($cleanupOutput | Out-String).Trim()
  }
} else {
  Add-Evidence $evidence "retention-dry-run" "FAIL" "Missing cleanup-telemetry.ps1"
}

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
  $content.Add('log_type: "memory-proof"') | Out-Null
  $content.Add('event: "memory.consulted"') | Out-Null
  $content.Add("status: `"$($status.ToLowerInvariant())`"") | Out-Null
  $content.Add('framework_version: "7.9.0"') | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Optional Telemetry and Memory Proof") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Status: $status") | Out-Null
  $content.Add("- Generated at: $generatedAt") | Out-Null
  $content.Add("- Policy: .agents/config/memory-policy.yaml") | Out-Null
  $content.Add("- Protocol: .agents/protocols/memory-consultation-protocol.md") | Out-Null
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
Write-Host "Memory proof summary: status=$status, evidence=$($evidence.Count)"

if ($status -eq "FAIL") {
  exit 1
}

exit 0
