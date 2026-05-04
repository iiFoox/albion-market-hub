param(
  [string]$Root = ".",
  [string]$Scenario = "profile-card",
  [string]$WorkRoot = "",
  [switch]$KeepWorkspace,
  [switch]$WriteReport
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

function Write-TextFile {
  param(
    [string]$Path,
    [string]$Content
  )

  $dir = Split-Path -Parent $Path
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
  }
  Set-Content -LiteralPath $Path -Value $Content -NoNewline
}

$resolvedRoot = (Resolve-Path $Root).Path
$toolsRoot = Join-Path $resolvedRoot ".agents/tools"
$results = New-Object System.Collections.Generic.List[object]

$createdWorkRoot = $false
if ([string]::IsNullOrWhiteSpace($WorkRoot)) {
  $WorkRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("hephaestus-dev-exec-" + [guid]::NewGuid().ToString("N"))
  $createdWorkRoot = $true
}

$resolvedWorkRoot = [System.IO.Path]::GetFullPath($WorkRoot)
$targetProject = Join-Path $resolvedWorkRoot "developer-execution-project"
$appRoot = Join-Path $targetProject "app"
$srcRoot = Join-Path $appRoot "src"
$testRoot = Join-Path $appRoot "tests"
$docsRoot = Join-Path $appRoot "docs"
$reportDir = Join-Path $resolvedRoot ".agents/reports/executions"
$reportPath = Join-Path $reportDir "latest.md"

try {
  New-Item -ItemType Directory -Path $targetProject -Force | Out-Null
  Add-Result $results "PASS" "workspace" $resolvedWorkRoot

  $install = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolsRoot "install-framework.ps1") -SourceRoot $resolvedRoot -TargetRoot $targetProject -Apply 2>&1
  if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath (Join-Path $targetProject ".agents"))) {
    Add-Result $results "PASS" "install" "Framework installed into isolated developer workspace"
  } else {
    Add-Result $results "FAIL" "install" ($install | Out-String).Trim()
  }

  $request = "Build a responsive user profile card with editable name, email, avatar URL, dark mode toggle, validation, and a compact delivery note."
  $plan = @(
    "orchestrator: classify request as STANDARD ui-workflow",
    "planner: define acceptance criteria",
    "builder: create HTML, CSS, and JavaScript",
    "ui-ux-specialist: ensure responsive profile card states",
    "validator: run local structural tests",
    "documentation: write delivery note"
  )

  Write-TextFile -Path (Join-Path $appRoot "REQUEST.md") -Content @"
# Developer Execution Request

Scenario: $Scenario

$request
"@

  Write-TextFile -Path (Join-Path $appRoot "PLAN.md") -Content @"
# Execution Plan

- $($plan -join "`n- ")
"@

  Write-TextFile -Path (Join-Path $appRoot "index.html") -Content @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Profile Card</title>
  <link rel="stylesheet" href="src/styles.css">
</head>
<body>
  <main class="shell">
    <section class="profile-card" aria-labelledby="profile-title">
      <img id="avatarPreview" class="avatar" src="https://example.com/avatar.png" alt="Profile avatar">
      <div class="content">
        <h1 id="profile-title">User Profile</h1>
        <label>Name <input id="nameInput" value="Ana Silva" autocomplete="name"></label>
        <label>Email <input id="emailInput" value="ana@example.com" autocomplete="email"></label>
        <label>Avatar URL <input id="avatarInput" value="https://example.com/avatar.png"></label>
        <label class="toggle"><input id="darkModeInput" type="checkbox"> Dark mode</label>
        <p id="status" role="status">Ready</p>
        <button id="saveButton" type="button">Save Profile</button>
      </div>
    </section>
  </main>
  <script src="src/profile.js"></script>
</body>
</html>
"@

  Write-TextFile -Path (Join-Path $srcRoot "styles.css") -Content @"
:root {
  color-scheme: light;
  font-family: Arial, sans-serif;
  background: #f4f7f8;
  color: #1f2933;
}

body.dark {
  color-scheme: dark;
  background: #111827;
  color: #f9fafb;
}

.shell {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 24px;
}

.profile-card {
  width: min(100%, 520px);
  display: grid;
  grid-template-columns: 112px 1fr;
  gap: 20px;
  padding: 20px;
  border: 1px solid #cbd5df;
  border-radius: 8px;
  background: #ffffff;
}

body.dark .profile-card {
  background: #1f2937;
  border-color: #4b5563;
}

.avatar {
  width: 112px;
  height: 112px;
  border-radius: 50%;
  object-fit: cover;
  background: #d9e2ec;
}

.content {
  display: grid;
  gap: 12px;
}

label {
  display: grid;
  gap: 4px;
  font-size: 14px;
}

input,
button {
  min-height: 40px;
  border-radius: 6px;
  border: 1px solid #9aa5b1;
  padding: 0 10px;
  font: inherit;
}

button {
  border: 0;
  background: #0f766e;
  color: #ffffff;
  cursor: pointer;
}

@media (max-width: 520px) {
  .profile-card {
    grid-template-columns: 1fr;
  }
}
"@

  Write-TextFile -Path (Join-Path $srcRoot "profile.js") -Content @"
function validateProfile(profile) {
  const errors = [];
  if (!profile.name || profile.name.trim().length < 2) {
    errors.push('Name must contain at least two characters.');
  }
  if (!profile.email || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(profile.email)) {
    errors.push('Email must be valid.');
  }
  if (!profile.avatarUrl || !/^https?:\/\//.test(profile.avatarUrl)) {
    errors.push('Avatar URL must start with http:// or https://.');
  }
  return errors;
}

