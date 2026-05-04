param(
  [string]$SourceRoot = ".",
  [string]$TargetRoot = "",
  [ValidateSet("none","local","github","gitlab","bitbucket","other","existing")]
  [string]$RepositoryMode = "none",
  [string]$RemoteUrl = "",
  [string]$DefaultBranch = "main",
  [switch]$OpenFirstCall,
  [switch]$Apply
)

$ErrorActionPreference = "Stop"

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

function Write-FirstCallPrompt {
  param(
    [string]$TargetRootPath,
    [string]$FrameworkVersion,
    [string]$ProjectState,
    [string]$RepositoryMode,
    [string]$RemoteUrl,
    [string]$DefaultBranch,
    [bool]$HasGit
  )

  $promptPath = Join-Path $TargetRootPath "HEPHAESTUS-FIRST-CALL.md"
  $lines = @(
    "# HEPHAESTUS First Call Prompt",
    "",
    "Use this prompt after installing HEPHAESTUS in this project.",
    "",
    '```text',
    "Estamos trabalhando no projeto local:",
    $TargetRootPath,
    "",
    "Quero ativar o HEPHAESTUS Agent Framework neste projeto sem recomeçar do zero.",
    "",
    "Contexto importante:",
    "- Framework instalado: v$FrameworkVersion.",
    "- Estado inicial do projeto: $ProjectState.",
    "- Repository mode informado no instalador: $RepositoryMode.",
    "- Git detectado na pasta: $HasGit.",
    "- Branch padrao desejada: $DefaultBranch.",
    "- Remote URL informado: $RemoteUrl.",
    "- Comunique-se comigo em português brasileiro.",
    "- Mantenha artefatos técnicos, código, configs e protocolos em inglês.",
    "- Antes de implementar, leia `.agents/AGENTS.md`, `.agents/config/framework.yaml` e `.agents/config/project.yaml`.",
    "- Se este for um projeto existente, alinhe Git, branch, remote, comandos e paths protegidos organicamente comigo antes de qualquer Apply.",
    "- Se este for um projeto novo, confirme se devo preparar apenas o plano Git/local/online ou se existe aprovacao explicita para configurar Git local.",
    "- Use Smart Loading e comece pelo menor nível suficiente.",
    "- Se a tarefa exigir mais risco, complexidade, segurança, produção ou múltiplos módulos, faça auto-escalation para o nível apropriado.",
    "- Consulte memória quando houver gatilho real e preserve documentação viva.",
    "",
    "Primeira ação:",
    "Leia o estado real do projeto, rode ou recomende bootstrap quando fizer sentido, confirme a estrategia de repositorio local/online, identifique se o projeto e novo ou corrente, e recomende o proximo passo sem alterar Git ou configs ativas sem aprovacao.",
    '```'
  )
  $content = $lines -join [Environment]::NewLine

  Set-Content -LiteralPath $promptPath -Value $content
  return $promptPath
}

function Write-FirstCallLauncher {
  param([string]$TargetRootPath)

  $path = Join-Path $TargetRootPath "START-HEPHAESTUS.bat"
  $content = @(
    "@echo off",
    "echo HEPHAESTUS first-call handoff",
    "echo.",
    "echo NEXT REQUIRED STEP:",
    "echo 1. Copy the prompt from HEPHAESTUS-FIRST-CALL.md",
    "echo 2. Paste it into your AI coding assistant",
    "echo 3. Let HEPHAESTUS run project bootstrap/readiness before real work",
    "echo.",
    "notepad HEPHAESTUS-FIRST-CALL.md"
  ) -join [Environment]::NewLine

  Set-Content -LiteralPath $path -Value $content
  return $path
}

