param(
  [string]$Root = ".",
  [switch]$StrictReferences
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

function Get-ManifestScalar {
  param([string[]]$Lines, [string]$Key)
  $pattern = "^\s*$([regex]::Escape($Key)):\s*`"?([^`"]+)`"?\s*$"
  foreach ($line in $Lines) {
    if ($line -match $pattern) {
      return $Matches[1].Trim()
    }
  }
  return $null
}

function Get-ManifestInt {
  param([string[]]$Lines, [string]$Key)
  $value = Get-ManifestScalar -Lines $Lines -Key $Key
  if ($null -eq $value) { return $null }
  return [int]$value
}

function Get-ManifestList {
  param([string[]]$Lines, [string]$Section)

  $items = New-Object System.Collections.Generic.List[string]
  $inSection = $false
  $sectionIndent = $null

  foreach ($line in $Lines) {
    if ($line -match "^(\s*)$([regex]::Escape($Section)):\s*$") {
      $inSection = $true
      $sectionIndent = $Matches[1].Length
      continue
    }

    if ($inSection) {
      if ($line -match "^(\s*)[A-Za-z0-9_-]+:\s*" -and $Matches[1].Length -le $sectionIndent) {
        break
      }
      if ($line -match '^\s*-\s+"?([^"]+)"?\s*$') {
        $items.Add($Matches[1]) | Out-Null
      }
    }
  }

  return $items
}

$resolvedRoot = (Resolve-Path $Root).Path
$agentsRoot = Join-Path $resolvedRoot ".agents"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $agentsRoot)) {
  Add-Result $results "FAIL" "root" "Missing .agents directory at $agentsRoot"
  $results | Format-Table -AutoSize
  exit 1
}

$manifestPath = Join-Path $agentsRoot "config/framework-manifest.yaml"
if (-not (Test-Path -LiteralPath $manifestPath)) {
  Add-Result $results "FAIL" "manifest" "Missing .agents/config/framework-manifest.yaml"
  $results | Format-Table -AutoSize
  exit 1
}

$manifestLines = Get-Content -LiteralPath $manifestPath
$expectedVersion = Get-ManifestScalar $manifestLines "framework_version"
$expectedAgents = Get-ManifestInt $manifestLines "agents"
$expectedProtocols = Get-ManifestInt $manifestLines "protocols"
$expectedWorkflows = Get-ManifestInt $manifestLines "workflows"
$expectedMemoryStores = Get-ManifestInt $manifestLines "memory_stores"
$expectedDocLanguages = Get-ManifestInt $manifestLines "docs_languages"
$requiredFiles = Get-ManifestList $manifestLines "required_files"
$requiredDirectories = Get-ManifestList $manifestLines "required_directories"

foreach ($relative in $requiredFiles) {
  $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-file" $relative
  } else {
    Add-Result $results "FAIL" "required-file" "Missing $relative"
  }
}

foreach ($relative in $requiredDirectories) {
  $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
  if (Test-Path -LiteralPath $path) {
    Add-Result $results "PASS" "required-directory" $relative
  } else {
    Add-Result $results "FAIL" "required-directory" "Missing $relative"
  }
}

$agentDirs = @(Get-ChildItem -LiteralPath (Join-Path $agentsRoot "agents") -Directory)
$protocolFiles = @(Get-ChildItem -LiteralPath (Join-Path $agentsRoot "protocols") -File -Filter "*.md")
$workflowFiles = @(Get-ChildItem -LiteralPath (Join-Path $agentsRoot "workflows") -File -Filter "*.md")
$memoryStores = @(
  "knowledge-graph",
  "learning-store",
  "evolution-log",
  "context-db"
) | Where-Object { Test-Path -LiteralPath (Join-Path $agentsRoot "memory/$_") }
$docLanguages = @(Get-ChildItem -LiteralPath (Join-Path $agentsRoot "docs") -Directory | Where-Object { $_.Name -in @("en", "pt-br") })

