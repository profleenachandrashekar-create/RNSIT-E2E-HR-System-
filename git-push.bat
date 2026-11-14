@echo off
title Push Project to Git / GitHub
echo ========================================================
echo        Push Project to Git / GitHub Repository
echo ========================================================
echo.

rem 1. Check if Git is installed
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not in your system PATH.
    echo.
    echo Please install Git for Windows:
    echo   Download from: https://git-scm.com/download/win
    echo   Or run in Admin PowerShell: winget install --id Git.Git -e --source winget
    echo.
    echo After installing, restart your terminal and run this script again.
    pause
    exit /b 1
)

echo [1/5] Checking Git repository...
cd /d "%~dp0"

if not exist ".git" (
    echo Initializing new Git repository...
    git init
    git branch -M main
) else (
    echo Existing Git repository found.
)

echo.
echo [2/5] Staging files...
git add .

echo.
echo [3/5] Creating commit...
set /p COMMIT_MSG="Enter commit message (Press Enter for default: 'Add faculty onboarding and offboarding system'): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Add faculty onboarding and offboarding system

git commit -m "%COMMIT_MSG%"

echo.
echo [4/5] Checking remote repository...
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo No remote repository linked yet.
    echo Please create a new empty repository on GitHub (e.g. at https://github.com/new).
    echo.
    set /p REPO_URL="Paste your GitHub repository URL (e.g. https://github.com/username/repo.git): "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
    ) else (
        echo [WARNING] No remote URL entered. Files are committed locally.
        pause
        exit /b 0
    )
)

echo.
echo [5/5] Pushing to GitHub (main branch)...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   SUCCESS! All project files are uploaded to Git.
    echo ========================================================
) else (
    echo.
    echo [NOTE] Push failed. If this is a new repository or requires authentication,
    echo make sure your GitHub account is signed in or you use a Personal Access Token.
)

pause
