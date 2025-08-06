@echo off
:: Wooden.Ghost GitHub Workflow Launcher
:: Quick access to GitHub operations

setlocal enabledelayedexpansion

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                    Wooden.Ghost GitHub Tools                    ║
echo ║                  Temporal.Optimization Workflow                 ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

if "%1"=="" (
    echo Available commands:
    echo.
    echo   wg-github setup     - Configure GitHub workflow and pre-debugging
    echo   wg-github new       - Create new repository in repositories/
    echo   wg-github status    - Show current repository status
    echo   wg-github predebug  - Run pre-debugging checks only
    echo   wg-github fix       - Run quick fixes for common issues
    echo.
    echo Example: wg-github new MyNewProject
    echo.
    goto :eof
)

:: Set PowerShell execution policy for this session
powershell -ExecutionPolicy Bypass -Command "& '%~dp0setup_github_workflow.ps1' -Action '%1' -RepoName '%2'"

echo.
echo Operation completed. Returning to Wooden.Ghost workspace...
pause 