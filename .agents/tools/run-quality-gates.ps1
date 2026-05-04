param(
  [string]$Root = ".",
  [string[]]$GateNames = @(),
  [switch]$WriteReport
)

$ErrorActionPreference = "Stop"

function Add-Result {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Gate,
    [string]$Status,
    [int]$ExitCode,
    [string]$Notes,
    [string]$Output = ""
  )

  $List.Add([pscustomobject]@{
    Gate = $Gate
    Status = $Status
    ExitCode = $ExitCode
    Notes = $Notes
    Output = $Output
  }) | Out-Null
}

function ConvertTo-CompactOutput {
  param([object[]]$Output)

  $lines = @($Output | ForEach-Object { $_.ToString() })
  if ($lines.Count -eq 0) {
    return ""
  }

  $excerpt = @($lines | Select-Object -First 12)
  return ($excerpt -join "`n")
}

function Test-DangerousCommand {
  param([string]$Command)

  $patterns = @(
    '\bRemove-Item\b.*-Recurse\b',
    '\bRemove-Item\b.*-Force\b',
    '\brm\s+-rf\b',
    '\brmdir\s+/s\b',
    '\bdel\s+/[fsq]\b',
    '\bgit\s+reset\s+--hard\b',
    '\bgit\s+clean\s+-f',
    '\bformat\b',
    '\bshutdown\b',
    '\brestart-computer\b',
    '\breg\s+delete\b',
    '\bdrop\s+database\b',
    '\bdrop\s+table\b'
  )

  foreach ($pattern in $patterns) {
    if ($Command -match $pattern) {
      return $pattern
    }
  }

  return ""
}

function Read-AdapterCommands {
  param([string]$ConfigPath)

  $commands = @{}
  $inCommands = $false
  $current = ""

  foreach ($line in (Get-Content -LiteralPath $ConfigPath)) {
    if ($line -match '^commands:\s*$') {
      $inCommands = $true
      continue
    }

    if ($inCommands -and $line -match '^[A-Za-z0-9_-]+:\s*') {
      break
    }

    if ($inCommands -and $line -match '^\s{2}([A-Za-z0-9_-]+):\s*$') {
      $current = $Matches[1]
      $commands[$current] = [pscustomobject]@{
        Name = $current
        Command = ""
        Allowed = $false
      }
      continue
    }

    if ($inCommands -and -not [string]::IsNullOrWhiteSpace($current) -and $line -match '^\s{4}command:\s*(.*)\s*$') {
      $value = $Matches[1].Trim()
      if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
        $value = $value.Substring(1, $value.Length - 2)
      }
      $commands[$current].Command = $value
      continue
    }

    if ($inCommands -and -not [string]::IsNullOrWhiteSpace($current) -and $line -match '^\s{4}allowed:\s*(true|false)\s*$') {
      $commands[$current].Allowed = ($Matches[1] -eq "true")
      continue
    }
  }

  return $commands
}

