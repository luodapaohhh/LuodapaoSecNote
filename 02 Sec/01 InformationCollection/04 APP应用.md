# APP应用信息收集

## 获取APP
移动应用（APP）是网络安全评估中的重要资产，通常包含与Web应用类似甚至更丰富的敏感信息。获取目标APP的安装包是信息收集的第一步，主要有两种途径：

### 从URL获取APP
当已知目标单位的官方网站或相关域名时，可以通过以下方法查找对应的APP：

1. **查询备案信息搜索**：
   - 使用工信部备案查询系统（https://beian.miit.gov.cn）或第三方备案查询平台，通过域名反查主办单位信息
   - 根据主办单位名称在各大应用市场搜索其发布的官方APP
   - 示例：查询`example.com`备案信息→发现主办单位为"XX科技有限公司"→在应用宝、华为应用市场搜索"XX科技"

2. **网站直接下载**：
   - 许多企业会在官方网站提供APP下载链接，常见位置包括：
     - 首页底部"移动端"、"APP下载"栏目
     - 产品介绍页面内的下载链接
     - 移动端适配页面自动跳转的下载提示
   - 使用浏览器开发者工具（F12）检查网页源码，搜索`.apk`、`.ipa`、`download`、`app`等关键词
   - 示例：访问`https://www.example.com/app`或`https://www.example.com/mobile`

3. **应用市场直接搜索**：
   - 在主流应用市场（应用宝、华为应用市场、小米应用商店、苹果App Store等）使用单位名称、品牌名、产品名进行搜索
   - 注意识别官方应用：查看开发者名称、应用详情中的公司信息、下载量、用户评价
   - 可通过`app.mi.com`、`sj.qq.com`等应用市场网页版进行批量搜索

### 从名称获取APP
当仅有单位名称而无具体域名时，可通过企业信息查询平台获取线索：

1. **爱企查/天眼查等企业信息平台**：
   - 输入单位名称，查询其工商注册信息、关联公司、分支机构
   - 关注"软件著作权"、"APP备案"等信息栏目
   - 从企业对外投资、子公司信息中挖掘更多关联APP
   - 示例：在爱企查搜索"XX集团"，发现其子公司"XX科技"拥有多款金融类APP著作权

2. **七麦数据/点点查等应用分析平台**：
   - 专业应用市场数据分析平台，支持按开发者名称、公司主体查询
   - 可获取应用上下架历史、版本更新记录、市场排名等深度信息
   - 提供应用ID（Bundle ID/Package Name），便于后续技术分析
   - 示例：在七麦数据（qimai.cn）搜索公司名称，获取其所有已上架应用的详细数据

**注意事项**：
- 优先获取官方正版应用，避免分析被篡改或包含恶意代码的版本
- 对于iOS应用，需要越狱设备或使用企业证书签名的IPA包进行分析
- 记录获取的APP版本号、包名（Package Name/Bundle ID）、数字签名等信息，便于后续跟踪
## 信息分类

从APP中提取的信息可分为三大类：资产信息、泄露信息和代码信息。这些信息构成了APP安全评估的基础。

### 资产信息

资产信息指APP运行所依赖的基础设施和对外服务接口，是攻击面分析的核心。

#### 1. IP地址与端口
- **提取内容**：服务器IP地址、CDN节点、第三方服务IP、数据库连接地址
- **分析方法**：
  - 静态分析：反编译APP，搜索IP地址正则表达式（如`\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}`）
  - 动态分析：监控APP网络请求，捕获实际通信的IP地址
- **安全测试**：
  - 端口扫描：使用`nmap`对发现的IP进行全端口扫描
  - 服务识别：识别开放的HTTP/HTTPS、数据库、消息队列等服务
  - 示例命令：
    ```bash
    # 对目标IP进行端口扫描
    nmap -sS -p 1-65535 -T4 192.168.1.100
    # 识别HTTP服务详细信息
    nmap -sV --script=http-title 192.168.1.100 -p 80,443,8080
    ```

#### 2. 域名与Web服务
- **提取内容**：API域名、静态资源域名、第三方服务域名、子域名
- **分析方法**：
  - 字符串搜索：在反编译代码中搜索`http://`、`https://`、`.com`、`.cn`等模式
  - HTTPS证书解析：从APP中提取预置证书或信任的CA列表
- **安全测试**：
  - Web漏洞扫描：对发现的Web服务进行OWASP Top 10漏洞检测
  - 子域名枚举：使用工具如`subfinder`、`amass`扩展攻击面
  - 示例命令：
    ```bash
    # 使用subfinder枚举子域名
    subfinder -d example.com -o subdomains.txt
    # 使用nuclei进行Web漏洞扫描
    nuclei -u https://api.example.com -t ~/nuclei-templates/
    ```

