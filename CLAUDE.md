# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cybersecurity study notes repository managed with [Obsidian](https://obsidian.md/). Notes are version-controlled with Git and synced to a GitHub repository (https://github.com/luodapaohhh/LuodapaoSecNote.git).

## Directory Structure

- `01 Link/` – Links and resources (images, attachments)
- `02 Sec/` – Cybersecurity notes
  - `13 Tool/` – Tool usage notes (Docker, Git, BurpSuite, SqlMap, etc.)
- `03 Internship/` – Internship-related notes (currently empty)
- `.obsidian/` – Obsidian configuration (tracked in Git)
- `.claude/` – Claude Code memory (ignored in `.gitignore`)

## Syncing Notes to GitHub

The repository includes automated sync scripts that check for changes, commit them, and push to the remote `main` branch.

### Sync Scripts

- **`sync.ps1`** – PowerShell script (preferred on Windows)
- **`sync.sh`** – Bash script
- **`sync.bat`** – Windows batch wrapper that calls `sync.ps1`

All scripts:
1. Check for uncommitted changes
2. Stage all changes with `git add --all`
3. Commit with a timestamped message
4. Push to `origin/main`

Run sync manually:
```bash
# PowerShell (Windows)
.\sync.ps1

# Bash (Linux/macOS/Git Bash)
./sync.sh

# Windows batch
sync.bat
```

### SSH Configuration

For password‑free authentication, use the `setup-ssh.ps1` script to:
1. Generate an SSH key pair (ed25519)
2. Display the public key for adding to GitHub
3. Test the SSH connection
4. Switch the remote URL to SSH (`git@github.com:luodapaohhh/LuodapaoSecNote.git`)

### Automatic Scheduling

- **Windows**: Use Task Scheduler to run `sync.ps1` periodically.
- **Linux/macOS**: Add a cron entry for `sync.sh` (see `SYNC_GUIDE.md` for examples).

## Common Commands

**Manual Git operations** (if you need more control than the sync scripts):
```bash
git status
git add --all
git commit -m "description"
git push origin main
```

**Check remote configuration**:
```bash
git remote -v
```

**Switch remote to SSH** (after setting up SSH keys):
```bash
git remote set-url origin git@github.com:luodapaohhh/LuodapaoSecNote.git
```

## Obsidian Configuration

The `.obsidian/` folder is tracked in Git and contains:
- `core-plugins.json` – Enabled core plugins (file‑explorer, graph, backlink, etc.)
- `app.json` – Basic settings (attachment folder path)
- `appearance.json` – Theme and appearance preferences
- `workspace.json` – Window and panel layout (may be machine‑specific)

Because the workspace file can differ across devices, it may cause merge conflicts. If a conflict occurs, either:
- Accept the local version and re‑open Obsidian
- Manually resolve the JSON conflict

## 笔记评估与优化工作流程

用户按章节编写网络安全学习笔记。每个章节结束后，会要求进行评估和改进。请遵循以下工作流程：

### 1. 优化原则与指导思想
**核心目标**：保留用户原意，增强内容并改进结构。

**关键原则**：
1. **保留原意优先**：用户的原始笔记框架、核心观点和技术要点应尽可能保留
2. **渐进式增强**：在原有内容基础上补充细节、示例和解释，而不是完全重写
3. **灵活性操作**：必要时可以：
   - 修改现有笔记内容（补充、重组、润色）
   - 删除冗余或重复内容
   - 增加新的子章节或说明
   - 创建新的笔记文件（如果现有结构无法容纳新增内容）
4. **实用性导向**：确保所有技术说明都可实际操作，命令完整可执行
5. **上下文长度控制**：确保单篇笔记内容在模型上下文长度限制内（如128K tokens），如内容过多可拆分为多个文件或压缩冗余

### 2. 章节结构识别
- 每个网络安全主题是 `02 Sec/` 下的独立子目录（如 `02 Sec/01 InformationCollection/`、`02 Sec/02 Web/`）
- 每章最后一篇笔记（按文件名或标题）记录该章提到的**工具项目**
- `02 Sec/13 Tool/` 是专门工具章节，每篇笔记描述一个工具，最后一篇总结跨工具主题。

### 3. 评估请求处理
当用户要求评估某个章节时：
1. 读取该目录下的所有 `.md` 文件
2. 识别工具项目总结笔记（通常是文件名排序最后的文件，或标题包含”工具项目”、”工具总结”等字样）
3. 分析章节整体结构，确定优化策略

### 4. 非工具笔记：知识层面优化
对于**除**工具项目总结之外的所有笔记，按以下维度优化：

**优化维度**：
- **完整性检查**：确保关键概念覆盖全面，如有缺失建议补充相关子主题
- **深度拓展**：在用户原有要点基础上，添加详细解释和背景知识
- **结构优化**：
  - 将列表项转化为逻辑连贯的段落
  - 添加清晰的层级标题（#、##、###）
  - 使用表格、代码块、引用等格式化元素
  - 保持原有的要点和核心内容
