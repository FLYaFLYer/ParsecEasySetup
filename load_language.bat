@echo off
setlocal enabledelayedexpansion

REM ===== ЗАГРУЗКА ЯЗЫКА =====
if exist "config\language.txt" (
    set /p LANG=<"config\language.txt" 2>nul
    if "!LANG!"=="" (
        set "LANG=en"
        echo en > "config\language.txt"
    )
) else (
    set "LANG=en"
    if not exist "config\" mkdir config
    echo en > "config\language.txt"
)

REM Проверяем корректность языка
if not "!LANG!"=="ru" if not "!LANG!"=="en" (
    set "LANG=en"
    echo en > "config\language.txt"
)

REM ===== ЗАГРУЗКА ЛОКАЛИЗАЦИИ =====
if not exist "lang\" mkdir lang
if not exist "lang\!LANG!.txt" (
    set "LANG=en"
)

REM Очищаем предыдущие переменные локализации
for /f "tokens=1 delims==" %%a in ('set lang_ 2^>nul') do set "%%a="

REM Загружаем переводы
for /f "tokens=1,* delims==" %%a in (lang\!LANG!.txt) do (
    set "lang_%%a=%%b"
)

REM Устанавливаем значения по умолчанию
if not defined lang_bytes set "lang_bytes=bytes"
if not defined lang_MB set "lang_MB=MB"
if not defined lang_ok set "lang_ok=OK"
if not defined lang_info set "lang_info=INFO"
if not defined lang_warning set "lang_warning=WARNING"
if not defined lang_success set "lang_success=SUCCESS"
if not defined lang_error set "lang_error=ERROR"
if not defined lang_step set "lang_step=STEP"
if not defined lang_press_any_key_to_return set "lang_press_any_key_to_return=Press any key to return to menu..."
if not defined lang_press_any_key_to_continue set "lang_press_any_key_to_continue=Press any key to continue..."

exit /b 0