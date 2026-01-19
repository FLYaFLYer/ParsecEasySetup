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

title !lang_scoop_user_title! by FLYaFLYer

cls
echo ========================================
echo  !lang_scoop_user_title!
echo ========================================
echo.
echo !lang_scoop_user_description!
echo.
choice /C YN /N /M "!lang_scoop_continue_short! "
if errorlevel 2 goto :EOF

echo.
echo !lang_scoop_step1!
echo.

set "LOGS_DIR=..\logs"
if not exist "!LOGS_DIR!\" (
    mkdir "!LOGS_DIR!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [!lang_ok!] !lang_logs_created! !LOGS_DIR!
    ) else (
        echo [!lang_info!] !lang_logs_error!
        echo !lang_logs_using_current!
        set "LOGS_DIR=."
    )
)

for /f "delims=" %%a in ('powershell -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"') do set "datetime=%%a"
set "LOG_FILE=!LOGS_DIR!\scoop_install_user_!datetime!.log"

echo !lang_log_file! !LOG_FILE!
echo.

echo ========================================
echo !lang_scoop_step2!
echo ========================================
echo.

powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" > "!LOG_FILE!" 2>&1
echo !lang_scoop_step1!
echo.

echo ========================================
echo !lang_scoop_step3!
echo ========================================
echo.

where scoop >nul 2>&1
if errorlevel 1 (
    echo !lang_scoop_installing! >> "!LOG_FILE!"
    echo !lang_scoop_installing!
    powershell -Command "irm get.scoop.sh -outfile '%TEMP%\scoop_install.ps1'; & '%TEMP%\scoop_install.ps1'" >> "!LOG_FILE!" 2>&1
    del "%TEMP%\scoop_install.ps1" 2>nul
    
    type "!LOG_FILE!" | findstr /i "error\|fail\|exception" >nul
    if !errorlevel! equ 0 (
        echo [!lang_error!] !lang_scoop_error! !LOG_FILE!
        echo.
        pause >nul
        goto :EOF
    ) else (
        echo [!lang_ok!] !lang_scoop_installed!
    )
) else (
    echo !lang_scoop_already! >> "!LOG_FILE!"
    echo [!lang_info!] !lang_scoop_already!
)
echo.

echo ========================================
echo !lang_scoop_step4!
echo ========================================
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo !lang_scoop_git_installing! >> "!LOG_FILE!"
    echo !lang_scoop_git_installing!
    scoop install git >> "!LOG_FILE!" 2>&1
    
    type "!LOG_FILE!" | findstr /i "error\|fail\|exception" >nul
    if !errorlevel! equ 0 (
        echo [!lang_warning!] !lang_scoop_git_warning!
    ) else (
        echo [!lang_ok!] !lang_scoop_git_installed!
    )
) else (
    echo !lang_scoop_git_already! >> "!LOG_FILE!"
    echo [!lang_info!] !lang_scoop_git_already!
)
echo.

echo ========================================
echo !lang_scoop_complete!
echo ========================================
echo.
echo !lang_scoop_complete!
echo.
echo !lang_logs_saved! !LOG_FILE!
echo.
echo !lang_press_any_key_to_return!
pause >nul