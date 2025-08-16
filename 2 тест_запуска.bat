@echo off
title EventApp Test Launcher
color 0B

echo.
echo ========================================
echo         EVENTAPP TEST LAUNCHER
echo ========================================
echo.

echo [TEST] Starting basic functionality test...
echo.

REM Test 1: Check if we can navigate to frontend
echo [TEST 1] Checking directory navigation...
cd /d "%~dp0frontend"
if errorlevel 1 (
    echo [FAIL] Cannot navigate to frontend directory
    echo [INFO] Current location: %CD%
    echo [INFO] Script location: %~dp0
    echo.
    pause
    exit /b 1
)
echo [PASS] Successfully navigated to: %CD%
echo.

REM Test 2: Check if package.json exists
echo [TEST 2] Checking package.json...
if not exist "package.json" (
    echo [FAIL] package.json not found
    echo [INFO] Files in current directory:
    dir /b
    echo.
    pause
    exit /b 1
)
echo [PASS] package.json found
echo.

REM Test 3: Check if node_modules exists
echo [TEST 3] Checking dependencies...
if not exist "node_modules" (
    echo [WARNING] node_modules not found in frontend directory
    echo [INFO] Checking if node_modules exists in parent directory...
    cd /d "%~dp0"
    if exist "node_modules" (
        echo [INFO] Found node_modules in parent directory
        cd /d "%~dp0frontend"
    ) else (
        echo [WARNING] node_modules not found anywhere - will need to install
        cd /d "%~dp0frontend"
    )
) else (
    echo [PASS] Dependencies already installed in frontend directory
)
echo.

REM Test 4: Try to run npm
echo [TEST 4] Testing npm command...
call "C:\Program Files\nodejs\npm.cmd" --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] npm command failed
    echo [INFO] Trying to find npm...
    if exist "C:\Program Files\nodejs\npm.cmd" (
        echo [INFO] npm.cmd exists but command failed
    ) else (
        echo [INFO] npm.cmd not found
    )
    echo.
    pause
    exit /b 1
)
echo [PASS] npm command works
echo.

echo ========================================
echo           ALL TESTS PASSED
echo ========================================
echo.
echo [SUCCESS] Basic functionality test completed
echo [INFO] Ready to launch application
echo.
echo [INFO] Press any key to continue with launch...
pause >nul

REM Now try to launch
echo.
echo [LAUNCH] Attempting to launch EventApp...
echo [INFO] This may take a moment...
echo.

call "C:\Program Files\nodejs\npm.cmd" run dev

echo.
echo [INFO] Application has stopped or failed to start
echo [INFO] Check the output above for errors
echo.
pause
