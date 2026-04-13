<#
网络安全笔记自动同步脚本 - PowerShell版本

使用方法：
1. 确保已配置Git用户信息和远程仓库
2. 运行此脚本：.\sync.ps1

脚本会：
- 检查是否有未提交的更改
- 自动添加所有更改
- 提交并推送

#>

# 设置错误处理
$ErrorActionPreference = "Stop"

Write-Host "=== 网络安全笔记同步脚本 ===" -ForegroundColor Cyan
Write-Host "开始时间: $(Get-Date)" -ForegroundColor Yellow

try {
    # 检查是否有未提交的更改
    Write-Host "检查Git状态..." -ForegroundColor Green
    $status = git status --porcelain

    if ([string]::IsNullOrEmpty($status)) {
        Write-Host "没有需要提交的更改。" -ForegroundColor Green
        exit 0
    }

    Write-Host "检测到以下更改：" -ForegroundColor Yellow
    git status --short

    # 添加所有更改
    Write-Host "添加所有更改到暂存区..." -ForegroundColor Green
    git add --all

    # 提交更改
    $commitMessage = "自动同步: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "提交更改: $commitMessage" -ForegroundColor Green
    git commit -m $commitMessage

    # 推送到远程仓库
    Write-Host "推送到远程仓库..." -ForegroundColor Green
    git push origin main

    Write-Host "同步完成!" -ForegroundColor Green

} catch {
    Write-Host "同步过程中出现错误: $_" -ForegroundColor Red
    Write-Host "错误详情: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "结束时间: $(Get-Date)" -ForegroundColor Yellow
Write-Host "=== 同步完成 ===" -ForegroundColor Cyan