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

title !lang_download_title! by FLYaFLYer

cls
echo ========================================
echo    !lang_download_title!
echo ========================================
echo.
echo !lang_download_description_1!
echo !lang_download_description_2!
echo.
echo !lang_download_features_1!
echo !lang_download_features_2!
echo.
echo [!lang_note!] !lang_vpn_note!
echo.
choice /C YN /N /M "!lang_start_download! (Y/N): "
if errorlevel 2 (
    echo !lang_download_cancelled!
    echo.
    pause
    exit /b 0
)

echo.
echo ========================================
echo !lang_step_admin!
echo ========================================
echo.

net session >nul 2>&1
if %errorlevel% equ 0 (
    echo [!lang_info!] !lang_admin_info!
    set "ADMIN_MODE=1"
    set "INSTALL_TYPE=!lang_admin_global!"
) else (
    echo [!lang_info!] !lang_admin_info_no!
    set "ADMIN_MODE=0"
    set "INSTALL_TYPE=!lang_admin_user!"
)

echo.
echo ========================================
echo !lang_step_components!
echo ========================================
echo.

where scoop >nul 2>&1
if errorlevel 1 (
    echo [!lang_error!] !lang_scoop_not_found!
    echo.
    echo !lang_install_scoop_git_menu!
    echo.
    echo !lang_press_any_key_to_return!
    pause >nul
    exit /b 0
) else (
    echo [!lang_ok!] !lang_scoop_ok!
)

where git >nul 2>&1
if errorlevel 1 (
    echo [!lang_error!] !lang_git_not_found!
    echo.
    echo !lang_install_scoop_git_menu!
    echo.
    echo !lang_press_any_key_to_return!
    pause >nul
    exit /b 0
) else (
    echo [!lang_ok!] !lang_git_ok!
)

echo.
echo ========================================
echo !lang_step_installed!
echo ========================================
echo.
echo !lang_searching_components!
echo.

set "FOUND_COMPONENTS=0"

echo !lang_checking_folders!
echo.

if exist "C:\Program Files\Parsec" (
    echo !lang_found_64bit!
    echo   !lang_file_folder! "C:\Program Files\Parsec"
    echo.
    set /a FOUND_COMPONENTS+=1
)

if exist "C:\Program Files (x86)\Parsec" (
    echo !lang_found_32bit!
    echo   !lang_file_folder! "C:\Program Files (x86)\Parsec"
    echo.
    set /a FOUND_COMPONENTS+=1
)

if exist "%LOCALAPPDATA%\Parsec" (
    echo !lang_found_appdata!
    echo   !lang_file_folder! "%LOCALAPPDATA%\Parsec"
    echo.
    set /a FOUND_COMPONENTS+=1
)

if exist "%APPDATA%\Parsec" (
    echo !lang_found_roaming!
    echo   !lang_file_folder! "%APPDATA%\Parsec"
    echo.
    set /a FOUND_COMPONENTS+=1
)

echo !lang_checking_drivers!
echo.

if exist "C:\Program Files\Parsec Virtual Display Driver" (
    echo !lang_found_display_driver!
    echo   !lang_file_folder! "C:\Program Files\Parsec Virtual Display Driver"
    echo   !lang_status_driver!
    echo.
    set /a FOUND_COMPONENTS+=1
)

set "USB_PATH=C:\Program Files\Parsec Virtual USB Adapter Driver"
if exist "!USB_PATH!" (
    echo !lang_found_usb_driver!
    echo   !lang_file_folder! "!USB_PATH!"
    echo   !lang_status_usb_driver!
    echo.
    set /a FOUND_COMPONENTS+=1
)

if !FOUND_COMPONENTS! gtr 0 (
    echo [!lang_info!] !lang_components_found!
    echo.
) else (
    echo [!lang_info!] !lang_not_found!
    echo.
)

echo ========================================
echo !lang_step_vpn!
echo ========================================
echo.
echo [!lang_info!] !lang_vpn_info!
echo.
echo !lang_vpn_note1!
echo !lang_vpn_note2!
echo !lang_vpn_note3!
echo.

