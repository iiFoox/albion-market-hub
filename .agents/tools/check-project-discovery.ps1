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
$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$policyPath = Join-Path $resolvedRoot ".agents/config/project-discovery-policy.yaml"
$loadingPath = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/project-discovery-protocol.md"
$workflowPath = Join-Path $resolvedRoot ".agents/workflows/project-discovery-workflow.md"
$templatePath = Join-Path $resolvedRoot ".agents/reports/discovery/project-discovery-template.md"
$decisionTemplatePath = Join-Path $resolvedRoot ".agents/reports/discovery/decision-log-template.md"
$docsEnPath = Join-Path $resolvedRoot ".agents/docs/en/12-PROJECT-DISCOVERY.md"
$docsPtPath = Join-Path $resolvedRoot ".agents/docs/pt-br/12-DESCOBERTA-DE-PROJETO.md"
$mapPath = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"

$results = New-Object System.Collections.Generic.List[object]

foreach ($path in @($frameworkPath, $policyPath, $loadingPath, $protocolPath, $workflowPath, $templatePath, $decisionTemplatePath, $docsEnPath, $docsPtPath, $mapPath)) {
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "required-file" $path.Substring($resolvedRoot.Length + 1)
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $path"
  }
}

if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("project_discovery:")) {
    Add-Result $results "PASS" "framework-config" "project_discovery configured"
  } else {
    Add-Result $results "FAIL" "framework-config" "Missing project_discovery config"
  }
}

if (Test-Path -LiteralPath $loadingPath) {
  $loading = Get-Content -LiteralPath $loadingPath -Raw
  if ($loading -match '(?s)discovery:\s+trigger:.*project.*files:') {
    Add-Result $results "PASS" "loading" "discovery conditional group configured"
  } else {
    Add-Result $results "FAIL" "loading" "Missing discovery conditional loading group"
  }
}

if (Test-Path -LiteralPath $policyPath) {
  $policy = Get-Content -LiteralPath $policyPath -Raw
  foreach ($domain in @("product_story", "backend", "cost_model", "legal_ip", "git_strategy", "implementation_readiness")) {
    if ($policy.Contains($domain)) {
      Add-Result $results "PASS" "policy-domain" $domain
    } else {
      Add-Result $results "FAIL" "policy-domain" "Missing $domain"
    }
  }
}

if (Test-Path -LiteralPath $templatePath) {
  $template = Get-Content -LiteralPath $templatePath -Raw
  foreach ($section in @("Product Story", "Backend and Data", "Cost and Zero-Cost Start", "Legal, Copyright, and IP", "Team, Git, and Workspace Strategy", "Implementation Readiness")) {
    if ($template.Contains($section)) {
      Add-Result $results "PASS" "template-section" $section
    } else {
      Add-Result $results "FAIL" "template-section" "Missing $section"
    }
  }
}

if (Test-Path -LiteralPath $mapPath) {
  $map = Get-Content -LiteralPath $mapPath -Raw
  if ($map.Contains('12-PROJECT-DISCOVERY.md') -and $map.Contains('12-DESCOBERTA-DE-PROJETO.md')) {
    Add-Result $results "PASS" "doc-map" "project discovery EN/PT-BR pair configured"
  } else {
    Add-Result $results "FAIL" "doc-map" "Missing project discovery EN/PT-BR pair"
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