#### 3. 接口与API
- **提取内容**：API端点URL、请求方法（GET/POST/PUT/DELETE）、参数格式、认证机制
- **分析方法**：
  - 网络抓包：使用Burp Suite、Fiddler拦截APP通信
  - 代码分析：查找网络请求相关的代码段（Android：`OkHttp`、`Retrofit`；iOS：`NSURLSession`、`Alamofire`）
- **安全测试**：
  - API安全测试：检查认证绕过、参数注入、越权访问等漏洞
  - 接口模糊测试：使用`ffuf`、`wfuzz`进行参数爆破
  - 示例流程：
    1. 配置代理（Burp Suite监听端口）
    2. 设置设备代理指向Burp
    3. 操作APP触发API调用
    4. 在Burp中分析捕获的请求

### 泄露信息

泄露信息指APP中硬编码或不当存储的敏感配置信息，可能直接导致系统沦陷。

#### 1. 邮箱配置
- **常见泄露**：SMTP服务器地址、端口、用户名、密码（或API密钥）
- **提取方法**：搜索`smtp`、`mail`、`email`、`username`、`password`等关键词
- **风险影响**：攻击者可利用泄露的邮箱凭证发送钓鱼邮件、窃取敏感邮件

#### 2. OSS对象存储配置
- **常见泄露**：阿里云OSS、腾讯云COS、AWS S3的AccessKey/SecretKey、Bucket名称
- **提取方法**：搜索`oss`、`s3`、`bucket`、`accesskey`、`secret`等关键词
- **风险影响**：直接访问存储桶，下载敏感文件或上传恶意文件
- **验证命令**：
  ```bash
  # 使用AWS CLI测试S3访问权限
  AWS_ACCESS_KEY_ID=AKIA... AWS_SECRET_ACCESS_KEY=... aws s3 ls s3://bucket-name/
  ```

#### 3. 接口配置与密钥
- **常见泄露**：第三方服务API密钥（地图、支付、推送、短信等）、数据库连接字符串、加密密钥
- **提取方法**：
  - 硬编码搜索：查找`api_key`、`secret`、`token`、`password`等字符串
  - 配置文件分析：解析`strings.xml`、`Info.plist`、`config.json`等文件
- **风险影响**：未授权访问第三方服务、数据泄露、服务滥用

### 代码信息

代码信息指从APP二进制文件中恢复的源代码逻辑、业务规则和安全机制。

- **业务逻辑分析**：理解核心功能流程、数据处理规则、权限控制模型
- **安全机制识别**：加密算法实现、证书固定（Certificate Pinning）、反调试保护、代码混淆
- **漏洞挖掘**：通过代码审计发现逻辑漏洞、输入验证缺陷、不安全的数据存储
- **提取技术**：反编译（Android：`jadx`、`apktool`；iOS：`hopper`、`IDA Pro`）、字符串提取（`strings`命令）
## 提取技术

APP信息提取主要采用三种技术：逆向静态提取、动态抓包提取和动态调试提取。实际测试中通常组合使用这些技术，以获得最全面的信息。

### 逆向静态提取

逆向静态提取指在不运行APP的情况下，直接分析其二进制文件、资源和配置文件。

#### 适用场景
- 快速提取硬编码的敏感信息（API密钥、IP地址、密码等）
- 分析APP整体架构和依赖关系
- 初步了解业务逻辑和安全机制

#### 常用工具
- **Android**：
  - `apktool`：反编译APK文件，提取资源文件和smali代码
  - `jadx`：将APK/DEX文件转换为可读的Java代码
  - `dex2jar` + `jd-gui`：传统反编译工具链
  - `strings`：提取二进制文件中的可读字符串
- **iOS**：
  - `otool`：分析Mach-O文件格式和依赖库
  - `class-dump`：导出Objective-C头文件
  - `hopper`/`IDA Pro`：交互式反汇编和反编译
  - `Frida`：动态插桩（虽为动态工具，但可用于静态分析辅助）

#### 操作流程
```bash
# Android APK静态分析示例
# 1. 使用apktool解包APK
apktool d target_app.apk -o output_dir

# 2. 使用jadx反编译为Java代码
jadx --show-bad-code target_app.apk -d jadx_output

# 3. 提取所有字符串
strings target_app.apk > strings.txt

# 4. 搜索敏感信息
grep -r "api_key\|password\|secret\|token" output_dir/
grep -r "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" output_dir/

# iOS IPA分析示例
# 1. 解压IPA文件（实为zip格式）
unzip app.ipa -d ipa_output

# 2. 查找主二进制文件（通常位于Payload/*.app/）
find ipa_output -name "*.app" -type d

# 3. 使用otool分析依赖
otool -L Payload/AppName.app/AppName

# 4. 使用strings提取字符串
strings Payload/AppName.app/AppName > ios_strings.txt
```

