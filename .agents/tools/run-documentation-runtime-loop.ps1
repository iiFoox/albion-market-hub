param(
  [string]$Root = ".",
  [string[]]$ChangedFiles = @(),
  [string]$Reason = "",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-DocDecision {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Document,
    [string]$Action,
    [string]$Reason
  )

  $List.Add([pscustomobject]@{
    Document = $Document
    Action = $Action
    Reason = $Reason
  }) | Out-Null
}

$resolvedRoot = (Resolve-Path $Root).Path
$policyPath = Join-Path $resolvedRoot ".agents/config/documentation-policy.yaml"
$reportPath = Join-Path $resolvedRoot ".agents/reports/documentation/documentation-runtime-latest.md"
$decisions = New-Object System.Collections.Generic.List[object]
$changed = @($ChangedFiles | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim().Replace("\", "/") })

if (-not (Test-Path -LiteralPath $policyPath)) {
  throw "Missing .agents/config/documentation-policy.yaml"
}

$impact = "not_impacted"
$status = "PASS"
$impactReason = if ([string]::IsNullOrWhiteSpace($Reason)) { "No documentation-impacting files detected." } else { $Reason }

foreach ($file in $changed) {
  if ($file -match '(^|/)docs/|README\.md$|CHANGELOG\.md$|releases/') {
    $impact = "updated"
    Add-DocDecision $decisions $file "review" "Documentation or release file changed; parity and consistency must be considered."
  } elseif ($file -match '\.agents/config/|\.agents/protocols/|\.agents/workflows/') {
    $impact = "updated"
    Add-DocDecision $decisions ".agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md" "review" "Framework behavior contract changed."
    Add-DocDecision $decisions ".agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md" "review" "Portuguese reference must stay aligned."
  } elseif ($file -match 'src/|app/|lib/|api/|routes/|controllers/|services/') {
    $impact = "updated"
    Add-DocDecision $decisions "README.md" "review" "Project behavior may have changed."
    if ($file -match 'api/|routes/|controllers/') {
      Add-DocDecision $decisions "docs/api.md" "review" "API-facing behavior may have changed."
    }
  }
}

if ($impact -eq "not_impacted" -and [string]::IsNullOrWhiteSpace($Reason)) {
  $status = "FAIL"
  $impactReason = "not_impacted requires an explicit reason."
}

if ($decisions.Count -eq 0) {
  Add-DocDecision $decisions "documentation-impact" "not_impacted" $impactReason
}

if ($WriteReport) {
  $reportDir = Split-Path -Parent $reportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }

  $generatedAt = (Get-Date).ToString("o")
  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "documentation-runtime"') | Out-Null
  $content.Add('framework_version: "7.5.0"') | Out-Null
  $content.Add("status: `"$status`"") | Out-Null
  $content.Add("impact: `"$impact`"") | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Documentation Runtime Report") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Changed files: $($changed -join ', ')") | Out-Null
  $content.Add("- Impact: $impact") | Out-Null
  $content.Add("- Reason: $impactReason") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Decisions") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Document | Action | Reason |") | Out-Null
  $content.Add("|---|---:|---|") | Out-Null
  foreach ($decision in $decisions) {
    $message = $decision.Reason.Replace("|", "/")
    $content.Add("| $($decision.Document) | $($decision.Action) | $message |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $content -Encoding UTF8
}

$decisions | Format-Table -AutoSize
Write-Host ""
Write-Host "Documentation runtime summary: status=$status, impact=$impact, decisions=$($decisions.Count)"

if ($status -ne "PASS") {
  exit 1
}

exit 0