if ($agentDirs.Count -eq $expectedAgents) { Add-Result $results "PASS" "count" "agents=$($agentDirs.Count)" } else { Add-Result $results "FAIL" "count" "agents expected $expectedAgents, found $($agentDirs.Count)" }
if ($protocolFiles.Count -eq $expectedProtocols) { Add-Result $results "PASS" "count" "protocols=$($protocolFiles.Count)" } else { Add-Result $results "FAIL" "count" "protocols expected $expectedProtocols, found $($protocolFiles.Count)" }
if ($workflowFiles.Count -eq $expectedWorkflows) { Add-Result $results "PASS" "count" "workflows=$($workflowFiles.Count)" } else { Add-Result $results "FAIL" "count" "workflows expected $expectedWorkflows, found $($workflowFiles.Count)" }
if ($memoryStores.Count -eq $expectedMemoryStores) { Add-Result $results "PASS" "count" "memory_stores=$($memoryStores.Count)" } else { Add-Result $results "FAIL" "count" "memory stores expected $expectedMemoryStores, found $($memoryStores.Count)" }
if ($docLanguages.Count -eq $expectedDocLanguages) { Add-Result $results "PASS" "count" "docs_languages=$($docLanguages.Count)" } else { Add-Result $results "FAIL" "count" "doc languages expected $expectedDocLanguages, found $($docLanguages.Count)" }

foreach ($agent in $agentDirs) {
  foreach ($fileName in @("AGENT.md", "capabilities.yaml")) {
    $path = Join-Path $agent.FullName $fileName
    if (Test-Path -LiteralPath $path) {
      Add-Result $results "PASS" "agent-contract" "$($agent.Name)/$fileName"
    } else {
      Add-Result $results "FAIL" "agent-contract" "Missing $($agent.Name)/$fileName"
    }
  }
}

$versionFiles = @(
  ".agents/config/framework.yaml",
  ".agents/config/agent-registry.yaml",
  ".agents/AGENTS.md",
  ".agents/docs/README.md",
  ".agents/docs/en/README.md",
  ".agents/docs/pt-br/README.md"
)

foreach ($relative in $versionFiles) {
  $path = Join-Path $resolvedRoot ($relative -replace "/", "\")
  if (-not (Test-Path -LiteralPath $path)) { continue }
  $text = Get-Content -LiteralPath $path -Raw
  if ($text -match [regex]::Escape($expectedVersion)) {
    Add-Result $results "PASS" "version" "$relative contains $expectedVersion"
  } else {
    Add-Result $results "FAIL" "version" "$relative does not contain $expectedVersion"
  }
}

$markdownFiles = @(Get-ChildItem -LiteralPath $agentsRoot -Recurse -File -Filter "*.md")
foreach ($file in $markdownFiles) {
  $text = Get-Content -LiteralPath $file.FullName -Raw
  $dir = $file.DirectoryName
  foreach ($match in [regex]::Matches($text, '\[[^\]]+\]\(([^)]+\.md(?:#[^)]+)?)\)')) {
    $target = $match.Groups[1].Value
    if ($target -match '^(https?:)') { continue }
    $clean = $target.Split("#")[0]
    $targetPath = Join-Path $dir $clean
    if (-not (Test-Path -LiteralPath $targetPath)) {
      Add-Result $results "FAIL" "markdown-link" "$($file.FullName.Substring($resolvedRoot.Length + 1)) -> $target"
    }
  }
}

foreach ($file in @(Get-ChildItem -LiteralPath $agentsRoot -Recurse -File -Include "*.md","*.yaml")) {
  $relativeFile = $file.FullName.Substring($resolvedRoot.Length + 1)
  if ($relativeFile -match '^\.agents\\ROADMAP' -or $relativeFile -match '^\.agents\\releases\\CHANGELOG\.md$') {
    continue
  }
  $text = Get-Content -LiteralPath $file.FullName -Raw
  foreach ($match in [regex]::Matches($text, '\.agents/[A-Za-z0-9_./-]+\.(?:md|yaml)')) {
    $relative = $match.Value
    $targetPath = Join-Path $resolvedRoot ($relative -replace "/", "\")
    if (-not (Test-Path -LiteralPath $targetPath)) {
      $level = if ($StrictReferences) { "FAIL" } else { "WARN" }
      Add-Result $results $level "agents-reference" "$relativeFile -> $relative"
    }
  }
}

$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

$failureCount = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failureCount -gt 0) {
  exit 1
}

exit 0
