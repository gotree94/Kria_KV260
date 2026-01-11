@echo off
chcp 949 > nul
setlocal enabledelayedexpansion

REM ==============================================================================
REM KV260 BRAM AXI ILA Project - Windows Build Script
REM Vivado Version: 2022.2
REM ==============================================================================

echo.
echo ============================================================
echo   KV260 BRAM AXI ILA Project Builder
echo ============================================================
echo.

REM Vivado path - MODIFY THIS TO YOUR VIVADO INSTALLATION PATH
set VIVADO_PATH=C:\Xilinx\Vivado\2022.2\bin\vivado.bat

REM Check if Vivado exists
if not exist "%VIVADO_PATH%" (
    echo [ERROR] Vivado not found at: %VIVADO_PATH%
    echo.
    echo Please edit this batch file and set VIVADO_PATH correctly.
    echo Example paths:
    echo   C:\Xilinx\Vivado\2022.2\bin\vivado.bat
    echo   D:\Xilinx\Vivado\2022.2\bin\vivado.bat
    echo.
    pause
    exit /b 1
)

echo Vivado found: %VIVADO_PATH%
echo.

:menu
echo.
echo ============================================================
echo Select an option:
echo   1. Create Vivado Project
echo   2. Build All (synth + impl + bitstream + xsa)
echo   3. Create Project and Build All
echo   4. Open Vivado GUI with project
echo   5. Clean project
echo   0. Exit
echo ============================================================
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto create_project
if "%choice%"=="2" goto build_all
if "%choice%"=="3" goto create_and_build
if "%choice%"=="4" goto open_gui
if "%choice%"=="5" goto clean
if "%choice%"=="0" goto end

echo Invalid choice!
goto menu

:create_project
echo.
echo [INFO] Creating Vivado project...
echo.
call "%VIVADO_PATH%" -mode batch -source create_project.tcl
if %errorlevel% neq 0 (
    echo [ERROR] Project creation failed!
    pause
    goto menu
)
echo [SUCCESS] Project created!
pause
goto menu

:build_all
echo.
echo [INFO] Building project (this may take 10-30 minutes)...
echo.
call "%VIVADO_PATH%" -mode batch -source build_all.tcl
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    pause
    goto menu
)
echo [SUCCESS] Build completed!
echo.
echo Generated files:
echo   - XSA: kv260_bram_ila\kv260_bram_ila.xsa
echo   - LTX: kv260_bram_ila\kv260_bram_ila.ltx
pause
goto menu

:create_and_build
echo.
echo [INFO] Creating and building project...
echo.
call "%VIVADO_PATH%" -mode batch -source create_project.tcl
if %errorlevel% neq 0 (
    echo [ERROR] Project creation failed!
    pause
    goto menu
)
echo [INFO] Project created. Starting build...
echo.
call "%VIVADO_PATH%" -mode batch -source build_all.tcl
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    pause
    goto menu
)
echo.
echo ============================================================
echo   BUILD COMPLETED SUCCESSFULLY!
echo ============================================================
echo.
echo Generated files:
echo   - XSA: kv260_bram_ila\kv260_bram_ila.xsa
echo   - LTX: kv260_bram_ila\kv260_bram_ila.ltx
echo.
echo Next steps:
echo   1. Open Vitis
echo   2. Create Platform from XSA file
echo   3. Create Application and import main.c
echo   4. Build and run!
echo.
pause
goto menu

:open_gui
echo.
echo [INFO] Opening Vivado GUI...
if exist "kv260_bram_ila\kv260_bram_ila.xpr" (
    start "" "%VIVADO_PATH%" kv260_bram_ila\kv260_bram_ila.xpr
) else (
    echo [ERROR] Project not found! Run option 1 first.
    pause
)
goto menu

:clean
echo.
echo [INFO] Cleaning project...
if exist kv260_bram_ila (
    rmdir /s /q kv260_bram_ila
    echo   Removed: kv260_bram_ila
)
if exist .Xil (
    rmdir /s /q .Xil
    echo   Removed: .Xil
)
del /q vivado*.log 2>nul
del /q vivado*.jou 2>nul
del /q *.str 2>nul
echo [SUCCESS] Clean completed!
pause
goto menu

:end
echo.
echo Goodbye!
endlocal
exit /b 0
