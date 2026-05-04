param(
  [ValidateSet("start","validate","release")]
  [string]$Mode = "start",
  [string]$Root = ".",
  [string]$Version = ""
)

$ErrorActionPreference = "Stop"

function Invoke-LocalTool {
  param(
    [string]$ToolsRoot,
    [string]$Name,
    [string[]]$Arguments
  )

  $script = Join-Path $ToolsRoot $Name
  if (-not (Test-Path -LiteralPath $script)) {
    Write-Error "Missing tool: $script"
    exit 1
  }

  & powershell -NoProfile -ExecutionPolicy Bypass -File $script @Arguments
  return $LASTEXITCODE
}

function Get-FrameworkVersion {
  param([string]$ResolvedRoot)

  $manifestPath = Join-Path $ResolvedRoot ".agents/config/framework-manifest.yaml"
  if (Test-Path -LiteralPath $manifestPath) {
    $text = Get-Content -LiteralPath $manifestPath -Raw
    if ($text -match 'framework_version:\s*"([^"]+)"') {
      return $Matches[1]
    }
  }

  return "unknown"
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$resolvedVersion = if ([string]::IsNullOrWhiteSpace($Version)) { Get-FrameworkVersion $resolvedRoot } else { $Version }

Write-Host "HEPHAESTUS daily mode: $Mode"
Write-Host "Root: $resolvedRoot"
Write-Host "Version: $resolvedVersion"
Write-Host ""

switch ($Mode) {
  "start" {
    $exit = Invoke-LocalTool $toolsRoot "check-core-contract.ps1" @("-Root", $resolvedRoot)
    if ($exit -ne 0) { exit $exit }

    Write-Host ""
    Write-Host "Suggested next context:"
    Write-Host "- .agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md"
    Write-Host "- .agents/docs/pt-br/24-CLI-UNIFICADO-DO-OPERADOR.md"
    Write-Host "- .agents/docs/pt-br/25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md"
    Write-Host ""
    Write-Host "Daily start summary: PASS"
    exit 0
  }

  "validate" {
    $exit = Invoke-LocalTool $toolsRoot "validate-framework.ps1" @("-Root", $resolvedRoot, "-StrictReferences")
    if ($exit -ne 0) { exit $exit }

    $exit = Invoke-LocalTool $toolsRoot "check-doc-parity.ps1" @("-Root", $resolvedRoot)
    if ($exit -ne 0) { exit $exit }

    Write-Host ""
    Write-Host "Daily validate summary: PASS"
    exit 0
  }

  "release" {
    $exit = Invoke-LocalTool $toolsRoot "pre-release-gate.ps1" @("-Root", $resolvedRoot, "-Version", $resolvedVersion)
    if ($exit -ne 0) { exit $exit }

    Write-Host ""
    Write-Host "Daily release summary: PASS"
    Write-Host "Next: package with hephaestus.ps1 -Action package -Version $resolvedVersion"
    exit 0
  }
}
