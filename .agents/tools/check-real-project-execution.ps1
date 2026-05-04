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
$loadingPath = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$projectPath = Join-Path $resolvedRoot ".agents/config/project.yaml"
$protocolPath = Join-Path $resolvedRoot ".agents/protocols/developer-real-project-execution-protocol.md"
$workflowPath = Join-Path $resolvedRoot ".agents/workflows/real-project-execution-workflow.md"
$templatePath = Join-Path $resolvedRoot ".agents/reports/executions/real-project-execution-plan-template.md"
$runToolPath = Join-Path $resolvedRoot ".agents/tools/run-real-project-execution.ps1"
$testToolPath = Join-Path $resolvedRoot ".agents/tools/test-real-project-execution.ps1"
$docsEnPath = Join-Path $resolvedRoot ".agents/docs/en/14-REAL-PROJECT-EXECUTION.md"
$docsPtPath = Join-Path $resolvedRoot ".agents/docs/pt-br/14-EXECUCAO-EM-PROJETO-REAL.md"
$mapPath = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"

$results = New-Object System.Collections.Generic.List[object]

foreach ($path in @($frameworkPath, $loadingPath, $projectPath, $protocolPath, $workflowPath, $templatePath, $runToolPath, $testToolPath, $docsEnPath, $docsPtPath, $mapPath)) {
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $results "PASS" "required-file" $path.Substring($resolvedRoot.Length + 1)
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $path"
  }
}

if (Test-Path -LiteralPath $frameworkPath) {
  $framework = Get-Content -LiteralPath $frameworkPath -Raw
  if ($framework.Contains("real_project_execution:")) {
    Add-Result $results "PASS" "framework-config" "real_project_execution configured"
  } else {
    Add-Result $results "FAIL" "framework-config" "Missing real_project_execution config"
  }
}

if (Test-Path -LiteralPath $loadingPath) {
  $loading = Get-Content -LiteralPath $loadingPath -Raw
  if ($loading -match '(?s)real-execution:\s+trigger:.*real.*execution.*files:') {
    Add-Result $results "PASS" "loading" "real-execution conditional group configured"
  } else {
    Add-Result $results "FAIL" "loading" "Missing real-execution conditional loading group"
  }
}

if (Test-Path -LiteralPath $projectPath) {
  $project = Get-Content -LiteralPath $projectPath -Raw
  foreach ($field in @("require_plan_before_changes: true", "require_approval_before_apply: true", "backup_before_mutation: true", "allow_destructive_commands: false")) {
    if ($project.Contains($field)) {
      Add-Result $results "PASS" "project-safety" $field
    } else {
      Add-Result $results "FAIL" "project-safety" "Missing $field"
    }
  }
}

if (Test-Path -LiteralPath $mapPath) {
  $map = Get-Content -LiteralPath $mapPath -Raw
  if ($map.Contains('14-REAL-PROJECT-EXECUTION.md') -and $map.Contains('14-EXECUCAO-EM-PROJETO-REAL.md')) {
    Add-Result $results "PASS" "doc-map" "real project execution EN/PT-BR pair configured"
  } else {
    Add-Result $results "FAIL" "doc-map" "Missing real project execution EN/PT-BR pair"
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
