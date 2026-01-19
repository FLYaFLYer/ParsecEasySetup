@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Загружаем язык через общий файл
call ..\load_language.bat

:MENU
cls
echo ========================================
echo        !lang_uninstall_title! by FLYaFLYer
echo ========================================
echo.
echo [!lang_warning!] !lang_uninstall_warning!
echo !lang_uninstall_item_1!
echo !lang_uninstall_item_2!
echo !lang_uninstall_item_3!
echo.
echo !lang_uninstall_option_1!
echo !lang_uninstall_option_2!
echo !lang_uninstall_option_3!
echo.
echo !lang_uninstall_back!
echo.

set /p choice="!lang_uninstall_choice! "
if "%choice%"=="0" goto :EOF
if "%choice%"=="1" goto WARNING
if "%choice%"=="2" goto SEARCH_ONLY
if "%choice%"=="3" goto USB_WARNING

echo !lang_invalid_choice!
timeout /t 1 /nobreak >nul
goto MENU

:WARNING
cls
echo ========================================
echo        !lang_uninstall_warning_title!
echo ========================================
echo.
echo !lang_uninstall_warning_text!
echo.
echo !lang_uninstall_check_1!
echo !lang_uninstall_check_2!
echo !lang_uninstall_check_3!
echo.
echo !lang_uninstall_reboot!
echo.
choice /C YN /N /M "!lang_uninstall_continue! "
if errorlevel 2 goto MENU

echo.
echo !lang_uninstall_step1!
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
set "LOG_FILE=!LOGS_DIR!\parsec_uninstall_!datetime!.log"

echo !lang_log_file! !LOG_FILE!
echo.
goto SEARCH_AND_UNINSTALL

:USB_WARNING
cls
echo ========================================
echo !lang_usb_warning_title!
echo ========================================
echo.
echo !lang_usb_warning_text!
echo.
echo !lang_usb_check_1!
echo !lang_usb_check_2!
echo !lang_usb_check_3!
echo.
echo !lang_usb_warning_info!
echo.
echo !lang_usb_reboot!
echo.
choice /C YN /N /M "!lang_usb_continue! "
if errorlevel 2 goto MENU

echo.
echo !lang_uninstall_step1!
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
set "LOG_FILE=!LOGS_DIR!\parsec_usb_uninstall_!datetime!.log"

echo !lang_log_file! !LOG_FILE!
echo.
goto USB_UNINSTALL

:SEARCH_AND_UNINSTALL
cls
echo ========================================
echo        !lang_uninstall_title!
echo ========================================
echo.
echo !lang_uninstall_step1!
echo.

set "components_found=0" >> "!LOG_FILE!"
set "components_uninstalled=0" >> "!LOG_FILE!"
set "folders_deleted=0" >> "!LOG_FILE!"
set "current=0" >> "!LOG_FILE!"

echo !lang_checking_locations! >> "!LOG_FILE!"
echo !lang_checking_locations!
echo.

set "path[1]=C:\Program Files\Parsec"
set "name[1]=Parsec (64-bit)"
set "path[2]=C:\Program Files (x86)\Parsec"
set "name[2]=Parsec (32-bit)"
set "path[3]=C:\ProgramData\Parsec"
set "name[3]=Parsec (ProgramData)"
set "path[4]=%LOCALAPPDATA%\Parsec"
set "name[4]=Parsec (AppData)"
set "path[5]=%APPDATA%\Parsec"
set "name[5]=Parsec (Roaming)"
set "path[6]=C:\Program Files\Parsec Virtual Display Driver"
set "name[6]=Parsec Virtual Display Driver"

