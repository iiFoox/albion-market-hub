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
$projectPath = Join-Path $resolvedRoot ".agents/config/project.yaml"
$frameworkPath = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$loadingPath = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/real-project-adapter-protocol.md"
$workflowPath = Join-Path $resolvedRoot ".agents/workflows/real-project-adapter-workflow.md"
$reportPath = Join-Path $resolvedRoot ".agents/reports/adapters/real-project-adapter-status-template.md"
$docsEnPath = Join-Path $resolvedRoot ".agents/docs/en/13-REAL-PROJECT-ADAPTER.md"
$docsPtPath = Join-Path $resolvedRoot ".agents/docs/pt-br/13-ADAPTADOR-DE-PROJETO-REAL.md"
$mapPath = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"

$results = New-Object System.Collections.Generic.List[object]

foreach ($path in @($projectPath, $frameworkPath, $loadingPath, $protocolPath, $workflowPath, $reportPath, $docsEnPath, $docsPtPath, $mapPath)) {
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "required-file" $path.Substring($resolvedRoot.Length + 1)
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $path"
  }
}

if (Test-Path -LiteralPath $projectPath) {
  $project = Get-Content -LiteralPath $projectPath -Raw
  foreach ($field in @("root:", "stack:", "commands:", "paths:", "protected:", "execution:", "quality_gates:")) {
    if ($project.Contains($field)) {
      Add-Result $results "PASS" "project-field" $field
    } else {
      Add-Result $results "FAIL" "project-field" "Missing $field"
    }
  }
}

if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("real_project_adapter:")) {
    Add-Result $results "PASS" "framework-config" "real_project_adapter configured"
  } else {
    Add-Result $results "FAIL" "framework-config" "Missing real_project_adapter config"
  }
}

if (Test-Path -LiteralPath $loadingPath) {
  $loading = Get-Content -LiteralPath $loadingPath -Raw
  if ($loading -match '(?s)adapter:\s+trigger:.*real.*project.*files:') {
    Add-Result $results "PASS" "loading" "adapter conditional group configured"
  } else {
    Add-Result $results "FAIL" "loading" "Missing adapter conditional loading group"
  }
}

if (Test-Path -LiteralPath $mapPath) {
  $map = Get-Content -LiteralPath $mapPath -Raw
  if ($map.Contains('13-REAL-PROJECT-ADAPTER.md') -and $map.Contains('13-ADAPTADOR-DE-PROJETO-REAL.md')) {
    Add-Result $results "PASS" "doc-map" "real project adapter EN/PT-BR pair configured"
  } else {
    Add-Result $results "FAIL" "doc-map" "Missing real project adapter EN/PT-BR pair"
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