echo ========================================
echo !lang_step_cache!
echo ========================================
echo.

echo !lang_cleaning_cache!
set "CACHE_PATH="

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

if defined CACHE_PATH (
    echo !lang_cache_found! "!CACHE_PATH!"
    echo.
    
    set "CACHE_FILES_DELETED=0"
    
    if exist "!CACHE_PATH!\*parsec*" (
        echo !lang_deleting_files!
        for /f "tokens=*" %%f in ('dir /b "!CACHE_PATH!\*parsec*" 2^>nul') do (
            echo   !lang_deleting! "%%f"
            del /f /q "!CACHE_PATH!\%%f" 2>nul
            set /a CACHE_FILES_DELETED+=1
        )
        echo.
    )
    
    if !CACHE_FILES_DELETED! gtr 0 (
        echo [!lang_ok!] !lang_cache_deleted_ok! !CACHE_FILES_DELETED!
    ) else (
        echo [!lang_info!] !lang_cache_not_found!
    )
) else (
    echo [!lang_info!] !lang_cache_error!
)

echo.
echo !lang_checking_repo!
scoop bucket list 2>nul | findstr /i nonportable >nul
if !errorlevel! equ 0 (
    echo [!lang_info!] !lang_repo_found!
) else (
    echo !lang_repo_adding!
    scoop bucket add nonportable >nul 2>&1
    if !errorlevel! equ 0 (
        echo [!lang_ok!] !lang_repo_added!
    ) else (
        echo [!lang_error!] !lang_repo_error!
        echo.
        pause
        exit /b 0
    )
)

echo.
echo ========================================
echo !lang_step_logs!
echo ========================================
echo.

set "LOGS_DIR=..\logs"
if not exist "!LOGS_DIR!\" (
    mkdir "!LOGS_DIR!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [!lang_ok!] !lang_logs_created! "!LOGS_DIR!"
    ) else (
        echo [!lang_info!] !lang_logs_error!
        echo !lang_logs_using_current!
        set "LOGS_DIR=."
    )
)

for /f "delims=" %%a in ('powershell -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"') do set "datetime=%%a"
set "LOG_FILE=!LOGS_DIR!\parsec_download_!datetime!.log"

echo !lang_log_file! "!LOG_FILE!"
echo.

echo ========================================
echo !lang_step_download!
echo ========================================
echo.
echo !lang_downloading!
echo.
echo !lang_download_progress!
echo ----------------------------------------

echo !lang_download_step1!
echo.

echo !lang_downloading_installer!
echo.

cmd /c "scoop download nonportable/parsec-np > "!LOG_FILE!" 2>&1"

echo !lang_download_step2!
echo.

if not exist "!LOG_FILE!" (
    echo [!lang_error!] !lang_installer_not_found!
    set "SUCCESS=0"
    goto SHOW_RESULTS
)

echo !lang_viewing_log!
echo ----------------------------------------

type "!LOG_FILE!"

echo ----------------------------------------

echo.
echo [!lang_info!] !lang_log_saved! "!LOG_FILE!"
echo.

set "FOUND_ERROR=0"

findstr /i "403" "!LOG_FILE!" >nul
if !errorlevel! equ 0 (
    echo ========================================
    echo !lang_error_403!
    echo ========================================
    echo.
    echo !lang_parsec_blocked!
    echo.
    echo !lang_need_vpn!
    echo.
    if defined CACHE_PATH (
        echo !lang_cache_found! "!CACHE_PATH!"
    )
    echo.
    pause
    exit /b 1
)

findstr /i "404" "!LOG_FILE!" >nul
if !errorlevel! equ 0 (
    echo ========================================
    echo !lang_error_404!
    echo ========================================
    echo.
    echo !lang_installer_not_found!
    echo.
    if defined CACHE_PATH (
        echo !lang_cache_found! "!CACHE_PATH!"
    )
    echo.
    pause
    exit /b 1
)

set "SUCCESS=0"
set "DOWNLOADED_FILE="

echo !lang_download_step3!
echo.

