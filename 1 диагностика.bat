@echo off
title EventApp Diagnostics
color 0E

echo.
echo ========================================
echo         EVENTAPP DIAGNOSTICS
echo ========================================
echo.

echo [STEP 1] Current directory and script location
echo Current directory: %CD%
echo Script location: %~dp0
echo.

echo [STEP 2] Checking if frontend folder exists
if exist "%~dp0frontend" (
    echo [PASS] frontend folder exists
) else (
    echo [FAIL] frontend folder not found
    echo.
    pause
    exit /b 1
)
echo.

echo [STEP 3] Checking Node.js installation
if exist "C:\Program Files\nodejs\node.exe" (
    echo [PASS] Node.js found
) else (
    echo [FAIL] Node.js not found in C:\Program Files\nodejs\
    echo.
    pause
    exit /b 1
)
echo.

echo [STEP 4] Checking npm
if exist "C:\Program Files\nodejs\npm.cmd" (
    echo [PASS] npm found
) else (
    echo [FAIL] npm not found
    echo.
    pause
    exit /b 1
)
echo.

echo [STEP 5] Testing Node.js command
echo Testing: node --version
call "C:\Program Files\nodejs\node.exe" --version
echo.

echo [STEP 6] Testing npm command
echo Testing: npm --version
call "C:\Program Files\nodejs\npm.cmd" --version
echo.

echo [STEP 7] Navigating to frontend
cd /d "%~dp0frontend"
echo Current directory after navigation: %CD%
echo.

echo [STEP 8] Checking frontend contents
echo Files in frontend directory:
dir /b
echo.

echo [STEP 9] Checking package.json
if exist "package.json" (
    echo [PASS] package.json found
) else (
    echo [FAIL] package.json not found
)
echo.

echo [STEP 10] Checking node_modules
if exist "node_modules" (
    echo [PASS] node_modules found
) else (
    echo [WARNING] node_modules not found
)
echo.

echo ========================================
echo           DIAGNOSTICS COMPLETE
echo ========================================
echo.
echo [INFO] All basic checks completed
echo [INFO] Check the output above for any failures
echo.
pause
