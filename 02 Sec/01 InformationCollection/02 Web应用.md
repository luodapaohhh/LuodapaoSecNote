# Web应用信息收集

Web应用信息收集是渗透测试和网络安全评估中的关键步骤，目的是全面了解目标Web应用的技术栈、资产范围、潜在攻击面和安全防护措施。本章节系统性地梳理了Web应用信息收集的各个方面，包括技术架构识别、域名资产枚举、源码获取方法、前端架构分析、安全设备识别以及框架组件探测。

## 1. 技术架构识别

识别目标Web应用所使用的技术栈是信息收集的第一步，有助于后续针对性地进行漏洞扫描和利用。

### 1.1 技术分类
Web应用技术栈通常包括以下几个层面：
- **程序语言**：PHP、Java、Python、.NET、Node.js等
- **框架源码**：Spring Boot、Laravel、Django、Flask、ThinkPHP等
- **搭建平台**：WordPress、Joomla、Drupal、Discuz!等CMS系统
- **数据库类**：MySQL、PostgreSQL、MongoDB、Redis等
- **操作系统**：Linux（CentOS、Ubuntu）、Windows Server等

### 1.2 指纹识别技术
指纹识别是通过分析Web应用的响应特征（如HTTP头部、HTML内容、文件路径、错误信息等）来确定其使用的具体技术。

**常用指纹识别工具：**
- **Wappalyzer**：浏览器扩展，可自动识别网站使用的技术栈
- **潮汐**：企业级网络空间测绘平台
- **云悉**：在线Web应用指纹识别平台
- **cmsseek/cmsmap**：专门用于CMS指纹识别和漏洞扫描的工具

**实际操作示例：**
```bash
# 使用Wappalyzer浏览器扩展
1. 在Chrome/Firefox中安装Wappalyzer扩展
2. 访问目标网站，点击扩展图标即可查看检测到的技术栈

# 使用cmsmap扫描WordPress站点
git clone https://github.com/Dionach/CMSmap.git
cd CMSmap
python3 cmsmap.py -t https://target.com -f W
```

## 2. 域名资产枚举

域名是Web应用的入口点，全面枚举目标域名及其子域名是扩大攻击面的关键。

### 2.1 单域名信息收集
针对单个目标域名，可以收集以下信息：
- **备案信息**：通过工信部备案系统查询网站主办者、备案号等
- **企业产权**：利用企查查、天眼查等平台查询关联企业信息
- **注册域名**：通过WHOIS查询域名注册人、注册商、注册日期等
- **反查解析**：通过IP反查域名，发现同一服务器上的其他网站

### 2.2 子域名枚举技术
子域名枚举是发现目标组织更多资产的有效方法，常用技术包括：
- **DNS数据**：利用DNS记录（A、CNAME、MX等）发现子域名
- **证书查询**：通过证书透明度日志（Certificate Transparency）发现域名
- **网络空间**：使用网络空间搜索引擎检索关联资产
- **威胁情报**：从威胁情报平台获取历史子域名数据
- **枚举解析**：使用字典爆破或智能生成子域名

### 2.3 常用平台与工具
- **DNS数据**：DNSdumpster、SecurityTrails
- **证书查询**：crt.sh、Certificate Search
- **网络空间**：FOFA、鹰图、360Quake、Shodan
- **威胁情报**：微步在线、VirusTotal、AlienVault OTX
- **枚举解析**：OneForAll、subfinder、amass、dnsgrep

**实际操作示例：**
```bash
# 使用OneForAll进行子域名枚举
git clone https://github.com/shmilylty/OneForAll.git
cd OneForAll
python3 oneforall.py --target example.com run

# 使用crt.sh证书查询
curl -s "https://crt.sh/?q=%.example.com&output=json" | jq -r '.[].name_value' | sort -u
```

## 3. 源码获取方法

获取Web应用源码有助于进行白盒审计，发现逻辑漏洞和配置错误。

### 3.1 开源CMS获取
- **利用指纹识别找到CMS**：通过指纹识别确定CMS类型和版本
- **官方下载**：从官方网站下载对应版本源码进行比对分析

### 3.2 闭源应用源码泄露
闭源应用可能通过以下途径泄露源码：
- **版本控制泄露**：
  - `.git`目录泄露：可通过`/.git/`访问版本控制历史
  - `.svn`目录泄露：Subversion版本控制信息泄露
  - `.DS_Store`文件泄露：macOS目录元数据泄露
