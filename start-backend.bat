@echo off
title NPTEL Backend Server
echo ============================================
echo   NPTEL Reimbursement Portal - Backend
echo ============================================

set "PY=python"
if exist "C:\Program Files\Python315\python.exe" set "PY=C:\Program Files\Python315\python.exe"

echo Python executable: "%PY%"
echo.
echo [1/3] Checking and installing dependencies...
"%PY%" -m pip install django djangorestframework django-cors-headers
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install pip dependencies.
    pause
    exit /b %errorlevel%
)

echo.
echo [2/3] Applying database migrations...
cd /d "%~dp0backend"
"%PY%" manage.py migrate

echo.
echo [3/3] Starting Django backend at http://127.0.0.1:8000/ ...
"%PY%" manage.py runserver 127.0.0.1:8000
pause
