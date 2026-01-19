@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:INITIALIZE
REM ===== ЗАГРУЗКА ЯЗЫКА =====
REM Проверяем существование папки config
if not exist "config\" mkdir config

REM Проверяем существование файла языка
if exist "config\language.txt" (
    REM Читаем файл языка
    set /p LANG=<"config\language.txt" 2>nul
    if "!LANG!"=="" (
        REM Файл пустой - устанавливаем английский
        set "LANG=en"
        echo en > "config\language.txt"
    )
) else (
    REM Файл не существует - создаем с английским по умолчанию
    set "LANG=en"
    echo en > "config\language.txt"
)

REM Проверяем корректность языка
if not "!LANG!"=="ru" if not "!LANG!"=="en" (
    echo [ERROR] Invalid language in config\language.txt: !LANG!
    echo Setting to English...
    set "LANG=en"
    echo en > "config\language.txt"
)

REM ===== ЗАГРУЗКА ЛОКАЛИЗАЦИИ =====
call :load_language

:MAIN_MENU
cls
echo ========================================
echo     PARSEC EASY SETUP by FLYaFLYer
echo ========================================
echo.
echo !lang_main_menu_title!
echo.
echo 1. !lang_menu_1!
echo.
echo 2. !lang_menu_2!
echo.
echo 3. !lang_menu_3!
echo.
echo 4. !lang_menu_4!
echo.
echo 5. !lang_menu_5!
echo.
echo 6. !lang_menu_6!
echo.
echo 7. !lang_menu_7!
echo.
echo 8. !lang_menu_8!
echo.
echo 9. !lang_menu_9!
echo.
echo L. !lang_menu_language!
echo.
echo 0. !lang_menu_exit!
echo.
set /p choice="!lang_choose_option! "

if /i "!choice!"=="L" goto CHANGE_LANGUAGE
if "!choice!"=="1" goto SCOOP_MENU
if "!choice!"=="2" goto DOWNLOAD_PARSEC
if "!choice!"=="3" goto UNINSTALL_PARSEC
if "!choice!"=="4" goto CLEAN_CACHE
if "!choice!"=="5" goto OPEN_CACHE_FOLDER
if "!choice!"=="6" goto RUN_INSTALLER
if "!choice!"=="7" goto RUN_PARSEC_APP
if "!choice!"=="8" goto ABOUT_AUTHOR
if "!choice!"=="9" goto INSTRUCTIONS
if "!choice!"=="0" goto EXIT

echo !lang_invalid_choice!
timeout /t 1 /nobreak >nul
goto MAIN_MENU

:CHANGE_LANGUAGE
cls
echo ========================================
echo     !lang_change_language_title!
echo ========================================
echo.
echo 1. !lang_russian!
echo 2. !lang_english!
echo.
echo 0. !lang_back!
echo.
set /p lang_choice="!lang_choose_language! "

if "!lang_choice!"=="1" (
    echo ru > "config\language.txt"
    set "LANG=ru"
    call :load_language
    cls
    echo ========================================
    echo     !lang_change_language_title!
    echo ========================================
    echo.
    echo !lang_language_changed_ru!
    echo.
    echo !lang_press_any_key_to_continue!
    pause >nul
    goto MAIN_MENU
) else if "!lang_choice!"=="2" (
    echo en > "config\language.txt"
    set "LANG=en"
    call :load_language
    cls
    echo ========================================
    echo     !lang_change_language_title!
    echo ========================================
    echo.
    echo !lang_language_changed_en!
    echo.
    echo !lang_press_any_key_to_continue!
    pause >nul
    goto MAIN_MENU
) else if "!lang_choice!"=="0" (
    goto MAIN_MENU
) else (
    echo !lang_invalid_choice!
    echo !lang_press_any_key_to_continue!
    pause >nul
    goto CHANGE_LANGUAGE
)

:SCOOP_MENU
cd scripts
call install_scoop_user.bat
cd ..
call :load_language
goto MAIN_MENU

