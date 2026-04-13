# 网络安全笔记同步指南

本文档介绍如何配置和自动同步网络安全笔记到 GitHub 仓库。

## 目录

1. [Git 认证配置](#git-认证配置)
2. [手动同步脚本](#手动同步脚本)
3. [自动同步设置](#自动同步设置)
4. [故障排除](#故障排除)

## Git 认证配置

### 方法一：使用 SSH 密钥（推荐）

1. 生成 SSH 密钥（如果尚未生成）：
   ```bash
   ssh-keygen -t ed25519 -C "luodapaohhh@outlook.com"
   ```

2. 将公钥添加到 GitHub：
   - 复制公钥内容：`cat ~/.ssh/id_ed25519.pub`
   - 访问 GitHub → Settings → SSH and GPG keys → New SSH key
   - 粘贴公钥并保存

3. 更新远程仓库 URL 为 SSH：
   ```bash
   git remote set-url origin git@github.com:luodapaohhh/LuodapaoSecNote.git
   ```

### 方法二：使用 HTTPS 和个人访问令牌

1. 在 GitHub 创建个人访问令牌：
   - GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - 选择权限：`repo`（完全控制仓库）
   - 生成并复制令牌

2. 更新远程仓库 URL 包含令牌：
   ```bash
   git remote set-url origin https://luodapaohhh:你的令牌@github.com/luodapaohhh/LuodapaoSecNote.git
   ```

## 手动同步脚本

仓库中包含三个同步脚本：

### PowerShell 脚本 (`sync.ps1`)
```powershell
.\sync.ps1
```

### Bash 脚本 (`sync.sh`)
```bash
# 首先给予执行权限
chmod +x sync.sh
./sync.sh
```

### Windows 批处理脚本 (`sync.bat`)
双击 `sync.bat` 文件即可运行。

## 自动同步设置

### Windows 任务计划程序

1. 打开"任务计划程序"
2. 创建基本任务：
   - 名称：`网络安全笔记同步`
   - 触发器：每天、每周等
   - 操作：启动程序
     - 程序/脚本：`powershell.exe`
     - 参数：`-ExecutionPolicy Bypass -File "D:\Note\sync.ps1"`
3. 设置条件（可选）：
   - 只在计算机使用交流电源时运行
   - 只有在网络连接可用时才启动

### Git Bash / Linux cron（如果使用 Git Bash）

1. 打开 cron 编辑器：
   ```bash
   crontab -e
   ```

2. 添加定时任务（示例：每天上午9点同步）：
   ```bash
   0 9 * * * cd /d/Note && ./sync.sh >> /d/Note/sync.log 2>&1
   ```

3. 常用时间设置：
   - `0 9 * * *` - 每天上午9点
   - `0 */6 * * *` - 每6小时
   - `0 9 * * 1` - 每周一上午9点

### 手动测试自动同步

在设置自动任务前，先手动测试：
```bash
cd /d/Note
./sync.sh
```

## 故障排除

### 1. "Host key verification failed" 错误
```bash
# 手动添加 GitHub 主机密钥
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### 2. "Permission denied" 错误
- 检查 SSH 密钥是否添加到 GitHub
- 检查远程仓库 URL 是否正确
- 确保对仓库有写入权限

### 3. 脚本执行权限问题（Linux/Git Bash）
```bash
chmod +x sync.sh
```

### 4. 网络连接问题
- 检查网络连接
- 尝试使用不同的网络环境
- 检查防火墙设置

### 5. Git 配置问题
检查 Git 配置：
```bash
git config --list
```

确保已设置用户信息：
```bash
git config user.name "luodapao"
git config user.email "luodapaohhh@outlook.com"
```

## 高级设置

### 忽略特定文件
编辑 `.gitignore` 文件，添加不希望同步的文件模式。

### 提交前检查
修改 `sync.ps1` 或 `sync.sh`，在提交前添加自定义检查逻辑。

### 邮件通知
配置 Git 在推送失败时发送邮件通知。

## 注意事项

1. **不要提交敏感信息**：确保 `.gitignore` 正确配置，避免提交密码、密钥等敏感数据。
2. **定期备份**：虽然使用 Git，但仍建议定期在其他位置备份重要笔记。
3. **冲突处理**：如果多台设备同时修改，可能会产生冲突。定期拉取远程更改：
   ```bash
   git pull origin main
   ```

## 支持

如遇问题，请参考：
- [Git 官方文档](https://git-scm.com/doc)
- [GitHub 帮助](https://docs.github.com/)
- [PowerShell 文档](https://docs.microsoft.com/powershell/)