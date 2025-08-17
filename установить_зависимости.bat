@echo off
chcp 65001 >nul
title EventApp - Install Dependencies
color 0B

echo [INFO] Installing EventApp dependencies...
echo.

:: Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] package.json not found. Please run this script from the project root.
    pause
    exit /b 1
)

:: Install root dependencies
echo [INFO] Installing root dependencies...
call npm install

if %errorlevel% neq 0 (
    echo [ERROR] Failed to install root dependencies
    pause
    exit /b 1
)

:: Install frontend dependencies
echo [INFO] Installing frontend dependencies...
cd frontend
call npm install

if %errorlevel% neq 0 (
    echo [ERROR] Failed to install frontend dependencies
    pause
    exit /b 1
)

:: Go back to root
cd ..

:: Install backend dependencies
echo [INFO] Installing backend dependencies...
cd backend
call npm install

if %errorlevel% neq 0 (
    echo [ERROR] Failed to install backend dependencies
    pause
    exit /b 1
)

:: Go back to root
cd ..

echo.
echo [SUCCESS] All dependencies installed successfully!
echo [INFO] You can now run the application
echo.

pause
