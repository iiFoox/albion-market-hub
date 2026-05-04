param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$resolvedRoot = (Resolve-Path $Root).Path
$runner = Join-Path $resolvedRoot ".agents/tools/run-stability-baseline.ps1"

if (-not (Test-Path -LiteralPath $runner)) {
  Write-Host "Level Check Message"
  Write-Host "FAIL runner Missing .agents/tools/run-stability-baseline.ps1"
  exit 1
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $runner -Root $resolvedRoot -WriteReport
exit $LASTEXITCODE
