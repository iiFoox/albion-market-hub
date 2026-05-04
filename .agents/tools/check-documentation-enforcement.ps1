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
$registryPath = Join-Path $resolvedRoot ".agents/config/agent-registry.yaml"
$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$policyPath = Join-Path $resolvedRoot ".agents/config/documentation-policy.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/documentation-enforcement-protocol.md"
$templatePath = Join-Path $resolvedRoot ".agents/reports/documentation/documentation-impact-template.md"
$agentPath = Join-Path $resolvedRoot ".agents/agents/documentation/AGENT.md"
$results = New-Object System.Collections.Generic.List[object]

foreach ($path in @($registryPath, $frameworkPath, $policyPath, $protocolPath, $templatePath, $agentPath)) {
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "required-file" $path.Substring($resolvedRoot.Length + 1)
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $path"
  }
}

if (Test-Path -LiteralPath $registryPath) {
  $registry = Get-Content -LiteralPath $registryPath -Raw
  if ($registry -match '(?s)documentation:\s+id:\s+"documentation".*?always_active:\s+true') {
    Add-Result $results "PASS" "registry" "documentation always_active=true"
  } else {
    Add-Result $results "FAIL" "registry" "documentation must be always_active=true"
  }

  if ($registry -match '\{ agent:\s+"documentation",\s+phase:\s+"documentation",\s+mandatory:\s+true \}') {
    Add-Result $results "PASS" "pipeline" "documentation mandatory=true"
  } else {
    Add-Result $results "FAIL" "pipeline" "documentation pipeline phase must be mandatory=true"
  }
}

if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("documentation_enforcement:")) {
    Add-Result $results "PASS" "framework-config" "documentation_enforcement configured"
  } else {
    Add-Result $results "FAIL" "framework-config" "Missing documentation_enforcement config"
  }
}

if (Test-Path -LiteralPath $agentPath) {
  $agent = Get-Content -LiteralPath $agentPath -Raw
  if ($agent.Contains("Documentation Impact")) {
    Add-Result $results "PASS" "agent-contract" "Documentation Impact output present"
  } else {
    Add-Result $results "FAIL" "agent-contract" "Documentation agent must mention Documentation Impact"
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
