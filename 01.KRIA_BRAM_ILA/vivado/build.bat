@echo off
REM ==============================================================================
REM KV260 BRAM AXI ILA Project - Windows Build Script
REM Vivado Version: 2022.2
REM ==============================================================================

echo.
echo ============================================================
echo   KV260 BRAM AXI ILA Project Builder
echo ============================================================
echo.

REM Vivado 경로 설정 (필요시 수정)
set VIVADO_PATH=C:\Xilinx\Vivado\2022.2\bin

REM 현재 디렉토리 저장
set PROJECT_DIR=%~dp0

REM Vivado가 설치되어 있는지 확인
if not exist "%VIVADO_PATH%\vivado.bat" (
    echo ERROR: Vivado not found at %VIVADO_PATH%
    echo Please modify VIVADO_PATH in this script.
    pause
    exit /b 1
)

REM 메뉴 출력
:menu
echo.
echo Select an option:
echo   1. Create Vivado Project (create_project.tcl)
echo   2. Build All (synth + impl + bitstream + xsa)
echo   3. Create Project and Build All
echo   4. Open Vivado GUI with project
echo   5. Clean project
echo   0. Exit
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
echo Creating Vivado project...
cd /d "%PROJECT_DIR%"
call "%VIVADO_PATH%\vivado.bat" -mode batch -source create_project.tcl
if %errorlevel% neq 0 (
    echo ERROR: Project creation failed!
    pause
    goto menu
)
echo Project created successfully!
pause
goto menu

:build_all
echo.
echo Building project (this may take 10-30 minutes)...
cd /d "%PROJECT_DIR%"
call "%VIVADO_PATH%\vivado.bat" -mode batch -source build_all.tcl
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    goto menu
)
echo Build completed successfully!
echo.
echo Generated files:
echo   - XSA: kv260_bram_ila\kv260_bram_ila.xsa
echo   - LTX: kv260_bram_ila\kv260_bram_ila.ltx
pause
goto menu

:create_and_build
echo.
echo Creating and building project...
cd /d "%PROJECT_DIR%"
call "%VIVADO_PATH%\vivado.bat" -mode batch -source create_project.tcl
if %errorlevel% neq 0 (
    echo ERROR: Project creation failed!
    pause
    goto menu
)
call "%VIVADO_PATH%\vivado.bat" -mode batch -source build_all.tcl
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    goto menu
)
echo.
echo ============================================================
echo   BUILD COMPLETED SUCCESSFULLY!
echo ============================================================
echo.
echo Next steps:
echo   1. Open Vitis: vitis -workspace .\vitis_workspace
echo   2. Create Platform from: kv260_bram_ila\kv260_bram_ila.xsa
echo   3. Create Application and import main.c
echo   4. Build and run!
echo.
pause
goto menu

:open_gui
echo.
echo Opening Vivado GUI...
cd /d "%PROJECT_DIR%"
start "" "%VIVADO_PATH%\vivado.bat" kv260_bram_ila\kv260_bram_ila.xpr
goto menu

:clean
echo.
echo Cleaning project...
cd /d "%PROJECT_DIR%"
if exist kv260_bram_ila (
    rmdir /s /q kv260_bram_ila
    echo Project directory removed.
)
if exist .Xil (
    rmdir /s /q .Xil
    echo .Xil directory removed.
)
if exist vivado*.log (
    del /q vivado*.log
    echo Log files removed.
)
if exist vivado*.jou (
    del /q vivado*.jou
    echo Journal files removed.
)
echo Clean completed!
pause
goto menu

:end
echo.
echo Goodbye!
exit /b 0
