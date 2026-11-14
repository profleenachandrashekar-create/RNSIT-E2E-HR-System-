@echo off
title Faculty Onboarding - PHP Portal
echo ========================================================
echo   Faculty Onboarding Portal (PHP Integration Module)
echo ========================================================
echo.

set "PHP_CMD=php"

rem Check common PHP installation paths
if exist "C:\xampp\php\php.exe" set "PHP_CMD=C:\xampp\php\php.exe"
if exist "C:\tools\php\php.exe" set "PHP_CMD=C:\tools\php\php.exe"
if exist "C:\php\php.exe" set "PHP_CMD=C:\php\php.exe"

"%PHP_CMD%" -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [NOTICE] PHP CLI executable was not detected in system PATH.
    echo.
    echo To run the standalone PHP portal:
    echo  1. Install PHP or XAMPP (https://www.apachefriends.org/).
    echo  2. Copy or symlink the 'php_portal' folder into 'C:\xampp\htdocs\faculty_portal'.
    echo  3. Open http://localhost/faculty_portal/index.php in your browser.
    echo.
    echo Alternatively, the full modern React UI is live and connects to the
    echo same Django backend via 'start-frontend.bat' at http://localhost:5173/ !
    echo.
    pause
    exit /b 1
)

echo Found PHP: "%PHP_CMD%"
echo Starting built-in PHP development server on http://127.0.0.1:8080 ...
cd /d "%~dp0php_portal"
"%PHP_CMD%" -S 127.0.0.1:8080
pause