- **压缩备份文件**：`www.zip`、`bak.tar.gz`、`www.rar`等备份文件
- **依赖管理文件**：`composer.json`、`package.json`等可能包含敏感信息

### 3.3 代码托管平台搜索
在代码托管平台搜索目标相关代码：
- **平台**：GitHub、Gitee、GitLab、OSChina
- **信息搜索关键词**：
  - QQ号、手机号、邮箱地址
  - 作者名、公司名
  - 注释中的关键信息（API密钥、数据库配置等）
- **特征关键文件**：
  - JS文件名（如`app.js`、`main.js`）
  - 脚本文件名（如`config.php`、`database.py`）

### 3.4 行业特定源码获取
- **黑产行业**：互站网、各类源码交易论坛
- **注意事项**：下载的源码可能包含后门，需在隔离环境分析

**实际操作示例：**
```bash
# 检测.git目录泄露
curl -s https://target.com/.git/HEAD
# 如果返回"ref: refs/heads/master"则存在泄露

# 使用GitHack工具恢复源码
git clone https://github.com/lijiejie/GitHack.git
cd GitHack
python GitHack.py http://target.com/.git/
```

## 4. JS前端架构分析

现代Web应用大量使用JavaScript，前端代码分析成为信息收集的重要环节。

### 4.1 前后端技术差异
- **后端语言**：PHP、Java、Python、.NET等，浏览器端看不到真实源代码
- **前端语言**：JavaScript及其框架（Vue、React、Angular），浏览器端可查看真实源代码

### 4.2 前端框架识别方法
- **浏览器插件**：Wappalyzer可识别前端框架
- **代码特征**：
  - 源程序代码简短，主要逻辑通过引入的JS文件实现
  - 引入多个JS文件（如`vue.js`、`react.production.min.js`）
  - 常见路径模式：`/static/app.js`、`/assets/main.js`
  - Cookie中常见`connect.sid`（Express会话标识）
- **常见框架**：Vue.js、React、Angular、jQuery、Node.js

### 4.3 前端安全风险
- **源码泄露**：JS文件未压缩或包含敏感注释
- **未授权访问**：通过JS文件分析API接口路径，发现未受保护的端点
- **敏感Key泄漏**：JS文件中可能硬编码API密钥、云服务配置、数据库连接信息等
- **API接口安全**：分析JS中的加密参数传递逻辑，发现更多URL路径

### 4.4 测试方法
- **人工分析**：使用浏览器开发者工具查看Network和Sources面板
- **自动化工具**：
  - **Burp Suite**：抓包分析JS文件，使用"JS Link Finder"扩展
  - **工具项目**：LinkFinder、JS-Scan、SecretFinder等

**实际操作示例：**
```bash
# 使用LinkFinder提取JS文件中的URL
python3 linkfinder.py -i https://target.com/static/app.js -o cli

# 使用浏览器开发者工具
1. 按F12打开开发者工具
2. 切换到Network面板，刷新页面
3. 过滤".js"文件，逐个查看响应内容
```

## 5. 安全设备识别

识别目标部署的安全设备（WAF、蜜罐、CDN）有助于调整攻击策略，避免触发防护机制。

### 5.1 Web应用防火墙（WAF）
#### 5.1.1 WAF分类
- **云WAF**：阿里云WAF、腾讯云WAF、Cloudflare等
- **硬件WAF**：Imperva、F5 BIG-IP、Fortinet等
- **软件WAF**：ModSecurity、NAXSI等
- **代码级WAF**：应用内置的安全过滤组件

#### 5.1.2 WAF识别方法
- **拦截页面**：触发WAF规则后返回特定拦截页面
- **HTTP头部**：检查`Server`、`X-Powered-By`等头部特征
- **工具识别**：
  - **identYwaf**：WAF指纹识别工具
  - **wafw00f**：流行的WAF检测工具

**实际操作示例：**
```bash
# 使用wafw00f识别WAF
wafw00f https://target.com
```

### 5.2 蜜罐识别
#### 5.2.1 蜜罐分类
- **低交互蜜罐**：模拟有限服务，如Honeyd
- **中交互蜜罐**：提供部分真实服务，如Kippo
- **高交互蜜罐**：完全真实的系统，如Dionaea