function Write-RepositorySetupReport {
  param(
    [string]$TargetRootPath,
    [string]$FrameworkVersion,
    [string]$ProjectState,
    [string]$RepositoryMode,
    [string]$RemoteUrl,
    [string]$DefaultBranch,
    [bool]$HasGit,
    [string]$GitBranch,
    [string]$GitRemote
  )

  $reportDir = Join-Path $TargetRootPath ".agents/reports/operator"
  New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
  $reportPath = Join-Path $reportDir "repository-setup-latest.md"
  $timestamp = (Get-Date).ToString("o")
  $lines = @(
    "# HEPHAESTUS Repository Setup Report",
    "",
    "---",
    'log_type: "repository-setup"',
    "framework_version: `"$FrameworkVersion`"",
    "status: `"handoff-required`"",
    "timestamp: `"$timestamp`"",
    "---",
    "",
    "## Summary",
    "",
    "- Project state: $ProjectState",
    "- Repository mode: $RepositoryMode",
    "- Git detected: $HasGit",
    "- Current branch: $GitBranch",
    "- Current remote: $GitRemote",
    "- Desired default branch: $DefaultBranch",
    "- Requested remote URL: $RemoteUrl",
    "",
    "## First Call Handoff",
    "",
    "- Open `HEPHAESTUS-FIRST-CALL.md`.",
    "- Paste it into the AI coding assistant.",
    "- Confirm repository strategy before enabling Apply or project commands.",
    "- Existing projects must be aligned organically in the first call.",
    "",
    "## Safety",
    "",
    "- No `git init`, branch rewrite, remote add, commit, or push was executed by this installer.",
    "- Git configuration requires explicit operator approval in a later step."
  )
  Set-Content -LiteralPath $reportPath -Value $lines
  return $reportPath
}

$resolvedSource = (Resolve-Path $SourceRoot).Path
$toolsRoot = Join-Path $resolvedSource ".agents/tools"
$installTool = Join-Path $toolsRoot "install-framework.ps1"
$frameworkVersion = Get-FrameworkVersion $resolvedSource

if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
  $TargetRoot = Read-Host "Target project folder"
}

if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
  Write-Error "TargetRoot is required."
  exit 1
}

$targetRootPath = if (Test-Path -LiteralPath $TargetRoot) {
  (Resolve-Path $TargetRoot).Path
} else {
  [System.IO.Path]::GetFullPath($TargetRoot)
}

$existingItems = @()
if (Test-Path -LiteralPath $targetRootPath) {
  $existingItems = @(Get-ChildItem -LiteralPath $targetRootPath -Force)
}

$hasGit = Test-Path -LiteralPath (Join-Path $targetRootPath ".git")
$projectState = if (-not (Test-Path -LiteralPath $targetRootPath)) {
  "new-folder"
} elseif ($existingItems.Count -eq 0) {
  "empty-folder"
} elseif ($hasGit) {
  "existing-git-project"
} else {
  "existing-folder"
}

$gitBranch = ""
$gitRemote = ""
if ($hasGit -and (Get-Command git -ErrorAction SilentlyContinue)) {
  $branchOutput = & git -C $targetRootPath branch --show-current 2>$null
  if ($LASTEXITCODE -eq 0) { $gitBranch = ($branchOutput | Select-Object -First 1) }
  $remoteOutput = & git -C $targetRootPath remote get-url origin 2>$null
  if ($LASTEXITCODE -eq 0) { $gitRemote = ($remoteOutput | Select-Object -First 1) }
} elseif ($hasGit) {
  $gitBranch = "unknown-git-not-found"
  $gitRemote = "unknown-git-not-found"
}

if ($existingItems.Count -gt 0 -and -not (Test-Path -LiteralPath (Join-Path $targetRootPath ".agents"))) {
  Write-Host "Target folder is not empty, but it does not contain .agents."
  Write-Host "Installer will add HEPHAESTUS without deleting existing files."
}

Write-Host "Project state: $projectState"
Write-Host "Repository mode: $RepositoryMode"
Write-Host "Git detected: $hasGit"
if (-not [string]::IsNullOrWhiteSpace($gitBranch)) { Write-Host "Current Git branch: $gitBranch" }
if (-not [string]::IsNullOrWhiteSpace($gitRemote)) { Write-Host "Current Git remote: $gitRemote" }
Write-Host "No Git mutation will be performed by this installer."

$args = @("-SourceRoot", $resolvedSource, "-TargetRoot", $targetRootPath)
if ($Apply) { $args += "-Apply" }

& powershell -NoProfile -ExecutionPolicy Bypass -File $installTool @args
$installExit = $LASTEXITCODE
if ($installExit -ne 0) {
  exit $installExit
}

if ($Apply) {
  $promptPath = Write-FirstCallPrompt -TargetRootPath $targetRootPath -FrameworkVersion $frameworkVersion -ProjectState $projectState -RepositoryMode $RepositoryMode -RemoteUrl $RemoteUrl -DefaultBranch $DefaultBranch -HasGit $hasGit
  $launcherPath = Write-FirstCallLauncher -TargetRootPath $targetRootPath
  $reportPath = Write-RepositorySetupReport -TargetRootPath $targetRootPath -FrameworkVersion $frameworkVersion -ProjectState $projectState -RepositoryMode $RepositoryMode -RemoteUrl $RemoteUrl -DefaultBranch $DefaultBranch -HasGit $hasGit -GitBranch $gitBranch -GitRemote $gitRemote
  Write-Host "First call prompt created: $promptPath"
  Write-Host "First call launcher created: $launcherPath"
  Write-Host "Repository setup report created: $reportPath"
  Write-Host ""
  Write-Host "NEXT REQUIRED STEP:"
  Write-Host "1. Open HEPHAESTUS-FIRST-CALL.md or run START-HEPHAESTUS.bat"
  Write-Host "2. Paste the prompt into your AI coding assistant"
  Write-Host "3. Confirm repository strategy before real project Apply"
  if ($OpenFirstCall) {
    Start-Process notepad.exe -ArgumentList "`"$promptPath`""
  }
} else {
  Write-Host "Dry-run only. Re-run with -Apply to install, create HEPHAESTUS-FIRST-CALL.md, START-HEPHAESTUS.bat, and repository setup report."
}

Write-Host "HEPHAESTUS install launcher summary: PASS"
exit 0
