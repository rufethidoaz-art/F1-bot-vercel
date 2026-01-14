@echo off
REM Push F1 Bot to GitHub
cd /d "%~dp0"
echo Working directory: %CD%
echo.
echo 1. Adding files to git...
git add .
echo.
echo 2. Committing changes...
git commit -m "Add deploy script and fix bot polling mode"
echo.
echo 3. Pushing to GitHub...
git push origin main
echo.
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS: Pushed to GitHub!
) else (
    echo ERROR: Push failed!
)
pause

