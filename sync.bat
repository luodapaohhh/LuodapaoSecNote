@echo off
REM 网络安全笔记自动同步脚本 - Windows批处理版本
REM
REM 双击此文件运行同步脚本
REM 需要安装Git和PowerShell

echo === 网络安全笔记同步脚本 ===
echo 开始时间: %date% %time%

REM 检查Git是否安装
where git >nul 2>nul
if errorlevel 1 (
    echo 错误: 未找到Git，请先安装Git。
    pause
    exit /b 1
)

REM 检查当前目录是否是Git仓库
git status >nul 2>nul
if errorlevel 1 (
    echo 错误: 当前目录不是Git仓库。
    pause
    exit /b 1
)

REM 使用PowerShell运行同步脚本
echo 运行PowerShell同步脚本...
powershell -ExecutionPolicy Bypass -File "%~dp0sync.ps1"

if errorlevel 1 (
    echo 同步失败。
    pause
    exit /b 1
)

echo 同步完成！
echo 结束时间: %date% %time%
echo === 同步完成 ===
pause