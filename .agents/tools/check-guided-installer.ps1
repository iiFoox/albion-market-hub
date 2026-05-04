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

function Test-File {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Root,
    [string]$RelativePath
  )

  $path = Join-Path $Root ($RelativePath -replace "/", "\")
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Add-Result $Results "PASS" "required-file" $RelativePath
  } else {
    Add-Result $Results "FAIL" "required-file" "Missing $RelativePath"
  }
}

function Test-Contains {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Path,
    [string]$Pattern,
    [string]$Check
  )

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Add-Result $Results "FAIL" $Check "Missing $Path"
    return
  }

  $text = Get-Content -LiteralPath $Path -Raw
  if ($text -match $Pattern) {
    Add-Result $Results "PASS" $Check "Found expected marker"
  } else {
    Add-Result $Results "FAIL" $Check "Missing expected marker: $Pattern"
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$results = New-Object System.Collections.Generic.List[object]

$requiredFiles = @(
  ".agents/protocols/guided-installer-repository-onboarding-protocol.md",
  ".agents/tools/check-guided-installer.ps1",
  ".agents/tools/install-hephaestus-launcher.ps1",
  ".agents/tools/install-hephaestus.bat",
  ".agents/docs/en/30-GUIDED-INSTALLER-REPOSITORY-ONBOARDING.md",
  ".agents/docs/pt-br/30-INSTALADOR-GUIADO-E-ONBOARDING-DE-REPOSITORIO.md"
)

foreach ($file in $requiredFiles) {
  Test-File $results $resolvedRoot $file
}

$launcher = Join-Path $resolvedRoot ".agents/tools/install-hephaestus-launcher.ps1"
$bat = Join-Path $resolvedRoot ".agents/tools/install-hephaestus.bat"
$cli = Join-Path $resolvedRoot ".agents/tools/hephaestus.ps1"
$framework = Join-Path $resolvedRoot ".agents/config/framework.yaml"
$loading = Join-Path $resolvedRoot ".agents/config/loading-tiers.yaml"
$gate = Join-Path $resolvedRoot ".agents/tools/pre-release-gate.ps1"
$map = Join-Path $resolvedRoot ".agents/docs/_translation-map.yaml"

foreach ($mode in @("none","local","github","gitlab","bitbucket","other","existing")) {
  Test-Contains $results $launcher $mode "launcher-repository-mode-$mode"
  Test-Contains $results $bat $mode "bat-repository-mode-$mode"
}

Test-Contains $results $launcher "HEPHAESTUS-FIRST-CALL.md" "first-call-prompt"
Test-Contains $results $launcher "START-HEPHAESTUS.bat" "first-call-launcher"
Test-Contains $results $launcher "repository-setup-latest.md" "repository-report"
Test-Contains $results $launcher "No Git mutation will be performed" "no-git-mutation"
Test-Contains $results $launcher "ProjectState" "project-state"
Test-Contains $results $launcher "OpenFirstCall" "open-first-call"
Test-Contains $results $cli "RepositoryMode" "cli-repository-mode"
Test-Contains $results $cli "install-hephaestus-launcher.ps1" "cli-guided-installer"
Test-Contains $results $framework "guided_installer_repository_onboarding:" "framework-config"
Test-Contains $results $framework "check-guided-installer.ps1" "framework-checker"
Test-Contains $results $loading "guided-installer:" "loading-group"
Test-Contains $results $gate "guided-installer" "pre-release-check"
Test-Contains $results $map "30-GUIDED-INSTALLER-REPOSITORY-ONBOARDING.md" "translation-map-en"
Test-Contains $results $map "30-INSTALADOR-GUIADO-E-ONBOARDING-DE-REPOSITORIO.md" "translation-map-pt-br"

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