function Write-GateReport {
  param(
    [string]$ReportPath,
    [string]$ProjectRoot,
    [System.Collections.Generic.List[object]]$Results
  )

  $status = "PASS"
  if (@($Results | Where-Object { $_.Status -in @("FAIL", "DENIED") }).Count -gt 0) {
    $status = "FAIL"
  }

  $passed = @($Results | Where-Object { $_.Status -eq "PASS" }).Count
  $failed = @($Results | Where-Object { $_.Status -eq "FAIL" }).Count
  $denied = @($Results | Where-Object { $_.Status -eq "DENIED" }).Count
  $skipped = @($Results | Where-Object { $_.Status -eq "SKIP" }).Count

  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("---") | Out-Null
  $content.Add('log_type: "command-quality-gates"') | Out-Null
  $content.Add('framework_version: "7.5.0"') | Out-Null
  $content.Add("project_root: `"$ProjectRoot`"") | Out-Null
  $content.Add("status: `"$status`"") | Out-Null
  $generatedAt = (Get-Date).ToString("o")
  $content.Add("generated_at: `"$generatedAt`"") | Out-Null
  $content.Add("---") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("# Command Quality Gate Report") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Summary") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("- Passed: $passed") | Out-Null
  $content.Add("- Failed: $failed") | Out-Null
  $content.Add("- Denied: $denied") | Out-Null
  $content.Add("- Skipped: $skipped") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("## Gate Results") | Out-Null
  $content.Add("") | Out-Null
  $content.Add("| Gate | Status | Exit Code | Notes |") | Out-Null
  $content.Add("|---|---:|---:|---|") | Out-Null

  foreach ($result in $Results) {
    $notes = $result.Notes.Replace("|", "/")
    $content.Add("| $($result.Gate) | $($result.Status) | $($result.ExitCode) | $notes |") | Out-Null
  }

  $content.Add("") | Out-Null
  $content.Add("## Output Excerpts") | Out-Null
  foreach ($result in $Results) {
    if (-not [string]::IsNullOrWhiteSpace($result.Output)) {
      $content.Add("") | Out-Null
      $content.Add("### $($result.Gate)") | Out-Null
      $content.Add("") | Out-Null
      $content.Add('```text') | Out-Null
      $content.Add($result.Output) | Out-Null
      $content.Add('```') | Out-Null
    }
  }

  $reportDir = Split-Path -Parent $ReportPath
  if (-not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  }
  Set-Content -LiteralPath $ReportPath -Value $content -Encoding UTF8
}

$resolvedRoot = (Resolve-Path $Root).Path
$configPath = Join-Path $resolvedRoot ".agents/config/project.yaml"
$results = New-Object System.Collections.Generic.List[object]

if (-not (Test-Path -LiteralPath $configPath)) {
  Add-Result $results "adapter" "FAIL" 1 "Missing .agents/config/project.yaml"
} else {
  $commands = Read-AdapterCommands $configPath
  $requested = @($GateNames | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() })
  $selected = New-Object System.Collections.Generic.List[string]

  if ($requested.Count -gt 0) {
    foreach ($gate in $requested) {
      $selected.Add($gate) | Out-Null
    }
  } else {
    foreach ($key in @("test", "lint", "build", "format", "install", "dev")) {
      if ($commands.ContainsKey($key) -and $commands[$key].Allowed -and -not [string]::IsNullOrWhiteSpace($commands[$key].Command)) {
        $selected.Add($key) | Out-Null
      }
    }
  }

  if ($selected.Count -eq 0) {
    Add-Result $results "quality-gates" "PASS" 0 "No allowed quality gates configured; no-op"
  } else {
    foreach ($gate in $selected) {
      if (-not $commands.ContainsKey($gate)) {
        Add-Result $results $gate "SKIP" 0 "Gate not configured"
        continue
      }

      $entry = $commands[$gate]
      if (-not $entry.Allowed) {
        Add-Result $results $gate "SKIP" 0 "Gate not allowed"
        continue
      }

      if ([string]::IsNullOrWhiteSpace($entry.Command)) {
        Add-Result $results $gate "SKIP" 0 "Gate command is empty"
        continue
      }

      $danger = Test-DangerousCommand $entry.Command
      if (-not [string]::IsNullOrWhiteSpace($danger)) {
        Add-Result $results $gate "DENIED" 1 "Command denied by destructive pattern: $danger"
        continue
      }

      Push-Location $resolvedRoot
      try {
        $output = & powershell -NoProfile -ExecutionPolicy Bypass -Command $entry.Command 2>&1
        $exitCode = $LASTEXITCODE
      } finally {
        Pop-Location
      }

      if ($exitCode -eq 0) {
        Add-Result $results $gate "PASS" 0 "Command completed" (ConvertTo-CompactOutput $output)
      } else {
        Add-Result $results $gate "FAIL" $exitCode "Command failed" (ConvertTo-CompactOutput $output)
      }
    }
  }
}

if ($WriteReport) {
  Write-GateReport (Join-Path $resolvedRoot ".agents/reports/executions/quality-gates-latest.md") $resolvedRoot $results
}

$results | Format-Table -AutoSize
$summary = $results | Group-Object Status | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Quality gate summary: $($summary -join ', ')"

if (@($results | Where-Object { $_.Status -in @("FAIL", "DENIED") }).Count -gt 0) {
  exit 1
}

exit 0




