@echo off
title NPTEL Frontend Server
echo ============================================
echo   NPTEL Reimbursement Portal - Frontend
echo ============================================

set "PATH=C:\Program Files\nodejs;%PATH%"
cd /d "%~dp0frontend"

if not exist "node_modules" (
    echo [1/2] Installing frontend dependencies...
    call npm install
)

echo.
echo [2/2] Starting React Vite server at http://localhost:5173/ ...
call npm run dev
pause