#### 5.2.2 蜜罐功能类型
- **Web蜜罐**：Glastopf、Snare
- **工控蜜罐**：Conpot
- **数据库蜜罐**：ElasticPot
- **物联网蜜罐**：IoT-Pot

#### 5.2.3 蜜罐识别方法
- **工具识别**：
  - **Heimdallr**：蜜罐检测工具
  - **quake_rs**：360网络空间测绘的Rust版本
- **人工分析**：
  - 端口开放有规律性（如大量端口同时开放）
  - Web访问立即返回下载或固定响应
  - 设备指纹分析（HTTP头部、SSL证书等）
- **网络空间测绘**：鹰图、Quake等平台标记的蜜罐资产

### 5.3 CDN识别与绕过
#### 5.3.1 CDN识别方法
- **nslookup查询**：多地解析结果不一致可能使用CDN
- **多地Ping测试**：使用不同地区服务器Ping目标，IP不同则有CDN
- **工具检测**：`whatcdn`、`cdncheck`等

#### 5.3.2 CDN绕过技术
- **子域名查询**：很多CDN只保护主域名，子域名可能直连源站
- **国外访问**：CDN可能未覆盖国外节点，直接访问源站
- **历史记录查询**：通过DNS历史记录查找真实IP
- **邮件服务器**：邮件系统通常不经过CDN，通过`nslookup`查询MX记录
- **SSL证书**：通过证书透明度日志查找域名真实IP
- **全网扫描**：扫描目标域名常见端口，寻找非CDN IP
- **第三方接口**：使用`get-site-ip.com`等在线查询服务

**实际操作示例：**
```bash
# 识别CDN
nslookup target.com
# 如果返回多个IP且属于CDN提供商（如Cloudflare），则可能使用CDN

# 查询DNS历史记录
curl -s "https://securitytrails.com/domain/target.com/dns" | grep -A5 '"historical"'
```

## 6. 框架组件识别

识别Web应用使用的具体框架和组件有助于寻找已知漏洞和配置弱点。

### 6.1 常见语言与框架
#### PHP框架
- **YII**：高性能PHP框架，默认路由包含`?r=`
- **Laravel**：优雅的PHP框架，错误页面有明显特征
- **ThinkPHP**：国内流行PHP框架，默认路径包含`index.php`

#### Java框架
- **Log4j**：日志组件，CVE-2021-44284影响广泛
- **Shiro**：安全框架，默认Cookie`rememberMe`
- **Solr**：搜索平台，默认管理界面`/solr/admin`
- **Spring Boot**：微服务框架，默认错误页面`Whitelabel Error Page`
- **Struts2**：MVC框架，多个远程代码执行漏洞
- **Fastjson**：JSON解析库，反序列化漏洞

#### Python框架
- **Flask**：轻量级框架，默认调试模式风险
- **Django**：全能型框架，默认管理界面`/admin`

### 6.2 框架识别特征
- **Response返回包**：特定HTTP头部（如`X-Powered-By: PHP/7.4`）
- **固定端口开放**：Spring Boot默认8080，Django开发服务器8000
- **ICO图标**：框架默认favicon.ico可被识别
- **特有URL路径**：`/phpinfo.php`、`/wp-admin/`、`/manager/html`

### 6.3 识别技术
- **端口扫描**：`nmap -sV -p 80,443,8080,8000 target.com`
- **网络空间搜索**：FOFA搜索`app="Spring Boot"`
- **识别插件**：Wappalyzer、WhatWeb等

**实际操作示例：**
```bash
# 使用WhatWeb识别框架
whatweb https://target.com

# 使用nmap扫描框架特征端口
nmap -sV --script=http-enum -p 80,443,8080,8000 target.com
```

## 总结

Web应用信息收集是一个多层次、系统化的过程。从技术栈识别到资产枚举，从源码分析到安全设备探测，每个环节都为后续渗透测试提供重要情报。实际工作中应根据目标情况灵活组合各种技术和方法，在合法授权的范围内进行全面、深入的信息收集。

**最佳实践建议：**
1. **合法性优先**：确保所有信息收集活动都在授权范围内进行
2. **多源验证**：交叉验证不同工具和平台的结果，避免误报
3. **持续更新**：关注新工具、新技术，保持信息收集能力与时俱进
4. **记录完整**：详细记录收集过程和数据，便于后续分析和报告撰写