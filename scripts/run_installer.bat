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

title !lang_run_installer_title! by FLYaFLYer

cls
echo ========================================
echo    !lang_run_installer_title!
echo ========================================
echo.
echo !lang_searching_installer_cache!
echo.

set "CACHE_PATH="
set "INSTALLER_FOUND=0"
set "INSTALLER_PATH="

echo !lang_run_installer_step1!
echo.

for /f "tokens=*" %%i in ('scoop config cache_path 2^>nul') do (
    if exist "%%i\" (
        set "CACHE_PATH=%%i"
    )
)

if not defined CACHE_PATH (
    if exist "%USERPROFILE%\scoop\cache\" (
        set "CACHE_PATH=%USERPROFILE%\scoop\cache"
    ) else if exist "%LOCALAPPDATA%\scoop\cache\" (
        set "CACHE_PATH=%LOCALAPPDATA%\scoop\cache"
    )
)

if not defined CACHE_PATH (
    echo [!lang_error!] !lang_cache_not_found_error!
    echo.
    echo !lang_installer_not_found_reasons!
    echo !lang_cache_reason_1!
    echo !lang_cache_reason_2!
    echo.
    echo !lang_install_scoop_menu!
    echo.
    echo !lang_press_any_key_to_return!
    pause >nul
    exit /b 0
)

echo !lang_cache_path_found! %CACHE_PATH%
echo.

echo !lang_run_installer_step2!
echo.

for %%F in ("%CACHE_PATH%\*parsec*.exe") do (
    if exist "%%F" (
        set "INSTALLER_PATH=%%F"
        set "INSTALLER_FOUND=1"
    )
)

if %INSTALLER_FOUND% equ 0 (
    echo [!lang_error!] !lang_installer_not_found_cache!
    echo.
    echo !lang_installer_not_found_reasons!
    echo !lang_reason_cache_1!
    echo !lang_reason_cache_2!
    echo !lang_reason_cache_3!
    echo.
    echo !lang_cache_contents!
    echo ----------------------------------------
    dir /b "%CACHE_PATH%\*parsec*" 2>nul
    if errorlevel 1 (
        echo    !lang_no_files!
    )
    echo ----------------------------------------
    echo.
    echo !lang_install_scoop_first!
    echo.
    echo !lang_press_any_key_to_return!
    pause >nul
    goto :EOF
)

echo [!lang_success!] !lang_installer_found!
echo !lang_file_name! %INSTALLER_PATH%
echo.

for %%F in ("%INSTALLER_PATH%") do (
    set "FILE_NAME=%%~nxF"
    set "FILE_SIZE=%%~zF"
    set "FILE_PATH=%%~dpF"
)

echo !lang_installer_info!
echo !lang_file_name! %FILE_NAME%
echo !lang_file_size! %FILE_SIZE% !lang_bytes!
echo !lang_file_folder! %FILE_PATH%
echo.

echo !lang_run_installer_step3!
echo.
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo [!lang_info!] !lang_admin_rights!
    set "IS_ADMIN=1"
) else (
    echo [!lang_info!] !lang_no_admin_rights!
    set "IS_ADMIN=0"
)

echo.
echo [!lang_note!] !lang_vpn_note_installer!
echo.

:CHOICE_MENU
echo ========================================
echo !lang_choose_action_installer!
echo ========================================
echo.
echo !lang_action_installer_1!
echo !lang_action_installer_2!
echo.
echo !lang_action_installer_0!
echo.
set /p CHOICE="!lang_choose_option! "

if "%CHOICE%"=="1" goto RUN_INSTALLER
if "%CHOICE%"=="2" goto OPEN_FOLDER
if "%CHOICE%"=="0" goto EXIT_SCRIPT

echo !lang_invalid_selection!
echo.
goto CHOICE_MENU

:RUN_INSTALLER
    echo.
    echo !lang_run_installer_now! %FILE_NAME%
    echo.
    if %IS_ADMIN% equ 0 (
        echo [!lang_warning!] !lang_warning_no_admin!
        echo.
    )
    echo !lang_installer_recommendations!
    echo !lang_recommend_installer_1!
    echo !lang_recommend_installer_2!
    echo !lang_recommend_installer_3!
    echo.
    echo !lang_starting_in!
    timeout /t 3 /nobreak >nul
    start "" "%INSTALLER_PATH%"
    echo !lang_installer_started_success!
    echo.
    goto CHOICE_MENU

:OPEN_FOLDER
    echo.
    echo !lang_open_folder_installer! %FILE_PATH%
    explorer "%FILE_PATH%"
    echo.
    goto CHOICE_MENU

:EXIT_SCRIPT
    echo.
    echo !lang_returning_main_menu!
    timeout /t 1 /nobreak >nul
    goto :EOF