#### 输出分析
- **字符串文件**：包含硬编码的URL、密钥、调试信息、错误消息
- **反编译代码**：揭示业务逻辑、网络请求模式、加密算法
- **资源文件**：图片、布局文件、配置文件可能包含敏感信息

### 动态抓包提取

动态抓包提取通过在APP运行时拦截网络通信，获取实际的API调用和数据传输。

#### 适用场景
- 分析加密通信的实际内容
- 捕获用户交互触发的API请求
- 验证静态分析发现的端点是否真实使用

#### 常用工具
- **代理工具**：Burp Suite、Charles、Fiddler、mitmproxy
- **流量监控**：Wireshark、tcpdump
- **移动端配置**：Postern（Android代理工具）、Shadowrocket（iOS）

#### 操作流程
1. **配置代理环境**：
   - 在测试电脑上启动代理工具（如Burp Suite，监听`0.0.0.0:8080`）
   - 确保手机与电脑在同一网络，设置手机Wi-Fi代理指向电脑IP:端口
   - 在手机上安装代理工具的CA证书（用于解密HTTPS流量）

2. **绕过证书固定（Certificate Pinning）**：
   - 部分APP会验证服务器证书，阻止代理拦截
   - 解决方法：
     - 使用Frida脚本hook证书验证函数
     - 修改APP源码或smali代码，移除证书固定逻辑
     - 使用`objection`工具自动绕过：`objection -g com.app.name android sslpinning disable`

3. **拦截与分析**：
   - 正常使用APP，触发各种功能
   - 在代理工具中查看所有HTTP/HTTPS请求和响应
   - 重点关注：登录认证、数据查询、文件上传、支付等敏感操作

4. **数据提取**：
   - 导出所有请求为Har文件或文本格式
   - 使用脚本自动化提取端点URL、参数、响应结构

#### 高级技巧
- **被动扫描**：使用Burp Suite的被动扫描功能自动识别漏洞
- **重放攻击**：修改请求参数重放，测试业务逻辑漏洞
- **暴力破解**：对发现登录接口进行账号密码枚举

### 动态调试提取

动态调试提取通过调试器控制APP执行流程，实时查看和修改内存数据。

#### 适用场景
- 分析加密/解密算法的具体实现
- 绕过运行时保护机制（反调试、代码混淆）
- 修改APP行为进行深度测试

#### 常用工具
- **Android**：Android Studio + LLDB、Frida、Xposed
- **iOS**：LLDB、Frida、Cycript（已弃用）、debugserver

#### 操作流程
1. **准备调试环境**：
   - Android：启用开发者选项、USB调试，APP需为debuggable版本
   - iOS：需要越狱设备或开发者证书签名的APP

2. **附加调试器**：
   ```bash
   # 使用Frida附加到运行中的APP
   frida -U -f com.app.name --no-pause
   
   # 在Frida交互环境中执行脚本
   %resume
   ```

3. **hook关键函数**：
   ```javascript
   // Frida脚本示例：hook加密函数
   Java.perform(function() {
     var CryptoClass = Java.use("com.app.security.CryptoUtils");
     CryptoClass.encrypt.implementation = function(data) {
       console.log("加密输入: " + data);
       var result = this.encrypt(data);
       console.log("加密输出: " + result);
       return result;
     };
   });
   ```

4. **内存数据分析**：
   - 使用调试器查看堆栈变量、寄存器值
   - 搜索内存中的敏感字符串
   - 修改内存值改变程序行为

#### 注意事项
- 动态调试可能触发APP的反调试保护，导致崩溃或异常行为
- 需要一定的逆向工程知识，理解ARM/x86汇编指令
- 对于加固的APP，可能需要先脱壳再调试
## 项目平台

以下工具平台可自动化或半自动化地执行APP信息收集任务，提高测试效率。

### AppinfoScaner

AppinfoScaner是一款专注于Android应用信息收集的自动化工具，能够快速提取APK中的敏感信息。

#### 主要功能
- **基本信息提取**：包名、版本号、签名信息、权限列表
- **敏感信息扫描**：硬编码的URL、IP地址、邮箱、API密钥、密码
- **组件分析**：导出Activity、Service、Broadcast Receiver、Content Provider信息
- **漏洞检测**：检测常见的配置漏洞，如Debug模式开启、备份允许等

