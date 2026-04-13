#!/bin/bash

# 网络安全笔记自动同步脚本 - Bash版本
#
# 使用方法：
# 1. 确保已配置Git用户信息和远程仓库
# 2. 运行此脚本：./sync.sh
#
# 脚本会：
# - 检查是否有未提交的更改
# - 自动添加所有更改
# - 提交并推送

set -e  # 遇到错误退出

echo "=== 网络安全笔记同步脚本 ==="
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"

# 检查是否有未提交的更改
echo "检查Git状态..."
status=$(git status --porcelain)

if [ -z "$status" ]; then
    echo "没有需要提交的更改。"
    exit 0
fi

echo "检测到以下更改："
git status --short

# 添加所有更改
echo "添加所有更改到暂存区..."
git add --all

# 提交更改
commit_message="自动同步: $(date '+%Y-%m-%d %H:%M:%S')"
echo "提交更改: $commit_message"
git commit -m "$commit_message"

# 推送到远程仓库
echo "推送到远程仓库..."
git push origin main

echo "同步完成!"
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=== 同步完成 ==="