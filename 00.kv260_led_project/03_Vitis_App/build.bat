@echo off
setlocal enabledelayedexpansion

set VITIS_PATH=C:\Xilinx\Vitis\2022.2
set XSCT_BAT=%VITIS_PATH%\bin\xsct.bat
set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

:MENU
cls
echo ==============================================================================
echo  KV260 LED Control - Vitis Application
echo ==============================================================================
echo.
echo  NOTE: Build 02_PS_PL_Verilog or 02_PS_PL_VHDL first!
echo.
echo  [1] Create and Build Vitis Project
echo  [2] Clean Workspace
echo  [3] Open Vitis IDE
echo  [0] Exit
echo.
echo ==============================================================================
set /p choice="Select: "

if "%choice%"=="1" goto BUILD
if "%choice%"=="2" goto CLEAN
if "%choice%"=="3" goto OPEN
if "%choice%"=="0" goto EXIT
goto MENU

:BUILD
echo.
echo Creating and building Vitis project...
call "%XSCT_BAT%" create_vitis_project.tcl
pause
goto MENU

:CLEAN
echo.
echo Cleaning workspace...
if exist "workspace" rmdir /s /q workspace
echo Done.
pause
goto MENU

:OPEN
echo.
if exist "workspace" (
    start "" "%VITIS_PATH%\bin\vitis.bat" -workspace workspace
) else (
    echo Workspace not found. Run option 1 first.
    pause
)
goto MENU

:EXIT
exit /b 0
