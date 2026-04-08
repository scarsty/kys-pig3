@echo off
chcp 65001 >nul
setlocal

rem ============================================================
rem  kys-pig3 C++ 版 Android 自动编译脚本
rem  编译 libkys_pig3_c.so 并打包 APK (含游戏资源)
rem ============================================================

set PROJECT_DIR=%~dp0
cd /d "%PROJECT_DIR%"

rem --- 检查旧的 Pascal SO, 如存在则删除避免冲突 ---
if exist "app\lib\arm64-v8a\libkys_pig3.so" (
    echo [INFO] 删除旧的 Pascal 版 libkys_pig3.so ...
    del "app\lib\arm64-v8a\libkys_pig3.so"
)

rem --- 清理旧的 CMake 构建缓存 (可选, 首次切换到C++时建议启用) ---
if "%1"=="clean" (
    echo [INFO] 清理 CMake 构建缓存 ...
    if exist "app\.cxx" rd /s /q "app\.cxx"
    if exist "app\build" rd /s /q "app\build"
)

rem --- 调用 Gradle 编译 native 库 + 打包 APK ---
echo.
echo ============================================================
echo  编译 libkys_pig3_c.so 并打包 APK ...
echo ============================================================
echo.

call gradlew.bat assembleRelease
if errorlevel 1 (
    echo.
    echo [ERROR] 编译失败!
    pause
    exit /b 1
)

rem --- 复制 APK 到项目根目录 ---
echo.
echo [INFO] 复制 APK 到当前目录 ...
copy "app\build\outputs\apk\release\*.apk" . /y

echo.
echo ============================================================
echo  编译完成!
echo  APK: %PROJECT_DIR%kys-pig3-release.apk
echo ============================================================
pause
