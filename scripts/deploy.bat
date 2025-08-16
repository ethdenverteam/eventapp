@echo off
chcp 65001 >nul
title EventApp Deployment
color 0B

echo.
echo ========================================
echo           EVENTAPP DEPLOYMENT
echo ========================================
echo.

echo [INFO] Starting EventApp deployment...
echo.

REM Check if Node.js is installed
echo [INFO] Checking Node.js...
if not exist "C:\Program Files\nodejs\node.exe" (
    echo [ERROR] Node.js is not installed. Please install Node.js 18+ first.
    pause
    exit /b 1
)
echo [SUCCESS] Node.js found
echo.

REM Check if npm is available
echo [INFO] Checking npm...
if not exist "C:\Program Files\nodejs\npm.cmd" (
    echo [ERROR] npm is not installed. Please install npm first.
    pause
    exit /b 1
)
echo [SUCCESS] npm found
echo.

REM Check if Git is available
echo [INFO] Checking Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed. Please install Git first.
    pause
    exit /b 1
)
echo [SUCCESS] Git found
echo.

REM Check if Railway CLI is available
echo [INFO] Checking Railway CLI...
railway --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Railway CLI is not installed. Installing now...
    call "C:\Program Files\nodejs\npm.cmd" install -g @railway/cli
    if errorlevel 1 (
        echo [ERROR] Failed to install Railway CLI
        pause
        exit /b 1
    )
)
echo [SUCCESS] Railway CLI found
echo.

REM Build frontend
echo [INFO] Building frontend...
cd /d "%~dp0..\frontend"

echo [INFO] Installing frontend dependencies...
call "C:\Program Files\nodejs\npm.cmd" install
if errorlevel 1 (
    echo [ERROR] Failed to install frontend dependencies
    pause
    exit /b 1
)

echo [INFO] Building Next.js application...
call "C:\Program Files\nodejs\npm.cmd" run build
if errorlevel 1 (
    echo [ERROR] Failed to build frontend
    pause
    exit /b 1
)

echo [SUCCESS] Frontend built successfully
echo.

REM Deploy frontend to Vercel
echo [INFO] Deploying frontend to Vercel...
echo [WARNING] Vercel deployment requires manual setup:
echo [INFO] 1. Go to https://vercel.com
echo [INFO] 2. Import your GitHub repository
echo [INFO] 3. Set root directory to 'frontend'
echo [INFO] 4. Deploy
echo.

REM Deploy backend to Railway
echo [INFO] Deploying backend to Railway...
cd /d "%~dp0..\backend"

echo [INFO] Checking Railway configuration...
if not exist ".railway\project.json" (
    echo [WARNING] Railway not configured. Initializing...
    railway init
    if errorlevel 1 (
        echo [ERROR] Failed to initialize Railway project
        pause
        exit /b 1
    )
)

echo [INFO] Deploying to Railway...
railway up
if errorlevel 1 (
    echo [ERROR] Failed to deploy to Railway
    pause
    exit /b 1
)

echo [SUCCESS] Backend deployed to Railway
echo.

REM Setup database
echo [INFO] Setting up database...
echo [INFO] Please follow these steps to set up Supabase:
echo [INFO] 1. Go to https://supabase.com
echo [INFO] 2. Create a new project
echo [INFO] 3. Wait for project to be ready
echo [INFO] 4. Go to SQL Editor
echo [INFO] 5. Run the SQL script from database/schema.sql
echo [INFO] 6. Copy the database connection string
echo [INFO] 7. Add it to Railway environment variables as DATABASE_URL
echo.

echo ========================================
echo           DEPLOYMENT COMPLETE
echo ========================================
echo.
echo [SUCCESS] Frontend: Deploy to Vercel manually
echo [SUCCESS] Backend: Deploy to Railway manually
echo [SUCCESS] Database: Set up Supabase manually
echo.
echo [INFO] Next steps:
echo [INFO] 1. Complete Vercel deployment
echo [INFO] 2. Complete Railway deployment
echo [INFO] 3. Set up Supabase database
echo [INFO] 4. Connect all services
echo [INFO] 5. Test the application
echo.
pause
