param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

function Add-Result {
  param([System.Collections.Generic.List[object]]$List,[string]$Level,[string]$Check,[string]$Message)
  $List.Add([pscustomobject]@{ Level=$Level; Check=$Check; Message=$Message }) | Out-Null
}

function Test-File {
  param([System.Collections.Generic.List[object]]$Results,[string]$Root,[string]$RelativePath)
  $path = Join-Path $Root ($RelativePath -replace "/", "\")
  if (Test-Path -LiteralPath $path -PathType Leaf) { Add-Result $Results "PASS" "required-file" $RelativePath } else { Add-Result $Results "FAIL" "required-file" "Missing $RelativePath" }
}

function Test-Contains {
  param([System.Collections.Generic.List[object]]$Results,[string]$Path,[string]$Pattern,[string]$Check)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { Add-Result $Results "FAIL" $Check "Missing $Path"; return }
  $text = Get-Content -LiteralPath $Path -Raw
  if ($text -match $Pattern) { Add-Result $Results "PASS" $Check "Found expected marker" } else { Add-Result $Results "FAIL" $Check "Missing expected marker: $Pattern" }
}

$resolvedRoot = (Resolve-Path $Root).Path
$results = New-Object System.Collections.Generic.List[object]
$requiredFiles = @(
  ".agents/protocols/practical-first-project-walkthrough-protocol.md",
  ".agents/tools/check-first-project-walkthrough.ps1",
  ".agents/docs/en/31-PRACTICAL-FIRST-PROJECT-WALKTHROUGH.md",
  ".agents/docs/pt-br/31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md"
)
foreach ($file in $requiredFiles) { Test-File $results $resolvedRoot $file }

$framework = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$loading = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$gate = Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1"
$cli = Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1"
$map = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"
$enGuide = Join-Path $resolvedRoot ".agents/docs/en/31-PRACTICAL-FIRST-PROJECT-WALKTHROUGH.md"
$ptGuide = Join-Path $resolvedRoot ".agents/docs/pt-br/31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md"

Test-Contains $results $framework "practical_first_project_walkthrough:" "framework-config"
Test-Contains $results $framework "check-first-project-walkthrough.ps1" "framework-checker"
Test-Contains $results $loading "first-project-walkthrough:" "loading-group"
Test-Contains $results $gate "first-project-walkthrough" "pre-release-check"
Test-Contains $results $cli "check-first-project-walkthrough.ps1" "doctor-check"
Test-Contains $results $map "31-PRACTICAL-FIRST-PROJECT-WALKTHROUGH.md" "translation-map-en"
Test-Contains $results $map "31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md" "translation-map-pt-br"

foreach ($marker in @("New Project","Existing Project","HEPHAESTUS-FIRST-CALL.md","START-HEPHAESTUS.bat","bootstrap","project-adapter-draft.yaml","Project Discovery","DryRun")) {
  Test-Contains $results $enGuide ([regex]::Escape($marker)) "en-$marker"
}
foreach ($marker in @("Projeto Novo","Projeto Existente","HEPHAESTUS-FIRST-CALL.md","START-HEPHAESTUS.bat","bootstrap","project-adapter-draft.yaml","Project Discovery","DryRun")) {
  Test-Contains $results $ptGuide ([regex]::Escape($marker)) "pt-br-$marker"
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"
if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0

