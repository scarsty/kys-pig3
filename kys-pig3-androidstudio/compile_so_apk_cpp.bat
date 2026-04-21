@echo off
chcp 65001 >nul
setlocal

set PROJECT_DIR=%~dp0
cd /d "%PROJECT_DIR%"

set "GAME_ASSETS_DIR=D:\kys-all\_pascal\pig3\发布版游戏\game"
set "NEED_CLEAN=0"
if "%~1"=="clean" set "NEED_CLEAN=1"

if not exist "%GAME_ASSETS_DIR%" (
    echo [ERROR] 游戏资源目录不存在: %GAME_ASSETS_DIR%
    exit /b 1
)

if exist "app\lib\arm64-v8a\libkys_pig3.so" del "app\lib\arm64-v8a\libkys_pig3.so"
if "%NEED_CLEAN%"=="1" (
    if exist "app\.cxx" rd /s /q "app\.cxx"
    if exist "app\build" rd /s /q "app\build"
)

call gradlew.bat assembleRelease -PGAME_ASSETS_DIR="%GAME_ASSETS_DIR%"
if errorlevel 1 ( echo [ERROR] 编译失败! ^& exit /b 1 )

copy "app\build\outputs\apk\release\*.apk" . /y

for %%A in ("%PROJECT_DIR%kys-pig3-release.apk") do set "APK_SIZE=%%~zA"
echo [INFO] APK size: %APK_SIZE% bytes
if %APK_SIZE% LSS 209715200 ( echo [ERROR] APK 小于 200MB ^& exit /b 1 )

echo 编译完成！APK: %PROJECT_DIR%kys-pig3-release.apk
exit /b 0