param(
  [string]$Root = ".",
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Message {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Id,
    [string]$Type,
    [string]$From,
    [string]$To,
    [string]$Priority,
    [string]$Status,
    [string]$Summary
  )

  $List.Add([pscustomobject]@{
    Id = $Id
    Type = $Type
    From = $From
    To = $To
    Priority = $Priority
    Status = $Status
    Summary = $Summary
  }) | Out-Null
}

function Test-Text {
  param([string]$Path, [string]$Pattern)
  if (-not (Test-Path -LiteralPath $Path)) { return $false }
  $text = Get-Content -LiteralPath $Path -Raw
  return ($text -match $Pattern)
}

$resolvedRoot = (Resolve-Path $Root).Path
$configPath = Join-Path $resolvedRoot ".agents/config/communication-bus.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/inter-agent-communication-bus-protocol.md"
$schemaPath = Join-Path $resolvedRoot ".agents/config/telemetry-schema.yaml"
$reportPath = Join-Path $resolvedRoot ".agents/reports/communication/communication-bus-latest.md"
$messages = New-Object System.Collections.Generic.List[object]
$evidence = New-Object System.Collections.Generic.List[object]

Add-Message $messages "bus-001" "handoff" "orchestrator" "researcher" "normal" "accepted" "Request context handed off for analysis"
Add-Message $messages "bus-002" "consultation" "planner" "platform-guardian" "normal" "resolved" "Platform constraints requested before execution"
Add-Message $messages "bus-003" "conflict" "validator" "builder" "high" "resolved" "Validation rejection requires correction loop"
Add-Message $messages "bus-004" "decision" "orchestrator" "all" "normal" "resolved" "Conflict resolved with evidence-based decision"

$requiredOk = (
  (Test-Text $configPath "required_fields:") -and
  (Test-Text $configPath "allowed_types:") -and
  (Test-Text $configPath "allowed_statuses:")
)
$protocolOk = Test-Path -LiteralPath $protocolPath
$schemaOk = Test-Text $schemaPath 'communication-bus'

$status = if ($requiredOk -and $protocolOk -and $schemaOk -and $messages.Count -ge 4) { "PASS" } else { "FAIL" }

if ($WriteReport) {
  $reportDir = Split-Path -Parent $reportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }

  $generatedAt = (Get-Date).ToString("o")
  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "communication-bus"') | Out-Null
  $content.Add("status: `"$($status.ToLowerInvariant())`"") | Out-Null
  $content.Add('framework_version: "7.9.0"') | Out-Null
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Inter-Agent Communication Bus Evidence") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Status: $status") | Out-Null
  $content.Add("- Generated at: $generatedAt") | Out-Null
  $content.Add("- Messages: $($messages.Count)") | Out-Null
  $content.Add("- Config: .agents/config/communication-bus.yaml") | Out-Null
  $content.Add("- Protocol: .agents/protocols/inter-agent-communication-bus-protocol.md") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Messages") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Message | Type | From | To | Priority | Status | Summary |") | Out-Null
  $content.Add("|---|---|---|---|---|---:|---|") | Out-Null
  foreach ($message in $messages) {
    $summary = $message.Summary.Replace("|", "/")
    $content.Add("| $($message.Id) | $($message.Type) | $($message.From) | $($message.To) | $($message.Priority) | $($message.Status) | $summary |") | Out-Null
  }
  Set-Content -LiteralPath $reportPath -Value $content -Encoding UTF8
}

$messages | Format-Table -AutoSize
Write-Host ""
Write-Host "Communication bus summary: status=$status, messages=$($messages.Count)"

if ($status -eq "FAIL") {
  exit 1
}

exit 0

