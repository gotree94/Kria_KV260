@echo off
REM ==============================================================================
REM KV260 LED Basic Project - Windows Build Script
REM 
REM Description:
REM   Vivado 빌드 메뉴 및 자동화
REM
REM Usage:
REM   build.bat
REM
REM Target: Xilinx KRIA KV260
REM Tool: Vivado 2022.2
REM ==============================================================================

setlocal enabledelayedexpansion

REM Vivado 경로 설정 (필요시 수정)
set VIVADO_PATH=C:\Xilinx\Vivado\2022.2
set VIVADO_BAT=%VIVADO_PATH%\bin\vivado.bat

REM 현재 디렉토리
set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

:MENU
cls
echo ==============================================================================
echo  KV260 LED Basic Project - Build Menu
echo ==============================================================================
echo.
echo  [1] Create Project (프로젝트 생성)
echo  [2] Build All (합성 + 구현 + 비트스트림)
echo  [3] Create and Build (1 + 2)
echo  [4] Open Project in Vivado GUI
echo  [5] Clean Project
echo  [6] Program FPGA (Hardware Manager)
echo.
echo  [0] Exit
echo.
echo ==============================================================================
set /p choice="Select option: "

if "%choice%"=="1" goto CREATE
if "%choice%"=="2" goto BUILD
if "%choice%"=="3" goto CREATE_BUILD
if "%choice%"=="4" goto OPEN_GUI
if "%choice%"=="5" goto CLEAN
if "%choice%"=="6" goto PROGRAM
if "%choice%"=="0" goto EXIT
goto MENU

:CREATE
echo.
echo Creating Vivado project...
call "%VIVADO_BAT%" -mode batch -source create_project.tcl
pause
goto MENU

:BUILD
echo.
echo Building project (Synthesis + Implementation + Bitstream)...
call "%VIVADO_BAT%" -mode batch -source build_all.tcl
pause
goto MENU

:CREATE_BUILD
echo.
echo Creating and building project...
call "%VIVADO_BAT%" -mode batch -source create_project.tcl
call "%VIVADO_BAT%" -mode batch -source build_all.tcl
pause
goto MENU

:OPEN_GUI
echo.
echo Opening Vivado GUI...
if exist "kv260_led_basic\kv260_led_basic.xpr" (
    start "" "%VIVADO_BAT%" kv260_led_basic\kv260_led_basic.xpr
) else (
    echo Project not found. Creating first...
    call "%VIVADO_BAT%" -mode batch -source create_project.tcl
    start "" "%VIVADO_BAT%" kv260_led_basic\kv260_led_basic.xpr
)
goto MENU

:CLEAN
echo.
echo Cleaning project files...
if exist "kv260_led_basic" (
    rmdir /s /q kv260_led_basic
    echo Project directory removed.
)
if exist "reports" (
    rmdir /s /q reports
    echo Reports directory removed.
)
if exist ".Xil" (
    rmdir /s /q .Xil
    echo .Xil directory removed.
)
del /q *.bit 2>nul
del /q *.xsa 2>nul
del /q *.log 2>nul
del /q *.jou 2>nul
echo Clean completed.
pause
goto MENU

:PROGRAM
echo.
echo Opening Hardware Manager...
echo.
echo Steps to program FPGA:
echo   1. Connect KV260 via USB
echo   2. Open Target ^> Auto Connect
echo   3. Program Device
echo   4. Select bitstream file
echo.
call "%VIVADO_BAT%" -mode gui -source program_fpga.tcl
pause
goto MENU

:EXIT
echo.
echo Goodbye!
exit /b 0
