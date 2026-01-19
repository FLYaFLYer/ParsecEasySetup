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

title !lang_clean_cache_title! by FLYaFLYer

cls
echo ========================================
echo     !lang_clean_cache_title!
echo ========================================
echo.
echo !lang_clean_cache_description!
echo.
choice /C YN /N /M "!lang_clean_start! "
if errorlevel 2 goto :MENU_BACK

echo.
echo !lang_clean_step1!
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
set "LOG_FILE=!LOGS_DIR!\clean_cache_!datetime!.log"

echo !lang_log_file! !LOG_FILE!
echo.

set "FILES_DELETED=0" >> "!LOG_FILE!"
set "FILES_FOUND=0" >> "!LOG_FILE!"

echo !lang_clean_step2! >> "!LOG_FILE!"
echo !lang_clean_step2!
echo.

set "PATHS_CHECKED=0" >> "!LOG_FILE!"

for /f "tokens=*" %%i in ('scoop config cache_path 2^>nul') do (
    if exist "%%i\" (
        set "MAIN_CACHE_PATH=%%i"
        set /a PATHS_CHECKED+=1
    )
)

if not defined MAIN_CACHE_PATH (
    if exist "%USERPROFILE%\scoop\cache\" (
        set "MAIN_CACHE_PATH=%USERPROFILE%\scoop\cache"
        set /a PATHS_CHECKED+=1
    ) else if exist "%LOCALAPPDATA%\scoop\cache\" (
        set "MAIN_CACHE_PATH=%LOCALAPPDATA%\scoop\cache"
        set /a PATHS_CHECKED+=1
    )
)

if not defined MAIN_CACHE_PATH (
    echo [!lang_error!] !lang_cache_folder_error! >> "!LOG_FILE!"
    echo [!lang_error!] !lang_cache_folder_error!
    echo !lang_press_any_key_back!
    pause >nul
    goto :MENU_BACK
)

echo !lang_main_cache_path! !MAIN_CACHE_PATH! >> "!LOG_FILE!"
echo !lang_main_cache_path! !MAIN_CACHE_PATH!
echo.

echo !lang_clean_step3! >> "!LOG_FILE!"
echo !lang_clean_step3!
echo.

set "FILES_TO_DELETE=" >> "!LOG_FILE!"

dir /b "!MAIN_CACHE_PATH!\*parsec*" 2>nul > "%TEMP%\parsec_files.tmp"
if exist "%TEMP%\parsec_files.tmp" (
    for /f "tokens=*" %%f in ('type "%TEMP%\parsec_files.tmp"') do (
        echo   !lang_files_found! %%f >> "!LOG_FILE!"
        echo   !lang_files_found! %%f
        set "FILES_TO_DELETE=!FILES_TO_DELETE! "%%f""
        set /a FILES_FOUND+=1
    )
    del "%TEMP%\parsec_files.tmp" 2>nul
)

if !FILES_FOUND! equ 0 (
    echo !lang_no_cache_files! >> "!LOG_FILE!"
    echo !lang_no_cache_files!
    goto :SHOW_RESULTS
)

echo.
choice /C YN /N /M "!lang_delete_files! "
if errorlevel 2 (
    echo !lang_clean_cancelled! >> "!LOG_FILE!"
    echo !lang_clean_cancelled!
    goto :SHOW_RESULTS
)

echo.
echo !lang_clean_step4! >> "!LOG_FILE!"
echo !lang_clean_step4!
echo.

set "CURRENT_DIR=!MAIN_CACHE_PATH!"
for /f "tokens=*" %%f in ('dir /b "!CURRENT_DIR!\*parsec*" 2^>nul') do (
    set "FILE_TO_DELETE=!CURRENT_DIR!\%%f"
    if exist "!FILE_TO_DELETE!" (
        echo !lang_deleting_file! %%f >> "!LOG_FILE!"
        echo !lang_deleting_file! %%f
        del /f /q "!FILE_TO_DELETE!" 2>nul
        if exist "!FILE_TO_DELETE!" (
            echo   [!lang_error!] !lang_delete_error! %%f >> "!LOG_FILE!"
            echo   [!lang_error!] !lang_delete_error! %%f
        ) else (
            echo   [!lang_ok!] !lang_delete_success! >> "!LOG_FILE!"
            echo   [!lang_ok!] !lang_delete_success!
            set /a FILES_DELETED+=1
        )
        echo. >> "!LOG_FILE!"
        echo.
    )
)

:SHOW_RESULTS
echo. >> "!LOG_FILE!"
echo !lang_clean_step5! >> "!LOG_FILE!"
echo !lang_clean_step5!
echo ========================================
echo !lang_main_cache_path! !MAIN_CACHE_PATH! >> "!LOG_FILE!"
echo !lang_files_found_count! !FILES_FOUND! >> "!LOG_FILE!"
echo !lang_files_deleted_count! !FILES_DELETED! >> "!LOG_FILE!"

echo !lang_main_cache_path! !MAIN_CACHE_PATH!
echo !lang_files_found_count! !FILES_FOUND!
echo !lang_files_deleted_count! !FILES_DELETED!
echo.

if !FILES_DELETED! gtr 0 (
    echo !lang_cache_cleaned_success! >> "!LOG_FILE!"
    echo !lang_cache_note! >> "!LOG_FILE!"
    
    echo !lang_cache_cleaned_success!
    echo.
    echo !lang_cache_note!
) else if !FILES_FOUND! gtr 0 (
    echo [!lang_warning!] !lang_found_not_deleted! >> "!LOG_FILE!"
    
    echo [!lang_warning!] !lang_found_not_deleted!
) else (
    echo !lang_no_cache_files! >> "!LOG_FILE!"
    echo !lang_no_cache_files!
)

echo.
echo !lang_logs_saved! !LOG_FILE!
echo.

:MENU_BACK
echo ========================================
echo !lang_press_any_key_back!
pause >nul
goto :EOF