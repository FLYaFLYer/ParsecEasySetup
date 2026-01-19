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

title !lang_about_title! by FLYaFLYer

cls
echo ========================================
echo     !lang_about_title! by FLYaFLYer
echo ========================================
echo.
echo !lang_about_description!
echo.
echo !lang_about_purpose!
echo !lang_about_purpose_1!
echo !lang_about_purpose_2!
echo.
echo !lang_about_help!
echo !lang_about_help_1!
echo !lang_about_help_2!
echo !lang_about_help_3!
echo !lang_about_help_4!
echo.
echo !lang_about_free!
echo.
echo !lang_about_author!
echo.
echo !lang_about_contacts!
echo.
echo !lang_telegram! https://t.me/FLYaFLYer
echo !lang_github! https://github.com/FLYaFLYer
echo !lang_discord! fly_a_flyer
echo !lang_steam! https://steamcommunity.com/profiles/76561198805349045/
echo !lang_donation! https://www.donationalerts.com/r/flyaflyer
echo.
echo !lang_donation_thanks!
echo.
echo !lang_press_any_key_to_return!
pause >nul
goto :EOF