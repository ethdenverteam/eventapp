@echo off
title EventApp Simple Launcher
color 0A

echo.
echo ========================================
echo         EVENTAPP SIMPLE LAUNCHER
echo ========================================
echo.

echo [INFO] Starting EventApp...
echo.

REM Navigate to frontend directory
cd /d "%~dp0frontend"

REM Launch the application
echo [INFO] Launching application...
echo [INFO] Application will be available at: http://localhost:3000
echo [INFO] To stop: Press Ctrl+C
echo.
echo [LAUNCH] Starting development server...
echo.

"C:\Program Files\nodejs\npm.cmd" run dev

echo.
echo [INFO] Application stopped
echo [INFO] Press any key to close...
pause
