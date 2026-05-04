@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "SOURCE_ROOT=%SCRIPT_DIR%..\.."

if "%~1"=="" (
  set /p TARGET_ROOT=Target project folder: 
) else (
  set "TARGET_ROOT=%~1"
)

if "%TARGET_ROOT%"=="" (
  echo Target project folder is required.
  exit /b 1
)

echo.
echo Repository mode:
echo   none
echo   local
echo   github
echo   gitlab
echo   bitbucket
echo   other
echo   existing
set /p REPOSITORY_MODE=Repository mode [none/local/github/gitlab/bitbucket/other/existing]: 

if "%REPOSITORY_MODE%"=="" (
  set "REPOSITORY_MODE=none"
)

set "REMOTE_URL="
if /I not "%REPOSITORY_MODE%"=="none" if /I not "%REPOSITORY_MODE%"=="local" (
  set /p REMOTE_URL=Remote URL, or leave blank to configure later: 
)

set /p DEFAULT_BRANCH=Default branch [main]: 
if "%DEFAULT_BRANCH%"=="" (
  set "DEFAULT_BRANCH=main"
)

set /p APPLY_INSTALL=Apply install now? Type YES to apply, anything else for dry-run: 
set /p OPEN_FIRST_CALL=Open first-call prompt after apply? Type YES to open, anything else to skip: 

if /I "%APPLY_INSTALL%"=="YES" (
  if /I "%OPEN_FIRST_CALL%"=="YES" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-hephaestus-launcher.ps1" -SourceRoot "%SOURCE_ROOT%" -TargetRoot "%TARGET_ROOT%" -RepositoryMode "%REPOSITORY_MODE%" -RemoteUrl "%REMOTE_URL%" -DefaultBranch "%DEFAULT_BRANCH%" -Apply -OpenFirstCall
  ) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-hephaestus-launcher.ps1" -SourceRoot "%SOURCE_ROOT%" -TargetRoot "%TARGET_ROOT%" -RepositoryMode "%REPOSITORY_MODE%" -RemoteUrl "%REMOTE_URL%" -DefaultBranch "%DEFAULT_BRANCH%" -Apply
  )
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-hephaestus-launcher.ps1" -SourceRoot "%SOURCE_ROOT%" -TargetRoot "%TARGET_ROOT%" -RepositoryMode "%REPOSITORY_MODE%" -RemoteUrl "%REMOTE_URL%" -DefaultBranch "%DEFAULT_BRANCH%"
)

exit /b %ERRORLEVEL%