- **示例补充**：为抽象概念添加实际例子、真实场景或具体操作步骤
- **可读性提升**：使用清晰语言，术语首次出现时加以解释
- **实践可行性**（用户特别要求）：
  - 确保每个步骤都可执行
  - 提供完整命令、预期输出、错误处理提示
  - 添加代码块时注明操作系统和前置条件

**编辑策略**：
- 以用户的原始内容为骨架，在适当位置插入补充内容
- 保留用户的”原始声音”和技术偏好
- 避免过度学术化，保持实践导向

### 5. 工具项目总结：提取与文档化
对于**最后一篇笔记**（工具项目总结）：

**提取工具列表**：
- 从章节的所有其他笔记中提取提到的所有工具
- 列出每个工具及其在该章节上下文中的用途说明

**为每个工具创建结构化文档**：
对每个提取到的工具，提供以下三个部分：

**a. 分步教程**
- 安装说明（Windows、Linux、macOS）
- 基础配置，包含具体命令或设置
- 核心使用流程：初学者可以复制粘贴的命令序列
- **实践可行性**：确保每一步都可操作；提供精确命令、预期输出、常见错误排查技巧
- 尽可能包含截图或命令输出示例

**b. 实际案例研究**
- 应用该工具的真实的网络安全场景
- 使用工具解决该场景的分步指导
- 预期输出及其解读方法

**c. 最佳实践**
- 性能和安全性推荐的配置
- 常见陷阱及避免方法
- 与同一工作流中其他工具的集成技巧

**文档化要求**：
- **初学者友好**：假设无先验知识，解释每个术语
- **可验证性**：确保按照步骤操作能得到预期结果
- **模块化**：每个工具部分相对独立，便于参考

### 6. 输出格式与文件管理
- **非工具笔记**：直接编辑现有 `.md` 文件，在保留原内容基础上增强
- **工具项目笔记**：
  - 如果文件已存在：更新现有文件，添加提取的工具列表和每个工具的三部分文档
  - 如果文件不存在：创建新文件，使用适当的标题格式
  - 如果工具数量多或文档篇幅大：考虑将每个工具拆分为独立子文件，在主文件中建立索引
- **新文件创建**：当新增内容不适合放入现有文件时，可创建新文件，保持文件名编号连续性
- **文件重命名/重组**：如果现有文件结构严重影响可读性，可在与用户确认后进行重组

### 7. 优化结果汇报
完成优化后，向用户提供简要总结：
- 优化了哪些笔记，主要改进点
- 提取了哪些工具，工具文档位置
- 如有重大结构调整（如文件重组、新增文件），说明原因
- 后续优化建议（如有）

### 8. 示例：信息收集章节优化
以 `02 Sec/01 InformationCollection/` 章节为例：
- 现有笔记：`01 业务资产.md`、`02 Web应用.md`、`03 主机服务器.md`、`04 APP应用.md`、`05 小程序应用.md`、`06 微信公众号.md`、`07 其他产品.md`、`08 工具项目.md`
- 优化过程：
  1. 保留每篇笔记的核心要点和结构
  2. 为 `01 业务资产.md` 补充企业信息查询平台使用示例、资产分类表格、实战案例
  3. 为 `02 Web应用.md` 添加指纹识别具体命令、子域名枚举操作步骤
  4. 从所有笔记中提取工具（FOFA、Wappalyzer、OneForAll、nmap等）
  5. 在 `08 工具项目.md` 中为每个工具创建分步教程、案例研究和最佳实践
- 结果：章节内容更完整、结构化更好、实践指导性更强，同时保持用户原始技术框架

## Important Notes

- **Do not commit sensitive information** – `.gitignore` excludes files like `.env`, `*.key`, `*.pem`, and `secrets.*`.
- **Claude Code memory** is stored in `.claude/` and ignored by Git.
- **Sync frequency** – The user prefers that Claude runs the sync scripts when they ask to update notes, rather than them running the scripts themselves.
- **User identity** – Git is configured as `luodapao <luodapaohhh@outlook.com>`.

## Git Operations Policy

**CRITICAL: Authorization Required for All Git Operations**

1. **Sync Operations**:
   - **NEVER** run sync scripts (sync.ps1, sync.sh, sync.bat) unless the user explicitly asks you to "sync", "update notes", or "push changes"
   - **NEVER** automatically commit or push changes after editing notes
   - **WAIT** for explicit user instruction before performing any git operations

2. **Exception Cases**:
   - Only perform git operations if the user's request contains clear verbs like:
     - "同步笔记" (sync notes)
     - "更新到GitHub" (update to GitHub)  
     - "提交更改" (commit changes)
     - "推送" (push)
   - If uncertain, ASK the user before proceeding

3. **Editing vs. Syncing**:
   - Editing/optimizing notes ≠ automatic syncing
   - Complete the editing task first, then wait for sync instruction
   - The user may want to review changes before committing

**Violation Example**: After optimizing notes, DO NOT run `git add`, `git commit`, or `git push` unless explicitly instructed.

## Reference

- `SYNC_GUIDE.md` – Detailed synchronization setup guide.
- `README.md` – High‑level project description.
- `.gitignore` – List of ignored files and directories.