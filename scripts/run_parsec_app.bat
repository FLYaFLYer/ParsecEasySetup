@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Загружаем язык
if exist "config\language.txt" (
    for /f "delims=" %%a in (config\language.txt) do set "LANG=%%a"
) else (
    set "LANG=ru"
)

REM Загружаем локализацию
if not exist "lang\" mkdir lang
if not exist "lang\!LANG!.txt" (
    set "LANG=ru"
)

for /f "tokens=1,* delims==" %%a in (lang\!LANG!.txt) do (
    set "lang_%%a=%%b"
)

title !lang_run_parsec_title! by FLYaFLYer

cls
echo ========================================
echo        !lang_run_parsec_title!
echo ========================================
echo.
echo !lang_searching_parsec!
echo.

set "PARSEC_FOUND=0"
set "PARSEC_PATH="
set "PARSEC_EXE=parsecd.exe"

echo !lang_run_step1!
echo.

if exist "C:\Program Files\Parsec\!PARSEC_EXE!" (
    set "PARSEC_PATH=C:\Program Files\Parsec"
    set "PARSEC_FOUND=1"
    echo [!lang_found_64bit!]
    echo   !lang_file_folder! !PARSEC_PATH!
    echo.
)

if exist "C:\Program Files (x86)\Parsec\!PARSEC_EXE!" (
    set "PARSEC_PATH=C:\Program Files (x86)\Parsec"
    set "PARSEC_FOUND=1"
    echo [!lang_found_32bit!]
    echo   !lang_file_folder! !PARSEC_PATH!
    echo.
)

if exist "%LOCALAPPDATA%\Parsec\!PARSEC_EXE!" (
    set "PARSEC_PATH=%LOCALAPPDATA%\Parsec"
    set "PARSEC_FOUND=1"
    echo [!lang_found_appdata!]
    echo   !lang_file_folder! !PARSEC_PATH!
    echo.
)

if !PARSEC_FOUND! equ 0 (
    echo [!lang_error!] !lang_parsec_not_found_error!
    echo.
    echo !lang_possible_causes!
    echo !lang_cause_1!
    echo !lang_cause_2!
    echo !lang_cause_3!
    echo.
    echo !lang_recommendations_parsec!
    echo !lang_recommend_parsec_1!
    echo !lang_recommend_parsec_2!
    echo !lang_recommend_parsec_3!
    echo.
    echo !lang_how_to_install!
    echo !lang_install_step1!
    echo !lang_install_step2!
    echo !lang_install_step3!
    echo.
    echo !lang_press_any_key_to_return!
    pause >nul
    goto :EOF
)

echo !lang_run_step2!
echo.

set "FULL_PATH=!PARSEC_PATH!\!PARSEC_EXE!"
echo !lang_running! !FULL_PATH!
echo.

start "" "!FULL_PATH!" >nul 2>&1

timeout /t 3 /nobreak >nul
tasklist /FI "IMAGENAME eq parsecd.exe" 2>nul | find /I "parsecd.exe" >nul

if !errorlevel! equ 0 (
    echo [!lang_success!] !lang_success_started!
    echo !lang_tray_message!
    echo.
) else (
    echo [!lang_warning!] !lang_warning_not_started!
    echo !lang_already_running!
    echo.
)

echo !lang_returning_menu!
timeout /t 3 /nobreak >nul
goto :EOF