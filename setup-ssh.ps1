<#
SSH密钥一键配置脚本 for GitHub

功能：
1. 检查是否已有SSH密钥
2. 生成新的SSH密钥（ed25519）
3. 显示公钥内容
4. 指导添加到GitHub
5. 测试SSH连接
6. 切换远程仓库为SSH

使用方法：
1. 右键点击此文件 → "使用PowerShell运行"
2. 或打开PowerShell：.\setup-ssh.ps1

#>

$ErrorActionPreference = "Stop"

Write-Host "=== GitHub SSH密钥一键配置 ===" -ForegroundColor Cyan
Write-Host "开始时间: $(Get-Date)" -ForegroundColor Yellow
Write-Host ""

# 检查Git是否安装
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitPath) {
    Write-Host "错误: 未找到Git，请先安装Git。" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Git已安装" -ForegroundColor Green

# 检查ssh-keygen是否可用
$sshKeygenPath = Get-Command ssh-keygen -ErrorAction SilentlyContinue
if (-not $sshKeygenPath) {
    Write-Host "错误: 未找到ssh-keygen，请确保Git Bash已安装。" -ForegroundColor Red
    exit 1
}

Write-Host "✓ ssh-keygen可用" -ForegroundColor Green

# 设置SSH目录路径
$sshDir = Join-Path $env:USERPROFILE ".ssh"
$privateKey = Join-Path $sshDir "id_ed25519"
$publicKey = "$privateKey.pub"

Write-Host "`n=== 步骤1: 检查现有SSH密钥 ===" -ForegroundColor Cyan

if (Test-Path $privateKey) {
    Write-Host "检测到已有SSH密钥: $privateKey" -ForegroundColor Yellow
    $choice = Read-Host "是否生成新密钥？(y/N)"
    if ($choice -ne 'y' -and $choice -ne 'Y') {
        Write-Host "使用现有密钥。" -ForegroundColor Green
        $generateNewKey = $false
    } else {
        $generateNewKey = $true
    }
} else {
    Write-Host "未找到现有SSH密钥。" -ForegroundColor Green
    $generateNewKey = $true
}

if ($generateNewKey) {
    Write-Host "`n=== 步骤2: 生成SSH密钥 ===" -ForegroundColor Cyan

    # 确保.ssh目录存在
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
        Write-Host "创建SSH目录: $sshDir" -ForegroundColor Green
    }

    Write-Host "正在生成ED25519密钥对..." -ForegroundColor Green
    Write-Host "注意: 按三次回车接受默认值（不设置密码）" -ForegroundColor Yellow

    # 生成密钥（非交互式，无密码）
    & ssh-keygen -t ed25519 -C "luodapaohhh@outlook.com" -f $privateKey -N '""'

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ SSH密钥生成成功！" -ForegroundColor Green
        Write-Host "私钥: $privateKey" -ForegroundColor Gray
        Write-Host "公钥: $publicKey" -ForegroundColor Gray
    } else {
        Write-Host "错误: 密钥生成失败" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n=== 步骤3: 显示公钥内容 ===" -ForegroundColor Cyan
Write-Host "请复制以下全部内容（从ssh-ed25519到邮箱结尾）：" -ForegroundColor Yellow
Write-Host ""

# 显示公钥内容
$publicKeyContent = Get-Content $publicKey -Raw
Write-Host $publicKeyContent -ForegroundColor White
Write-Host ""

Write-Host "=== 步骤4: 添加到GitHub ===" -ForegroundColor Cyan
Write-Host "请按以下步骤操作：" -ForegroundColor Yellow
Write-Host "1. 打开浏览器，访问: https://github.com/settings/keys" -ForegroundColor White
Write-Host "2. 点击 'New SSH key' 按钮" -ForegroundColor White
Write-Host "3. Title（标题）: 输入 'My Computer' 或任意名称" -ForegroundColor White
Write-Host "4. Key type（密钥类型）: 保持默认 'Authentication Key'" -ForegroundColor White
Write-Host "5. Key（密钥）: 粘贴上面复制的公钥内容" -ForegroundColor White
Write-Host "6. 点击 'Add SSH key'" -ForegroundColor White
Write-Host ""

$continue = Read-Host "完成后按回车继续"

Write-Host "`n=== 步骤5: 测试SSH连接 ===" -ForegroundColor Cyan
Write-Host "测试连接到GitHub..." -ForegroundColor Green

# 测试SSH连接
$testResult = & ssh -T git@github.com 2>&1

if ($LASTEXITCODE -eq 1 -and $testResult -match "successfully authenticated") {
    Write-Host "✓ SSH连接成功！" -ForegroundColor Green
    Write-Host "输出: $testResult" -ForegroundColor Gray
} else {
    Write-Host "⚠ SSH连接测试结果: $testResult" -ForegroundColor Yellow
    Write-Host "如果看到 'successfully authenticated' 就表示成功。" -ForegroundColor Yellow
}

Write-Host "`n=== 步骤6: 切换远程仓库为SSH ===" -ForegroundColor Cyan

# 进入笔记目录
$noteDir = "D:\Note"
if (-not (Test-Path $noteDir)) {
    Write-Host "错误: 笔记目录不存在: $noteDir" -ForegroundColor Red
    exit 1
}

Set-Location $noteDir
Write-Host "当前目录: $(Get-Location)" -ForegroundColor Green

# 检查是否Git仓库
$isGitRepo = git rev-parse --is-inside-work-tree 2>$null
if (-not $isGitRepo) {
    Write-Host "错误: 当前目录不是Git仓库" -ForegroundColor Red
    exit 1
}

# 切换远程URL
Write-Host "正在切换远程仓库URL为SSH..." -ForegroundColor Green
git remote set-url origin git@github.com:luodapaohhh/LuodapaoSecNote.git

# 验证切换
Write-Host "`n验证远程仓库配置:" -ForegroundColor Green
git remote -v

Write-Host "`n=== 步骤7: 测试推送 ===" -ForegroundColor Cyan

# 创建测试文件
$testFile = "ssh_setup_test.md"
$testContent = "# SSH配置测试`n`n配置时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n此文件用于测试SSH连接是否正常工作。"
$testContent | Set-Content $testFile

Write-Host "创建测试文件: $testFile" -ForegroundColor Green

# 添加、提交、推送
Write-Host "添加测试文件到Git..." -ForegroundColor Green
git add $testFile

Write-Host "提交更改..." -ForegroundColor Green
git commit -m "测试SSH连接配置" -q

Write-Host "推送到GitHub..." -ForegroundColor Green
$pushResult = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ 推送成功！SSH配置完成。" -ForegroundColor Green
    Write-Host "推送输出: $pushResult" -ForegroundColor Gray

    # 清理测试文件
    Write-Host "`n清理测试文件..." -ForegroundColor Green
    git rm $testFile -q
    git commit -m "删除SSH测试文件" -q
    git push origin main -q 2>$null
    Write-Host "✓ 清理完成" -ForegroundColor Green
} else {
    Write-Host "⚠ 推送失败，错误信息:" -ForegroundColor Red
    Write-Host $pushResult -ForegroundColor Red
    Write-Host "`n请检查：" -ForegroundColor Yellow
    Write-Host "1. 是否已将公钥添加到GitHub" -ForegroundColor Yellow
    Write-Host "2. 是否对仓库有写入权限" -ForegroundColor Yellow
    Write-Host "3. 网络连接是否正常" -ForegroundColor Yellow
}

Write-Host "`n=== 配置总结 ===" -ForegroundColor Cyan
Write-Host "✓ SSH密钥: $privateKey" -ForegroundColor Green
Write-Host "✓ 公钥已添加到GitHub" -ForegroundColor Green
Write-Host "✓ 远程仓库已切换为SSH" -ForegroundColor Green
Write-Host "✓ 测试推送完成" -ForegroundColor Green
Write-Host ""
Write-Host "现在你的笔记仓库使用SSH连接，无需每次输入密码！" -ForegroundColor Green
Write-Host ""
Write-Host "后续使用：" -ForegroundColor Yellow
Write-Host "1. 同步笔记: 运行 .\sync.ps1" -ForegroundColor White
Write-Host "2. 手动同步: git add . && git commit -m '更新' && git push" -ForegroundColor White
Write-Host ""
Write-Host "结束时间: $(Get-Date)" -ForegroundColor Yellow
Write-Host "=== SSH配置完成 ===" -ForegroundColor Cyan