@echo off
chcp 65001 >nul
title EventApp Launcher
color 0A

echo.
echo ========================================
echo           EVENTAPP LAUNCHER
echo ========================================
echo.

REM Check if Node.js is installed
echo [INFO] Checking Node.js installation...
if not exist "C:\Program Files\nodejs\node.exe" (
    echo [ERROR] Node.js not found in C:\Program Files\nodejs\
    echo [ERROR] Please install Node.js from https://nodejs.org/
    echo.
    pause
    exit /b 1
)

REM Check if npm is available
if not exist "C:\Program Files\nodejs\npm.cmd" (
    echo [ERROR] npm not found in C:\Program Files\nodejs\
    echo [ERROR] Please reinstall Node.js
    echo.
    pause
    exit /b 1
)

echo [SUCCESS] Node.js found
echo [SUCCESS] npm found
echo.

REM Add Node.js to PATH for current session
echo [INFO] Setting up environment...
set PATH=%PATH%;C:\Program Files\nodejs
echo [SUCCESS] Environment configured
echo.

REM Navigate to frontend directory
echo [INFO] Navigating to frontend directory...
cd /d "%~dp0frontend"
if errorlevel 1 (
    echo [ERROR] Failed to navigate to frontend directory
    echo [ERROR] Current directory: %CD%
    echo.
    pause
    exit /b 1
)
echo [SUCCESS] Current directory: %CD%
echo.

REM Check if package.json exists
if not exist "package.json" (
    echo [ERROR] package.json not found in frontend directory
    echo [ERROR] Please check project structure
    echo.
    pause
    exit /b 1
)

REM Check and install dependencies
echo [INFO] Checking dependencies...
if not exist "node_modules" (
    echo [WARNING] node_modules not found in frontend directory
    echo [INFO] Installing dependencies in frontend directory (this may take a few minutes)...
    echo.
    
    call "C:\Program Files\nodejs\npm.cmd" install
    if errorlevel 1 (
        echo [ERROR] Failed to install dependencies
        echo [ERROR] Check your internet connection and try again
        echo.
        pause
        exit /b 1
    )
    echo [SUCCESS] Dependencies installed successfully in frontend directory
) else (
    echo [SUCCESS] Dependencies already installed in frontend directory
)
echo.

REM Check for running processes on port 3000
echo [INFO] Checking if port 3000 is available...
netstat -an | findstr ":3000" >nul
if errorlevel 1 (
    echo [SUCCESS] Port 3000 is available
) else (
    echo [WARNING] Port 3000 is already in use
    echo [INFO] Attempting to find and stop conflicting processes...
    
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3000"') do (
        echo [INFO] Found process with PID: %%a
        taskkill /PID %%a /F >nul 2>&1
        if errorlevel 1 (
            echo [WARNING] Could not stop process %%a
        ) else (
            echo [SUCCESS] Stopped process %%a
        )
    )
    
    timeout /t 3 /nobreak >nul
    echo [INFO] Port check completed
)
echo.

REM Display launch information
echo ========================================
echo           LAUNCHING EVENTAPP
echo ========================================
echo.
echo [INFO] Application will be available at: http://localhost:3000
echo [INFO] To stop the application: Press Ctrl+C
echo [INFO] To close this window: Press any key after stopping
echo.
echo [INFO] Starting development server...
echo.

REM Launch the application
echo [LAUNCH] Executing: npm run dev
echo.
call "C:\Program Files\nodejs\npm.cmd" run dev

REM If we reach here, the application has stopped
echo.
echo ========================================
echo           APPLICATION STOPPED
echo ========================================
echo.
echo [INFO] Development server has stopped
echo [INFO] You can close this window now
echo.
pause
