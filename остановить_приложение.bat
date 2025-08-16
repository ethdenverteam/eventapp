@echo off
chcp 65001 >nul
title EventApp Process Killer
color 0C

echo.
echo ========================================
echo         EVENTAPP PROCESS KILLER
echo ========================================
echo.

echo [INFO] Searching for EventApp processes...
echo.

REM Find and kill Node.js processes
echo [INFO] Looking for Node.js processes...
tasklist /FI "IMAGENAME eq node.exe" /FO TABLE 2>nul | findstr "node.exe" >nul
if errorlevel 1 (
    echo [INFO] No Node.js processes found
) else (
    echo [WARNING] Found Node.js processes:
    tasklist /FI "IMAGENAME eq node.exe" /FO TABLE
    echo.
    echo [INFO] Terminating Node.js processes...
    taskkill /IM "node.exe" /F >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to terminate Node.js processes
    ) else (
        echo [SUCCESS] All Node.js processes terminated
    )
)
echo.

REM Check and free port 3000
echo [INFO] Checking port 3000...
netstat -an | findstr ":3000" >nul
if errorlevel 1 (
    echo [INFO] Port 3000 is free
) else (
    echo [WARNING] Port 3000 is still in use
    echo [INFO] Attempting to free port 3000...
    
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3000"') do (
        echo [INFO] Found process using port 3000 with PID: %%a
        taskkill /PID %%a /F >nul 2>&1
        if errorlevel 1 (
            echo [WARNING] Could not stop process %%a
        ) else (
            echo [SUCCESS] Stopped process %%a
        )
    )
    
    timeout /t 2 /nobreak >nul
    echo [INFO] Port 3000 should be free now
)
echo.

REM Final check
echo [INFO] Final status check...
netstat -an | findstr ":3000" >nul
if errorlevel 1 (
    echo [SUCCESS] Port 3000 is confirmed free
) else (
    echo [WARNING] Port 3000 is still in use
)

echo.
echo ========================================
echo           CLEANUP COMPLETED
echo ========================================
echo.
echo [INFO] All EventApp processes have been terminated
echo [INFO] Port 3000 has been freed
echo [INFO] You can now safely restart the application
echo.
pause
