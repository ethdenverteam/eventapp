@echo off
chcp 65001 >nul
title EventApp - Upload to GitHub
color 0A

echo [INFO] Starting upload to GitHub...
echo.

:: Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] package.json not found. Please run this script from the project root.
    pause
    exit /b 1
)

:: Add all files
echo [INFO] Adding files to Git...
git add .

:: Commit changes
echo [INFO] Committing changes...
git commit -m "Update: %date% %time%"

:: Push to GitHub
echo [INFO] Pushing to GitHub...
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Changes uploaded successfully to GitHub!
    echo [INFO] Repository: https://github.com/ethdenverteam/eventapp/
) else (
    echo.
    echo [ERROR] Failed to upload to GitHub
    echo [INFO] Check your Git credentials and internet connection
)

echo.
pause
