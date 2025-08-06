@echo off
echo.
echo ✨ wooden ghost sync tool
echo simple repository sync for temporal optimization
echo.

if "%1"=="sync" goto sync
if "%1"=="status" goto status
if "%1"=="help" goto help
goto help

:status
echo ✨ checking repositories...
if exist repositories (
    echo ✨ repositories found:
    for /d %%i in (repositories\*) do echo   📁 %%~ni
) else (
    echo ✨ no repositories directory found
)
goto end

:sync
echo ✨ syncing essential repositories from github.com/shmil111
if not exist repositories mkdir repositories
cd repositories
for %%r in (powershell linuxcommandlibrary) do (
    if exist %%r (
        echo ✨ updating: %%r
        cd %%r
        git status --porcelain > nul 2>&1
        if errorlevel 1 (
            git pull --quiet
            echo ✨ updated successfully
        ) else (
            echo ✨ repository has changes, skipping pull
        )
        cd ..
    ) else (
        echo ✨ cloning: %%r
        git clone https://github.com/shmil111/%%r.git --quiet --depth 1
        if not errorlevel 1 echo ✨ cloned successfully
    )
)
cd ..
echo ✨ essential repositories sync completed!
goto end

:help
echo usage:
echo   sync.bat sync     - sync all repositories
echo   sync.bat status   - show status
echo   sync.bat help     - show this help
echo.

:end 