for /l %%i in (1,1,6) do (
    set "test_path=!path[%%i]!"
    set "test_name=!name[%%i]!"
    
    if exist "!test_path!" (
        set /a components_found+=1
        set /a current+=1
        
        echo [!current!] !test_name! >> "!LOG_FILE!"
        echo   !lang_file_folder! !test_path! >> "!LOG_FILE!"
        
        echo [!current!] !test_name!
        echo   !lang_file_folder! !test_path!
        
        if exist "!test_path!\uninstall.exe" (
            echo   !lang_has_uninstall! >> "!LOG_FILE!"
            echo   !lang_has_uninstall!
            echo.
            choice /C YN /N /M "   !lang_run_uninstall! "
            if errorlevel 2 (
                echo   !lang_skipped! >> "!LOG_FILE!"
                echo   !lang_skipped!
                echo.
            ) else (
                echo   !lang_running_uninstall! >> "!LOG_FILE!"
                echo   !lang_running_uninstall!
                start /wait "" "!test_path!\uninstall.exe"
                ping -n 3 127.0.0.1 >nul
                
                if exist "!test_path!" (
                    if exist "!test_path!\uninstall.exe" (
                        echo   [!lang_warning!] !lang_uninstall_failed! >> "!LOG_FILE!"
                        echo   [!lang_warning!] !lang_uninstall_failed!
                        echo   !lang_uninstall_failed! >> "!LOG_FILE!"
                        echo   !lang_uninstall_failed!
                    ) else (
                        echo   [!lang_ok!] !lang_uninstall_success! >> "!LOG_FILE!"
                        echo   [!lang_ok!] !lang_uninstall_success!
                        echo   !lang_folder_will_delete! >> "!LOG_FILE!"
                        echo   !lang_folder_will_delete!
                        set /a components_uninstalled+=1
                    )
                ) else (
                    echo   [!lang_ok!] !lang_uninstall_success! >> "!LOG_FILE!"
                    echo   [!lang_ok!] !lang_uninstall_success!
                    set /a components_uninstalled+=1
                )
                echo.
            )
        ) else (
            echo   !lang_no_uninstall! >> "!LOG_FILE!"
            echo   !lang_no_uninstall!
            echo.
            choice /C YN /N /M "   !lang_delete_folder! "
            if errorlevel 2 (
                echo   !lang_skipped! >> "!LOG_FILE!"
                echo   !lang_skipped!
                echo.
            ) else (
                echo   !lang_deleting_folder! >> "!LOG_FILE!"
                echo   !lang_deleting_folder!
                rmdir /s /q "!test_path!" 2>nul
                ping -n 2 127.0.0.1 >nul
                
                if exist "!test_path!" (
                    echo   [!lang_error!] !lang_folder_error! >> "!LOG_FILE!"
                    echo   [!lang_error!] !lang_folder_error!
                ) else (
                    echo   [!lang_ok!] !lang_folder_deleted! >> "!LOG_FILE!"
                    echo   [!lang_ok!] !lang_folder_deleted!
                    set /a folders_deleted+=1
                )
                echo.
            )
        )
    )
)

if %components_found% equ 0 (
    echo !lang_nothing_found! >> "!LOG_FILE!"
    echo !lang_nothing_found!
    echo.
    pause
    goto MENU
)

echo !lang_uninstall_step2! >> "!LOG_FILE!"
echo !lang_uninstall_step2!
echo ========================================
echo.

echo !lang_total_found! %components_found% >> "!LOG_FILE!"
echo !lang_uninstalled_count! %components_uninstalled% >> "!LOG_FILE!"
echo !lang_folders_deleted! %folders_deleted% >> "!LOG_FILE!"

echo !lang_total_found! %components_found%
echo !lang_uninstalled_count! %components_uninstalled%
echo !lang_folders_deleted! %folders_deleted%
echo.

if %components_uninstalled% equ 0 if %folders_deleted% equ 0 (
    echo !lang_nothing_removed! >> "!LOG_FILE!"
    echo !lang_nothing_removed!
) else (
    set /a total_removed=components_uninstalled+folders_deleted
    echo !lang_total_removed! %total_removed% >> "!LOG_FILE!"
    echo !lang_total_removed! %total_removed%
    echo.
    if %components_uninstalled% gtr 0 (
        echo [!lang_warning!] !lang_auto_delete_note! >> "!LOG_FILE!"
        echo [!lang_warning!] !lang_auto_delete_note!
    )
)

echo.
echo !lang_logs_saved! !LOG_FILE!
echo.
pause
goto MENU

:USB_UNINSTALL
cls
echo ========================================
echo !lang_usb_warning_title!
echo ========================================
echo.
echo !lang_usb_search_step!
echo.

set "usb_found=0" >> "!LOG_FILE!"
set "usb_uninstalled=0" >> "!LOG_FILE!"
set "usb_folders_deleted=0" >> "!LOG_FILE!"

echo !lang_usb_searching! >> "!LOG_FILE!"
echo !lang_usb_searching!
echo.

set "usb_path=C:\Program Files\Parsec Virtual USB Adapter Driver"
set "usb_name=Parsec Virtual USB Adapter Driver"

