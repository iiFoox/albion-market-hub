param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

function Add-Result {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Level,
    [string]$Fixture,
    [string]$Check,
    [string]$Message
  )

  $List.Add([pscustomobject]@{
    Level = $Level
    Fixture = $Fixture
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

function Get-SectionScalar {
  param([string[]]$Lines, [string]$Section, [string]$Key)
  $inSection = $false
  $indent = $null
  foreach ($line in $Lines) {
    if ($line -match "^(\s*)$([regex]::Escape($Section)):\s*$") {
      $inSection = $true
      $indent = $Matches[1].Length
      continue
    }
    if ($inSection) {
      if ($line -match "^(\s*)[A-Za-z0-9_-]+:\s*" -and $Matches[1].Length -le $indent) {
        break
      }
      if ($line -match "^\s*$([regex]::Escape($Key)):\s*`"?([^`"]+)`"?\s*$") {
        return $Matches[1].Trim()
      }
    }
  }
  return $null
}

function Get-SectionList {
  param([string[]]$Lines, [string]$SectionPath)
  $items = New-Object System.Collections.Generic.List[string]
  $parts = $SectionPath.Split(".")
  $stack = @{}
  $capture = $false
  $captureIndent = $null

  foreach ($line in $Lines) {
    if ($line -match '^(\s*)([A-Za-z0-9_-]+):\s*$') {
      $indent = $Matches[1].Length
      $name = $Matches[2]
      $stack[$indent] = $name
      foreach ($key in @($stack.Keys)) {
        if ([int]$key -gt $indent) { $stack.Remove($key) }
      }
      $path = ($stack.Keys | Sort-Object {[int]$_} | ForEach-Object { $stack[$_] }) -join "."
      if ($path -eq $SectionPath) {
        $capture = $true
        $captureIndent = $indent
        continue
      }
      if ($capture -and $indent -le $captureIndent) {
        $capture = $false
      }
    } elseif ($capture -and $line -match '^\s*-\s+"?([^"]+)"?\s*$') {
      $items.Add($Matches[1]) | Out-Null
    }
  }

  return $items
}

function Infer-Routing {
  param([string]$Request)

  $text = $Request.ToLowerInvariant()
  $level = "LITE"
  $workflow = "quick-fix"
  $agents = New-Object System.Collections.Generic.HashSet[string]
  foreach ($a in @("orchestrator")) { $agents.Add($a) | Out-Null }
  $simpleFix = $text -match "fix|typo|rename|style|format|config" -and $text -notmatch "create|add|implement|feature|responsive|platform|plugin|security|auth|production|migration"

  if ($text -match "do not change files|do not edit files|review") {
    $workflow = if ($text -match "research") { "research-only" } else { "review-only" }
  }

  if ($text -match "research|compare|whether we should") {
    $level = "STANDARD"
    $workflow = "research-only"
    $agents.Add("researcher") | Out-Null
  }

  if (-not $simpleFix -and $text -match "create|add|implement|feature|screen|responsive|loading states") {
    $level = "STANDARD"
    if ($workflow -eq "quick-fix") { $workflow = "full-pipeline" }
    foreach ($a in @("planner","builder","validator")) { $agents.Add($a) | Out-Null }
  }

  if (-not $simpleFix -and $text -match "ui|screen|responsive|layout|visual|design") {
    $workflow = "ui-workflow"
    $agents.Add("ui-ux-specialist") | Out-Null
  }

  if ($text -match "flutter|web|android|ios|windows|plugin|platform") {
    if ($level -eq "LITE") { $level = "STANDARD" }
    if ($workflow -eq "quick-fix") { $workflow = "full-pipeline" }
    foreach ($a in @("researcher","builder","platform-guardian","validator")) { $agents.Add($a) | Out-Null }
  }

  if ($text -match "auth|authentication|authorization|security|unauthorized|token") {
    $level = "DEEP"
    $workflow = "full-pipeline"
    foreach ($a in @("researcher","planner","builder","validator","documentation")) { $agents.Add($a) | Out-Null }
  }

  if ($text -match "production|payment|financial|health|compliance|database migration|rollback|customer data") {
    $level = "CRITICAL"
    $workflow = "full-pipeline"
    foreach ($a in @("researcher","planner","builder","validator","documentation","project-manager","delivery")) { $agents.Add($a) | Out-Null }
  }

  if ($workflow -eq "review-only") {
    $level = if ($level -eq "LITE") { "STANDARD" } else { $level }
    $agents.Add("validator") | Out-Null
    $agents.Remove("builder") | Out-Null
  }

  if ($workflow -eq "research-only") {
    $agents.Remove("builder") | Out-Null
  } elseif ($level -eq "LITE") {
    $agents.Add("builder") | Out-Null
  }

  return [pscustomobject]@{
    Level = $level
    Workflow = $workflow
    Agents = @($agents)
  }
}

$resolvedRoot = (Resolve-Path $Root).Path
$fixturesDir = Join-Path $resolvedRoot ".agents/tests/fixtures"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $fixturesDir)) {
  Add-Result $results "FAIL" "(suite)" "fixtures" "Missing .agents/tests/fixtures"
  $results | Format-Table -AutoSize
  exit 1
}

$levelRank = @{ LITE = 1; STANDARD = 2; DEEP = 3; CRITICAL = 4 }
$fixtures = @(Get-ChildItem -LiteralPath $fixturesDir -File -Filter "*.yaml")

foreach ($fixture in $fixtures) {
  $lines = Get-Content -LiteralPath $fixture.FullName
  $id = Get-Scalar $lines "id"
  $request = Get-Scalar $lines "request"
  $expectedLevel = Get-SectionScalar $lines "expected" "min_level"
  $expectedWorkflow = Get-SectionScalar $lines "expected" "workflow"
  $requiredAgents = Get-SectionList $lines "expected.required_agents"
  $forbiddenAgents = Get-SectionList $lines "expected.forbidden_agents"

  $actual = Infer-Routing -Request $request
  $fixtureName = if ($id) { $id } else { $fixture.BaseName }

  if ($levelRank[$actual.Level] -ge $levelRank[$expectedLevel]) {
    Add-Result $results "PASS" $fixtureName "level" "$($actual.Level) >= $expectedLevel"
  } else {
    Add-Result $results "FAIL" $fixtureName "level" "Expected at least $expectedLevel, got $($actual.Level)"
  }

  if ($actual.Workflow -eq $expectedWorkflow) {
    Add-Result $results "PASS" $fixtureName "workflow" $actual.Workflow
  } else {
    Add-Result $results "FAIL" $fixtureName "workflow" "Expected $expectedWorkflow, got $($actual.Workflow)"
  }

  foreach ($agent in $requiredAgents) {
    if ($actual.Agents -contains $agent) {
      Add-Result $results "PASS" $fixtureName "required-agent" $agent
    } else {
      Add-Result $results "FAIL" $fixtureName "required-agent" "Missing $agent"
    }
  }

  foreach ($agent in $forbiddenAgents) {
    if ($actual.Agents -contains $agent) {
      Add-Result $results "FAIL" $fixtureName "forbidden-agent" "$agent was activated"
    } else {
      Add-Result $results "PASS" $fixtureName "forbidden-agent" "$agent not activated"
    }
  }
}

$results | Sort-Object Level, Fixture, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -gt 0) {
  exit 1
}

exit 0
