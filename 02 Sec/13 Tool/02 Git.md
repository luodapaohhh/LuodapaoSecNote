### 前言
- 这是我的git的学习历程，在我学习网络安全的过程中，不可避免地会接触到git来，因此，我想在学习的过程中把docker的功能和用法讲清楚，帮助别人使用和自己复习。
-  注：此篇文章着重讲命令行下对Git的使用
### Git介绍
- 对项目进行版本控制、协作开发、安全代码等功能的分布式系统
### Git核心概念
- **仓库（Repository）**：项目的版本库，包含所有历史记录
- **提交（Commit）**：代码变更的快照
- **分支（Branch）**：独立开发线
- **合并（Merge）**：整合不同分支的变更
### Git安装
- 官网下载 https://git-scm.com/
- 找到对应电脑系统的网址
- 按照提示选项，完成下载
### Git常用命令
- 初始化和配置
	`git init                    # 初始化仓库`
	`git config --global user.name "你的名字"`
	`git config --global user.email "你的邮箱"`
- 日常高频命令
	`git status                    # 查看状态`
	`git add .                     # 添加所有更改`
	`git commit -m "message"       # 提交`
	`git push                      # 推送`
	`git pull                      # 拉取更新`
- 分支管理
	`git branch                    # 查看分支`
	`git branch new-feature        # 创建分支`
	`git checkout new-feature      # 切换分支`
	`git merge feature-branch      # 合并分支`
- 查看信息
	`git log --oneline --graph     # 图形化历史`
	`git show <commit-id>          # 查看某次提交详情`
	`git blame <filename>          # 查看文件每行修改历史`
### Git工作流程
![[{F04FA4D9-EA09-42C3-8AD3-B8370152C974}.png]]
#### 01 Git配置
- `git config --global user.name "你的名字"` --配置用户名
- `git config --global user.email "你的邮箱"` --配置邮箱
- `git config --global core.editor "vim"` --配置默认编辑器
- `git config --list` --查看配置信息
#### 02Git创建本地仓库
- 初始化新项目
	- `mkdir my-project` --创建文件夹
	- `cd my-project` --切换到操作目录
	- `git init` --初始化Git仓库
- 查看仓库状态
	- `git status` --查看当前状态
- 创建第一个文件并跟踪
	- `echo "# My First Git Project" >> README.md`
	- `echo "This is a learning project for Git." >> README.md` --创建README文件
	- `git status` --查看状态变化，会显示README.md是''Untracked files''
- 添加文件到暂存区
	- `git add README.md` --添加单个文件
	- `git add .` --添加所有文件
	- `git status` --查看状态变化，会显示现在是‘’Change to be commited‘’
- 第一次提交
	- `git commit -m "提交信息`" --提交到本地仓库
- 查看提交历史
	- `git log` --查看完整历史
	- `git log --oneline` --查看简洁历史
	- `git log --graph --oneline --all` --查看图形化历史
#### 03基础工作流程
- 修改文件并提交
	- `echo "## Features" >> README.md`
	- `echo "- Learning Git basics" >> README.md`
	- `echo "- Practice commands" >> README.md`  --编辑README文件
	- `git diff` --查看修改了什么
	- `git add README.md` --添加到暂存区
	- `git commit -m "docs:add features section to README"` --提交
- 创建并切换分支
	- `git branch` --查看当前分支
	- `git checkout -b feature/add-contributing`  --创建并切换到新分支，-b切换到当前分支
	-  `git switch -c feature/add-contributing` --推荐新写法，同样是创建分支，-c切换到当前分支
	- `echo "# Contributing Guidelines" >> CONTRIBUTING.md`
	- `echo "Please follow these rules..." >> CONTRIBUTING.md`
	- `git add CONTRIBUTING.md`
	- `git commit -m "docs: add contributing guidelines"`
- 切换回主分支并合并
	- `git switch main   或 git checkout main` --切换回主分支
	- `git merge feature/add-contributing -m "Merge branch 'feature/add-contributing'"` --合并feature分支到当前主分支
	- `git branch -d feature/add-contributing` --删除已合并的分支，-d安全删除
- 处理合并冲突
	- 创建两个分支修改同一文件
		`git checkout -b feature-a`
		`echo "Content from feature A" >> test.txt`
		`git add test.txt`
		`git commit -m "Add feature A content"`
		`git checkout main`
		`git checkout -b feature-b`
		`echo "Content from feature B" >> test.txt`
		`git add test.txt`
		`git commit -m "Add feature B content"`
	- 尝试合并会产生冲突
		`git checkout main`
		`git merge feature-a`
		`git merge feature-b  这里会产生冲突`
	- 查看冲突文件
		- `cat test.txt 会显示冲突标记：<<<<<<< HEAD，=======，>>>>>>> feature-b`
	- 手动解决冲突后
		`git add test.txt`
		`git commit -m "Resolve merge conflict between feature A and B"`
#### 04连接远程仓库
- 创建远程仓库
	- `git remote add origin https://github.com/yourusername/my-project.git` --添加远程仓库
	- `git remote -v` --查看远程仓库
- 推送到远程仓库
	- `git push -u origin main` --第一次推送，设置上游分支
	- `git push` --后续推送
	- `git pull origin main --rebase` --如果遇到拒绝，可能需要先拉取
- 从远程仓库克隆
	- `cd ..`
	- `git clone https://github.com/someuser/some-project.git`
	- `cd some-project`
- 拉取更新
	- `git pull origin main`
	- `git fetch origin`
	- `git merge origin/main`
#### 05实用操作技巧
- 撤销更改
	`撤销工作区的修改（未add的）`
		`git checkout -- README.md`
		# `或使用新命令`
		`git restore README.md`
	`撤销暂存区的修改（已add未commit的）`
		`git reset HEAD README.md`
		# `或使用新命令`
		`git restore --staged README.md`
	`撤销最近一次提交（保留修改）`
		`git reset --soft HEAD~1`
	`彻底删除最近一次提交（丢弃修改）`
		`git reset --hard HEAD~1`
	`创建撤销提交（推荐用于已推送的提交）`
		`git revert HEAD`
- 储藏和恢复
	`撤销工作区的修改（未add的）`
		`git checkout -- README.md`
		# `或使用新命令`
		`git restore README.md`
	`销暂存区的修改（已add未commit的）` 
		`git reset HEAD README.md`
	# `或使用新命令`
		`git restore --staged README.md`
	`撤销最近一次提交（保留修改）`
		`git reset --soft HEAD~1`
	`彻底删除最近一次提交（丢弃修改）`
		`git reset --hard HEAD~1`
	`创建撤销提交（推荐用于已推送的提交）`
		`git revert HEAD`
- 标签管理
	`创建轻量标签`
		`git tag v1.0.0`
	`创建带注释的标签`
		`git tag -a v1.0.0 -m "Release version 1.0.0"`
	`查看所有标签`
		`git tag`
	`推送标签到远程`
		`git push origin v1.0.0`
	`推送所有标签`
		`git push origin --tag`
- 忽略文件
	- `cat > .gitignore 
	- `git add .gitignore`
	- `git commit -m "chore: add .gitignore file"`
### Git注意事项
- 设置别名提高效率
	`git config --global alias.co checkout`
	`git config --global alias.br branch`
	`git config --global alias.ci commit`
	`git config --global alias.st status`
	`git config --global alias.lg "log --oneline --graph --all"`
### 结语
- Git的具体知识点很多很复杂，具体可以参考官方Git使用手册，祝大家天天开心！