if exist "%usb_path%" (
    set /a usb_found=1
    
    echo [1] !usb_name! >> "!LOG_FILE!"
    echo   !lang_usb_path! !usb_path! >> "!LOG_FILE!"
    
    echo [1] !usb_name!
    echo   !lang_usb_path! !usb_path!
    
    if exist "!usb_path!\uninstall.exe" (
        echo   !lang_has_uninstall! >> "!LOG_FILE!"
        echo   !lang_has_uninstall!
        echo.
        choice /C YN /N /M "   !lang_run_uninstall! "
        if errorlevel 2 (
            echo   !lang_skipped! >> "!LOG_FILE!"
            echo   !lang_skipped!
            echo.
        ) else (
            echo   !lang_running_uninstall! >> "!LOG_FILE!"
            echo   !lang_running_uninstall!
            start /wait "" "!usb_path!\uninstall.exe"
            ping -n 3 127.0.0.1 >nul
            
            if exist "!usb_path!" (
                if exist "!usb_path!\uninstall.exe" (
                    echo   [!lang_warning!] !lang_uninstall_failed! >> "!LOG_FILE!"
                    echo   [!lang_warning!] !lang_uninstall_failed!
                    echo   !lang_uninstall_failed! >> "!LOG_FILE!"
                    echo   !lang_uninstall_failed!
                ) else (
                    echo   [!lang_ok!] !lang_uninstall_success! >> "!LOG_FILE!"
                    echo   [!lang_ok!] !lang_uninstall_success!
                    echo   !lang_folder_will_delete! >> "!LOG_FILE!"
                    echo   !lang_folder_will_delete!
                    set /a usb_uninstalled=1
                )
            ) else (
                echo   [!lang_ok!] !lang_uninstall_success! >> "!LOG_FILE!"
                echo   [!lang_ok!] !lang_uninstall_success!
                set /a usb_uninstalled=1
            )
            echo.
        )
    ) else (
        echo   !lang_no_uninstall! >> "!LOG_FILE!"
        echo   !lang_no_uninstall!
        echo.
        choice /C YN /N /M "   !lang_delete_folder! "
        if errorlevel 2 (
            echo   !lang_skipped! >> "!LOG_FILE!"
            echo   !lang_skipped!
            echo.
        ) else (
            echo   !lang_deleting_folder! >> "!LOG_FILE!"
            echo   !lang_deleting_folder!
            rmdir /s /q "!usb_path!" 2>nul
            ping -n 2 127.0.0.1 >nul
            
            if exist "!usb_path!" (
                echo   [!lang_error!] !lang_folder_error! >> "!LOG_FILE!"
                echo   [!lang_error!] !lang_folder_error!
            ) else (
                echo   [!lang_ok!] !lang_folder_deleted! >> "!LOG_FILE!"
                echo   [!lang_ok!] !lang_folder_deleted!
                set /a usb_folders_deleted=1
            )
            echo.
        )
    )
) else (
    echo !lang_usb_not_found! >> "!LOG_FILE!"
    echo !lang_usb_path! %usb_path% >> "!LOG_FILE!"
    echo !lang_usb_not_found!
    echo !lang_usb_path! %usb_path%
    echo.
    pause
    goto MENU
)

echo !lang_usb_step2! >> "!LOG_FILE!"
echo !lang_usb_step2!
echo ========================================
echo.
if %usb_found% equ 0 (
    echo !lang_usb_not_found! >> "!LOG_FILE!"
    echo !lang_usb_not_found!
) else (
    if %usb_uninstalled% equ 1 (
        echo [!lang_success!] !lang_usb_success! >> "!LOG_FILE!"
        echo [!lang_success!] !lang_usb_success!
        echo.
        echo !lang_usb_auto_delete! >> "!LOG_FILE!"
        echo !lang_usb_auto_delete!
    ) else if %usb_folders_deleted% equ 1 (
        echo [!lang_success!] !lang_usb_folder_success! >> "!LOG_FILE!"
        echo [!lang_success!] !lang_usb_folder_success!
    ) else (
        echo !lang_usb_not_removed! >> "!LOG_FILE!"
        echo !lang_usb_not_removed!
    )
)

echo.
echo !lang_logs_saved! !LOG_FILE!
echo.
pause
goto MENU

:SEARCH_ONLY
cls
echo ========================================
echo        !lang_search_only_title!
echo ========================================
echo.
echo !lang_searching_installed!
echo.

set "found=0"

echo !lang_checking_parsec_folders!
echo.

call :CHECK_FOLDER "C:\Program Files\Parsec" "Parsec (64-bit)"
call :CHECK_FOLDER "C:\Program Files (x86)\Parsec" "Parsec (32-bit)"
call :CHECK_FOLDER "C:\ProgramData\Parsec" "Parsec (ProgramData)"
call :CHECK_FOLDER "%LOCALAPPDATA%\Parsec" "Parsec (AppData)"
call :CHECK_FOLDER "%APPDATA%\Parsec" "Parsec (Roaming)"

echo !lang_checking_drivers_section!
echo.

call :CHECK_FOLDER "C:\Program Files\Parsec Virtual Display Driver" "Parsec Virtual Display Driver"
call :CHECK_FOLDER "C:\Program Files\Parsec Virtual USB Adapter Driver" "Parsec Virtual USB Adapter Driver"

echo ========================================
if %found% equ 0 (
    echo !lang_components_not_found!
) else (
    echo !lang_components_found_count! %found%
    echo.
    echo !lang_for_uninstall!
)

echo.
pause
goto MENU

:CHECK_FOLDER
set "folder=%~1"
set "name=%~2"

if exist "!folder!" (
    echo [!name!]
    echo   !lang_file_folder! !folder!
    if exist "!folder!\uninstall.exe" (
        echo   !lang_has_uninstall!
    ) else (
        echo   !lang_no_uninstall!
    )
    echo.
    set /a found+=1
)
goto :eof