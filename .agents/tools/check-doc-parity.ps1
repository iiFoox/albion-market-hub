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

function Get-Scalar {
  param([string[]]$Lines, [string]$Key)
  foreach ($line in $Lines) {
    if ($line -match "^\s*$([regex]::Escape($Key)):\s*`"?([^`"]+)`"?\s*$") {
      return $Matches[1].Trim()
    }
  }
  return $null
}

function Get-Pairs {
  param([string[]]$Lines)
  $pairs = New-Object System.Collections.Generic.List[object]
  $current = $null

  foreach ($line in $Lines) {
    if ($line -match '^\s*-\s+en:\s+"?([^"]+)"?\s*$') {
      $current = [ordered]@{ en = $Matches[1]; ptbr = $null }
      continue
    }
    if ($null -ne $current -and $line -match '^\s+pt-br:\s+"?([^"]+)"?\s*$') {
      $current.ptbr = $Matches[1]
      $pairs.Add([pscustomobject]$current) | Out-Null
      $current = $null
    }
  }

  return $pairs
}

$resolvedRoot = (Resolve-Path $Root).Path
$docsRoot = Join-Path $resolvedRoot ".agents/docs"
$mapPath = Join-Path $docsRoot "_translation-map.yaml"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $mapPath)) {
  Add-Result $results "FAIL" "map" "Missing .agents/docs/_translation-map.yaml"
  $results | Format-Table -AutoSize
  exit 1
}

$lines = Get-Content -LiteralPath $mapPath
$expectedVersion = Get-Scalar $lines "framework_version"
$expectedAgents = Get-Scalar $lines "agents"
$expectedProtocols = Get-Scalar $lines "protocols"
$expectedWorkflows = Get-Scalar $lines "workflows"
$pairs = Get-Pairs $lines

if ($pairs.Count -eq 0) {
  Add-Result $results "FAIL" "map" "No documentation pairs found"
} else {
  Add-Result $results "PASS" "map" "Pairs=$($pairs.Count)"
}

foreach ($pair in $pairs) {
  $enPath = Join-Path $docsRoot ("en/" + $pair.en -replace "/", "\")
  $ptPath = Join-Path $docsRoot ("pt-br/" + $pair.ptbr -replace "/", "\")

  if (Test-Path -LiteralPath $enPath) {
    Add-Result $results "PASS" "pair-en" $pair.en
  } else {
    Add-Result $results "FAIL" "pair-en" "Missing EN $($pair.en)"
  }

  if (Test-Path -LiteralPath $ptPath) {
    Add-Result $results "PASS" "pair-pt-br" $pair.ptbr
  } else {
    Add-Result $results "FAIL" "pair-pt-br" "Missing PT-BR $($pair.ptbr)"
  }
}

$enFiles = @(Get-ChildItem -LiteralPath (Join-Path $docsRoot "en") -Recurse -File -Filter "*.md" | ForEach-Object { $_.FullName.Substring((Join-Path $docsRoot "en").Length + 1).Replace("\","/") })
$ptFiles = @(Get-ChildItem -LiteralPath (Join-Path $docsRoot "pt-br") -Recurse -File -Filter "*.md" | ForEach-Object { $_.FullName.Substring((Join-Path $docsRoot "pt-br").Length + 1).Replace("\","/") })
$mappedEn = @($pairs | ForEach-Object { $_.en })
$mappedPt = @($pairs | ForEach-Object { $_.ptbr })

foreach ($file in $enFiles) {
  if ($mappedEn -notcontains $file) { Add-Result $results "FAIL" "unmapped-en" $file }
}
foreach ($file in $ptFiles) {
  if ($mappedPt -notcontains $file) { Add-Result $results "FAIL" "unmapped-pt-br" $file }
}

$versionFiles = @(
  ".agents/docs/README.md",
  ".agents/docs/en/README.md",
  ".agents/docs/pt-br/README.md",
  ".agents/docs/en/00-OVERVIEW.md",
  ".agents/docs/pt-br/00-OVERVIEW.md",
  ".agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md",
  ".agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md"
)

foreach ($relative in $versionFiles) {
  $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Result $results "FAIL" "version-file" "Missing $relative"
    continue
  }
  $text = Get-Content -LiteralPath $path -Raw
  if ($text -match [regex]::Escape($expectedVersion)) {
    Add-Result $results "PASS" "version" "$relative contains $expectedVersion"
  } else {
    Add-Result $results "FAIL" "version" "$relative missing $expectedVersion"
  }
}

$enRef = Get-Content -LiteralPath (Join-Path $docsRoot "en/HEPHAESTUS-COMPLETE-REFERENCE.md") -Raw
$ptRef = Get-Content -LiteralPath (Join-Path $docsRoot "pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md") -Raw

foreach ($expected in @($expectedAgents, $expectedProtocols, $expectedWorkflows)) {
  if ($enRef -match "\|\s*$expected\s*\|" -or $enRef -match "\b$expected\b") {
    Add-Result $results "PASS" "reference-count-en" "Contains $expected"
  } else {
    Add-Result $results "FAIL" "reference-count-en" "Missing $expected"
  }
  if ($ptRef -match "\|\s*$expected\s*\|" -or $ptRef -match "\b$expected\b") {
    Add-Result $results "PASS" "reference-count-pt-br" "Contains $expected"
  } else {
    Add-Result $results "FAIL" "reference-count-pt-br" "Missing $expected"
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