if defined CACHE_PATH (
    echo !lang_searching_cache! "!CACHE_PATH!"
    echo.
    
    echo !lang_checking_cache_files!
    
    dir /b "!CACHE_PATH!\*parsec*.exe" >nul 2>&1
    if !errorlevel! equ 0 (
        for %%F in ("!CACHE_PATH!\*parsec*.exe") do (
            set "DOWNLOADED_FILE=%%F"
            set "SUCCESS=1"
        )
    )
    
    if "!SUCCESS!"=="1" (
        echo [!lang_success!] !lang_success_found!
        echo !lang_file_name! "!DOWNLOADED_FILE!"
    ) else (
        echo [!lang_info!] !lang_file_not_exe!
        echo.
        echo !lang_searching_any!
        dir /b "!CACHE_PATH!\*parsec*" 2>nul
        echo.
    )
) else (
    echo [!lang_info!] !lang_cache_path_error!
)

:SHOW_RESULTS
cls
echo ========================================
echo !lang_step_results!
echo ========================================
echo.

if "!SUCCESS!"=="1" (
    echo [!lang_success!] !lang_success_download!
    echo.
    
    for %%F in ("!DOWNLOADED_FILE!") do (
        set "FILE_NAME=%%~nxF"
        set "FILE_SIZE=%%~zF"
        set "FILE_PATH=%%~dpF"
    )
    
    echo !lang_file_info!
    echo !lang_file_name! "!FILE_NAME!"
    echo !lang_file_size! !FILE_SIZE! !lang_bytes!
    echo !lang_file_folder! "!FILE_PATH!"
    echo.
    
    echo !lang_vpn_important!
    echo !lang_vpn_important_text!
    echo.
    
    echo !lang_additional_info!
    echo !lang_account_needed!
    echo !lang_drivers_needed!
    echo.
    echo !lang_logs_saved! "!LOG_FILE!"
    echo.
    
    :MENU_CHOICE
    echo ========================================
    echo !lang_choose_action!
    echo ========================================
    echo.
    echo !lang_action_1!
    echo !lang_action_2!
    echo.
    echo !lang_action_0!
    echo.
    
    set /p choice="!lang_choose_option! "
    
    if "!choice!"=="1" (
        echo !lang_open_folder! "!FILE_PATH!"
        explorer "!FILE_PATH!"
        echo.
        goto MENU_CHOICE
    )
    if "!choice!"=="2" (
        echo !lang_run_installer! "!FILE_NAME!"
        echo.
        echo !lang_install_warning!
        echo !lang_install_admin!
        echo !lang_install_vpn!
        echo.
        start "" "!DOWNLOADED_FILE!"
        echo !lang_installer_started!
        echo.
        goto MENU_CHOICE
    )
    if "!choice!"=="0" (
        exit /b 0
    )
    
    echo !lang_invalid_selection!
    timeout /t 1 /nobreak >nul
    goto MENU_CHOICE
    
) else (
    echo [!lang_error!] !lang_download_failed!
    echo.
    echo !lang_possible_reasons!
    echo !lang_reason_1!
    echo !lang_reason_2!
    echo !lang_reason_3!
    echo !lang_reason_4!
    echo.
    
    if defined CACHE_PATH (
        echo !lang_cache_found! "!CACHE_PATH!"
        echo !lang_check_cache_folder!
        echo.
    ) else (
        echo !lang_possible_cache_paths!
        echo - "%USERPROFILE%\scoop\cache"
        echo - "%LOCALAPPDATA%\scoop\cache"
        echo.
    )
    
    echo !lang_recommendations!
    echo !lang_recommend_1!
    echo !lang_recommend_2!
    echo !lang_recommend_3!
    echo !lang_recommend_4!
    echo.
    
    echo !lang_check_logs! "!LOG_FILE!"
    echo.
    echo !lang_manual_check!
    echo !lang_manual_1!
    echo !lang_manual_2!
    echo !lang_manual_3!
    echo !lang_manual_4!
    echo.
    echo ========================================
    echo !lang_press_any_key_to_return!
    pause >nul
    exit /b 0
)