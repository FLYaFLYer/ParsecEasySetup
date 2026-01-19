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

title !lang_open_cache_title! by FLYaFLYer

cls
echo ========================================
echo    !lang_open_cache_title!
echo ========================================
echo.
echo !lang_searching_cache_folder!
echo.

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
    echo !lang_cache_found! !CACHE_PATH!
    echo.
    echo !lang_opening_folder!
    timeout /t 2 /nobreak >nul
    explorer "!CACHE_PATH!"
    echo.
    echo !lang_folder_opened!
    echo !lang_opened_option_1!
    echo !lang_opened_option_2!
    echo.
    echo !lang_auto_clean_info!
) else (
    echo [!lang_error!] !lang_cache_not_found_error!
    echo.
    echo !lang_cache_not_found_reasons!
    echo !lang_cache_reason_1!
    echo !lang_cache_reason_2!
    echo.
    echo !lang_install_scoop_menu!
)

echo.
echo !lang_press_any_key_to_return!
pause >nul
exit /b 0