#### 安装与使用
```bash
# 从GitHub克隆项目
git clone https://github.com/kelvinBen/AppInfoScanner.git
cd AppInfoScanner

# 安装依赖
pip3 install -r requirements.txt

# 基本使用
python3 app.py android -i <apk_path> [-o <output_dir>]

# 示例：扫描APK文件
python3 app.py android -i target.apk -o ./scan_result

# 高级选项
python3 app.py android -i target.apk --threads 10 --level 3
```

#### 输出分析
- **report.html**：HTML格式的详细报告，包含分类的敏感信息
- **敏感信息列表**：按类别（URL、IP、邮箱等）展示发现的内容
- **组件导出**：可导出的组件列表，用于后续手动测试

#### 最佳实践
1. **结合手动验证**：工具输出的敏感信息需手动验证是否真实有效
2. **关注高风险发现**：优先处理数据库连接字符串、云服务密钥等可直接利用的信息
3. **版本对比**：对同一APP的不同版本进行扫描，分析信息泄露的变化趋势

### MobSF (Mobile Security Framework)

MobSF是一款集静态和动态分析于一体的移动应用安全测试框架，支持Android、iOS和Windows移动应用。

#### 主要功能
- **静态分析**：反编译、代码审计、权限分析、恶意行为检测
- **动态分析**：实时设备交互、API监控、文件系统监控、网络流量分析
- **Web API接口**：提供REST API便于集成到CI/CD流程
- **报告生成**：PDF、JSON等多种格式的详细安全报告

#### 安装与部署
```bash
# 使用Docker快速部署（推荐）
docker pull opensecurity/mobile-security-framework-mobsf
docker run -it -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest

# 或从源码安装
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF
./setup.sh  # Linux/macOS
# Windows请使用Docker或WSL
```

#### 使用流程
1. **启动服务**：访问`http://localhost:8000`打开Web界面
2. **上传应用**：拖放APK/IPA文件到上传区域
3. **静态分析**：自动执行反编译、组件分析、代码检查
4. **动态分析**（需连接真实设备或模拟器）：
   - 配置MobSF代理
   - 安装应用并自动执行基本测试用例
   - 监控运行时行为
5. **查看报告**：综合分析结果，包含漏洞详情、风险等级、修复建议

#### 特色功能
- **恶意软件检测**：集成VirusTotal等引擎进行恶意代码扫描
- **密码破解**：尝试破解APK使用的加密密钥
- **Frida集成**：支持自定义Frida脚本进行深度hook
- **CI/CD集成**：可通过API与Jenkins、GitLab等工具集成

#### 实战案例：使用MobSF分析金融APP
1. **上传目标APK**：某银行手机银行APP
2. **静态分析发现**：
   - 硬编码测试服务器地址和凭证
   - 关闭了证书固定（可进行中间人攻击）
   - 日志函数可能泄露敏感信息
3. **动态分析发现**：
   - 登录请求未使用二次验证
   - 交易记录接口存在IDOR漏洞
4. **报告输出**：生成包含详细POC和修复建议的安全报告

### 其他辅助工具

#### 1. QARK (Quick Android Review Kit)
- LinkedIn开源的Android应用静态分析工具
- 专注于安全漏洞检测，输出详细修复指南
- 安装：`pip install qark`

#### 2. AndroBugs
- Android应用漏洞扫描器，检测OWASP Mobile Top 10漏洞
- 支持批量扫描，输出JSON格式报告
- 项目地址：https://github.com/AndroBugs/AndroBugs_Framework

#### 3. Drozer
- 综合Android安全测试框架，支持远程漏洞利用
- 需要安装Agent到测试设备，通过控制台交互
- 官网：https://labs.withsecure.com/tools/drozer

#### 4. Frida
- 动态插桩框架，非专门移动应用工具但在移动安全测试中不可或缺
- 支持JavaScript脚本hook任意函数，修改运行时行为
- 学习资源：https://frida.re/docs/examples/android/

### 工具选择建议

| 测试场景 | 推荐工具 | 理由 |
|---------|---------|------|
| 快速信息提取 | AppinfoScaner | 轻量级，专注敏感信息提取，速度快 |
| 全面安全评估 | MobSF | 功能完整，静态动态结合，报告专业 |
| 漏洞深度挖掘 | Drozer + Frida | 需要手动操作，但可发现复杂漏洞 |
| 自动化流水线 | MobSF API | 提供REST API，便于CI/CD集成 |
| 学习与研究 | 组合使用 | 了解不同工具原理，掌握多种技术 |

### 注意事项
1. **法律合规**：仅测试拥有合法授权或自己开发的应用
2. **环境隔离**：在专用测试环境中进行分析，避免污染生产数据
3. **工具更新**：定期更新工具和漏洞库，确保检测能力
4. **结果验证**：自动化工具可能存在误报，关键发现需手动验证