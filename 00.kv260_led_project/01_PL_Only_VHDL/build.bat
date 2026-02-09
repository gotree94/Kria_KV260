@echo off
setlocal enabledelayedexpansion

set VIVADO_PATH=C:\Xilinx\Vivado\2022.2
set VIVADO_BAT=%VIVADO_PATH%\bin\vivado.bat
set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

:MENU
cls
echo ==============================================================================
echo  KV260 LED Project - PL Only (VHDL)
echo ==============================================================================
echo.
echo  [1] Create and Build All
echo  [2] Create Project Only
echo  [3] Build Only (after project exists)
echo  [4] Open Vivado GUI
echo  [5] Clean
echo  [0] Exit
echo.
echo ==============================================================================
set /p choice="Select: "

if "%choice%"=="1" goto CREATE_BUILD
if "%choice%"=="2" goto CREATE
if "%choice%"=="3" goto BUILD
if "%choice%"=="4" goto GUI
if "%choice%"=="5" goto CLEAN
if "%choice%"=="0" goto EXIT
goto MENU

:CREATE_BUILD
echo.
echo Creating and building project...
call "%VIVADO_BAT%" -mode batch -source create_project.tcl -source build_all.tcl
pause
goto MENU

:CREATE
echo.
echo Creating project...
call "%VIVADO_BAT%" -mode batch -source create_project.tcl
pause
goto MENU

:BUILD
echo.
echo Building project...
call "%VIVADO_BAT%" -mode batch -source build_all.tcl
pause
goto MENU

:GUI
echo.
if exist "kv260_led_pl_only\kv260_led_pl_only.xpr" (
    start "" "%VIVADO_BAT%" kv260_led_pl_only\kv260_led_pl_only.xpr
) else (
    echo Project not found. Run option 1 or 2 first.
    pause
)
goto MENU

:CLEAN
echo.
echo Cleaning...
if exist "kv260_led_pl_only" rmdir /s /q kv260_led_pl_only
if exist ".Xil" rmdir /s /q .Xil
del /q *.bit 2>nul
del /q *.log 2>nul
del /q *.jou 2>nul
echo Done.
pause
goto MENU

:EXIT
exit /b 0