:DOWNLOAD_PARSEC
cd scripts
call download_parsec.bat
cd ..
call :load_language
goto MAIN_MENU

:UNINSTALL_PARSEC
cd scripts
call uninstall_parsec.bat
cd ..
call :load_language
goto MAIN_MENU

:CLEAN_CACHE
cd scripts
call clean_cache.bat
cd ..
call :load_language
goto MAIN_MENU

:OPEN_CACHE_FOLDER
cd scripts
call open_cache.bat
cd ..
call :load_language
goto MAIN_MENU

:RUN_INSTALLER
cd scripts
call run_installer.bat
cd ..
call :load_language
goto MAIN_MENU

:RUN_PARSEC_APP
cd scripts
call run_parsec_app.bat
cd ..
call :load_language
goto MAIN_MENU

:ABOUT_AUTHOR
cd scripts
call about_author.bat
cd ..
call :load_language
goto MAIN_MENU

:INSTRUCTIONS
cd scripts
call instructions.bat
cd ..
call :load_language
goto MAIN_MENU

:EXIT
cls
echo ========================================
echo              !lang_exit_title!
echo ========================================
echo.
echo !lang_exit_message!
timeout /t 2 /nobreak >nul
exit /b 0

:load_language
REM Создаем папку lang если нет
if not exist "lang\" mkdir lang

REM Проверяем существование файла языка
if not exist "lang\!LANG!.txt" (
    echo [!lang_error!] Language file lang\!LANG!.txt not found!
    echo Defaulting to English...
    set "LANG=en"
    if not exist "lang\en.txt" (
        echo Creating English language file...
        echo # English language file > lang\en.txt
    )
)

REM Очищаем предыдущие переменные локализации
for /f "tokens=1 delims==" %%a in ('set lang_ 2^>nul') do set "%%a="

REM Загружаем переводы
for /f "tokens=1,* delims==" %%a in (lang\!LANG!.txt) do (
    set "lang_%%a=%%b"
)

REM Устанавливаем значения по умолчанию для отсутствующих ключей
if not defined lang_main_menu_title set "lang_main_menu_title=MAIN MENU"
if not defined lang_menu_1 set "lang_menu_1=Install Scoop and git"
if not defined lang_menu_2 set "lang_menu_2=Download Parsec installer"
if not defined lang_menu_3 set "lang_menu_3=Uninstall Parsec"
if not defined lang_menu_4 set "lang_menu_4=Clear installation cache"
if not defined lang_menu_5 set "lang_menu_5=Open Scoop cache folder"
if not defined lang_menu_6 set "lang_menu_6=Run Parsec installer (from cache)"
if not defined lang_menu_7 set "lang_menu_7=Run Parsec (if installed)"
if not defined lang_menu_8 set "lang_menu_8=About author"
if not defined lang_menu_9 set "lang_menu_9=Usage instructions"
if not defined lang_menu_language set "lang_menu_language=Change language"
if not defined lang_menu_exit set "lang_menu_exit=Exit"
if not defined lang_choose_option set "lang_choose_option=Choose option (0-9, L):"
if not defined lang_invalid_choice set "lang_invalid_choice=Invalid choice!"
if not defined lang_change_language_title set "lang_change_language_title=CHANGE LANGUAGE"
if not defined lang_russian set "lang_russian=Russian"
if not defined lang_english set "lang_english=English"
if not defined lang_back set "lang_back=Back"
if not defined lang_choose_language set "lang_choose_language=Choose language:"
if not defined lang_language_changed_ru set "lang_language_changed_ru=Language changed to Russian."
if not defined lang_language_changed_en set "lang_language_changed_en=Language changed to English."
if not defined lang_exit_title set "lang_exit_title=EXIT"
if not defined lang_exit_message set "lang_exit_message=Parsec Easy Setup is shutting down..."
if not defined lang_error set "lang_error=ERROR"
if not defined lang_press_any_key_to_continue set "lang_press_any_key_to_continue=Press any key to continue..."
if not defined lang_press_any_key_to_return set "lang_press_any_key_to_return=Press any key to return to menu..."
goto :eof