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

title !lang_instructions_title! by FLYaFLYer

cls
echo ========================================
echo !lang_instructions_title! by FLYaFLYer
echo ========================================
echo.
echo !lang_instructions_description!
echo.
echo ========================================
echo !lang_step1_title!
echo ========================================
echo.
echo !lang_step1_1!
echo !lang_step1_2!
echo !lang_step1_3!
echo.
echo !lang_step1_important!
echo.
echo ========================================
echo !lang_step2_title!
echo ========================================
echo.
echo !lang_step2_1!
echo !lang_step2_2!
echo !lang_step2_3!
echo !lang_step2_4!
echo.
echo !lang_step2_menu!
echo !lang_step2_option_1!
echo !lang_step2_option_2!
echo !lang_step2_option_3!
echo.
echo ========================================
echo !lang_step3_title!
echo ========================================
echo.
echo !lang_step3_ways!
echo.
echo !lang_step3_way1_title!
echo !lang_step3_way1!
echo !lang_step3_way1_1!
echo.
echo !lang_step3_way2_title!
echo !lang_step3_way2_1!
echo !lang_step3_way2_2!
echo.
echo !lang_step3_way3_title!
echo !lang_step3_way3_1!
echo !lang_step3_way3_2!
echo !lang_step3_way3_3!
echo.
echo ========================================
echo !lang_vpn_title!
echo ========================================
echo.
echo !lang_vpn_if!
echo.
echo !lang_vpn_1!
echo !lang_vpn_2!
echo !lang_vpn_3!
echo !lang_vpn_4!
echo !lang_vpn_4_1!
echo !lang_vpn_4_2!
echo !lang_vpn_4_3!
echo.
echo ========================================
echo !lang_step4_title!
echo ========================================
echo.
echo !lang_step4_after!
echo !lang_step4_1!
echo !lang_step4_2!
echo !lang_step4_3!
echo.
echo ========================================
echo !lang_troubleshooting_title!
echo ========================================
echo.
echo !lang_troubleshooting_1!
echo !lang_troubleshooting_2!
echo !lang_troubleshooting_3!
echo !lang_troubleshooting_4!
echo.
echo ========================================
echo !lang_additional_features_title!
echo ========================================
echo.
echo !lang_additional_1!
echo !lang_additional_2!
echo.
echo ========================================
echo.
echo !lang_press_any_key_to_return!
pause >nul
goto :EOF