function readProfile() {
  return {
    name: document.getElementById('nameInput').value,
    email: document.getElementById('emailInput').value,
    avatarUrl: document.getElementById('avatarInput').value,
    darkMode: document.getElementById('darkModeInput').checked
  };
}

function saveProfile() {
  const profile = readProfile();
  const errors = validateProfile(profile);
  const status = document.getElementById('status');
  if (errors.length > 0) {
    status.textContent = errors[0];
    return;
  }
  document.body.classList.toggle('dark', profile.darkMode);
  document.getElementById('avatarPreview').src = profile.avatarUrl;
  status.textContent = `Saved profile for ${profile.name}`;
}

document.getElementById('saveButton').addEventListener('click', saveProfile);
document.getElementById('darkModeInput').addEventListener('change', function () {
  document.body.classList.toggle('dark', this.checked);
});

window.validateProfile = validateProfile;
"@

  Write-TextFile -Path (Join-Path $testRoot "profile.test.ps1") -Content @"
`$ErrorActionPreference = "Stop"
`$root = Split-Path -Parent `$PSScriptRoot
`$html = Get-Content -LiteralPath (Join-Path `$root "index.html") -Raw
`$js = Get-Content -LiteralPath (Join-Path `$root "src/profile.js") -Raw
`$css = Get-Content -LiteralPath (Join-Path `$root "src/styles.css") -Raw

if (`$html -notmatch 'id="nameInput"') { throw "Missing name input" }
if (`$html -notmatch 'id="emailInput"') { throw "Missing email input" }
if (`$html -notmatch 'id="darkModeInput"') { throw "Missing dark mode input" }
if (`$js -notmatch 'function validateProfile') { throw "Missing validateProfile" }
if (`$js -notmatch 'Email must be valid') { throw "Missing email validation" }
if (`$css -notmatch '@media') { throw "Missing responsive rule" }

"PASS profile-card structural tests"
"@

  $deliveryNote = @(
    "# Delivery Note",
    "",
    "Implemented a responsive user profile card with:",
    "",
    "- editable name;",
    "- editable email;",
    "- editable avatar URL;",
    "- dark mode toggle;",
    "- basic validation;",
    "- responsive layout.",
    "",
    "Validation:",
    "",
    "powershell -ExecutionPolicy Bypass -File app/tests/profile.test.ps1"
  ) -join "`r`n"
  Write-TextFile -Path (Join-Path $docsRoot "DELIVERY.md") -Content $deliveryNote

  Add-Result $results "PASS" "implementation" "Mini project files generated"

  $testOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $testRoot "profile.test.ps1") 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "project-tests" ($testOutput | Out-String).Trim()
  } else {
    Add-Result $results "FAIL" "project-tests" ($testOutput | Out-String).Trim()
  }

  $gate = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $targetProject ".agents/tools/pre-release-gate.ps1") -Root $targetProject -Version "7.5.0" -StrictTelemetry -SkipSimulation -SkipDeveloperExecution -SkipDeveloperBenchmark 2>&1
  if ($LASTEXITCODE -eq 0) {
    Add-Result $results "PASS" "framework-gate" "Installed framework gate passes"
  } else {
    Add-Result $results "FAIL" "framework-gate" ($gate | Out-String).Trim()
  }

  if ($WriteReport) {
    New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    $timestamp = (Get-Date).ToString("o")
    $status = if (@($results | Where-Object { $_.Level -eq "FAIL" }).Count -eq 0) { "success" } else { "failure" }
    $summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }

    $report = New-Object System.Collections.Generic.List[string]
    $report.Add("# HEPHAESTUS Developer Execution Report") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("---") | Out-Null
    $report.Add('log_type: "developer-execution"') | Out-Null
    $report.Add("timestamp: `"$timestamp`"") | Out-Null
    $report.Add("status: `"$status`"") | Out-Null
    $report.Add('event: "developer_execution.completed"') | Out-Null
    $report.Add('framework_version: "7.5.0"') | Out-Null
    $report.Add('complexity: "STANDARD"') | Out-Null
    $report.Add('workflow: "ui-workflow"') | Out-Null
    $report.Add("---") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Request") | Out-Null
    $report.Add("") | Out-Null
    $report.Add($request) | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Generated Files") | Out-Null
    $report.Add("") | Out-Null
    foreach ($file in @("app/index.html", "app/src/styles.css", "app/src/profile.js", "app/tests/profile.test.ps1", "app/docs/DELIVERY.md")) {
      $report.Add("- $file") | Out-Null
    }
    $report.Add("") | Out-Null
    $report.Add("## Result") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("- Summary: $($summary -join ', ')") | Out-Null
    $report.Add("- Workspace kept: $KeepWorkspace") | Out-Null
    $report.Add("") | Out-Null
    $report.Add("## Checks") | Out-Null
    $report.Add("") | Out-Null
    foreach ($result in ($results | Sort-Object Level, Check, Message)) {
      $report.Add("- $($result.Level) $($result.Check): $($result.Message)") | Out-Null
    }
    $report | Set-Content -LiteralPath $reportPath
    Add-Result $results "PASS" "report" ".agents/reports/executions/latest.md"
  }
} finally {
  if ($createdWorkRoot -and -not $KeepWorkspace -and (Test-Path -LiteralPath $resolvedWorkRoot)) {
    Remove-Item -LiteralPath $resolvedWorkRoot -Recurse -Force
  }
}

$results | Sort-Object Level, Check, Message | Format-Table -AutoSize
$summary = $results | Group-Object Level | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host ""
Write-Host "Developer execution summary: $($summary -join ', ')"

$failures = @($results | Where-Object { $_.Level -eq "FAIL" }).Count
if ($failures -gt 0) {
  exit 1
}

exit 0





