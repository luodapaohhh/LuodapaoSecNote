### 前言
- 这是我的docker学习历程，在我学习网络安全的过程中，不可避免地会接触到docker来部署环境，因此，我想在学习的过程中把docker的功能和用法讲清楚，帮助别人使用和自己复习。
- 注：此篇文章着重讲Linux下的Docker的使用
### **Docker介绍**
- 不依赖于任何语言、框架或者包装系统，是一个打包应用及其依赖环境的工具，实现“一次构建，到处运行”
### **Docker核心概念**
- 镜像：像软件的“安装包”或“模板”
- 容器：镜像运行后的实例
- 镜像仓库：存放镜像的地方（Docker Hub是官方仓库）
- Dockerfile：制作镜像的图纸
- DockerCompose：一个或多个的Docker run命令按照特定格式列到一个文件里
### **Docker安装**
- Linux（Ubuntu）：
	- `curl -fsSL https://get.docker.com -o get-docker.sh`
	- `sudo sh get-docker.sh`
### Docker基础命令
- 镜像相关
```
docker pull nginx              # 下载镜像
docker images                  # 查看本地镜像
docker rmi <镜像名>           # 删除镜像
```
- 容器相关
```
docker run -d -p 80:80 nginx    # 运行nginx容器
docker ps                      # 查看运行中的容器
docker ps -a                   # 查看所有容器
docker stop <容器ID>           # 停止容器
docker rm <容器ID>             # 删除容器
docker logs <容器ID>           # 查看容器日志
```
### **Docker工作流程**
#### 01下载镜像
- `docker pull docker.io/library/ngnix:latest`
	- `docker.io`--registry(仓库地址)，此地址为官方地址（可以省略）
	- `library`--namespace（命名空间），此地址为官网仓库（可以省略）
	- `ngnix`--想要下载的镜像名
	- `latest`--tag（标签、版本号），latest或者不写表示最新版本
	- 前三部分加起来代表repository（镜像库），即存放一个镜像的不同版本
- 设置镜像站
	- 有时候在国内（无外网魔法时），可能会因为网络环境问题报错，因此需要设置镜像站
	- `sudo mkdir -p /etc/docker` 创建配置文件（如果有就不需要）
	- `sudo vim /etc/docker/daemon.json` 编辑配置文件
	- 配置多个镜像源配置
	```
	{
	  "registry-mirrors": [
	    "https://hub-mirror.c.163.com",
	    "https://mirror.baidubce.com",
	    "https://docker.mirrors.ustc.edu.cn"
	  ]
	}
	```
	- `sudo systemctl restart docker 或 sudo service docker restart`重启docker服务
	- `sudo systemctl daemon-reload`重启加载配置
#### 02运行容器
- `docker run -d -p 80:80` 
	`-d` --后台运行
	`-p 80:80` --前面为宿主机端口，后面为容器端口 --容器端口和宿主机端口映射
	`-v /website/html:/usr/share/nignx/html` --绑定挂载，前面为宿主机文件目录，后面为容器文件目录
- 挂载卷
	- 绑定挂载
		- `docker run -d -p 80:80 -v /website/html:/usr/share/nignx/html nginx` 
			- `-v /website/html:/usr/share/nignx/html` --前面为宿主机文件目录，后面为容器文件目录，宿主机会覆盖容器文件目录
	- 命名卷挂载
		- `docker volume create nginx_html` --创建一个挂载卷，nginx_html是这个挂载卷的名字
		- `docker -v nginx_html:/usr/share/nignx/html` --前面为卷的名字，后面为容器文件目录，第一次使用会把容器文件夹同步到命名卷里面初始化
		- `docker volume inspect nginx_html`  --查看此挂载卷在宿主机中真实存储目录
		- `docker volume list` --查看所有创建的卷
- docker run 其他参数
	- `-e`  --传递环境变量
	- `--name` --为容器命名（等效id，不能重复）
	- `-it --rm` --让控制台进入容器交互，容器停止时把容器删除掉，可临时调试容器
	- `--restart` --配置容器在停止时的重启策略
		- `always` --容器停止重启
		- `unless-stopped` --容器停止重启（手动停止除外）
	- `--network`  --指定网络模式（子网、桥接、host）
#### 03调试容器
- `docker ps` --查看正在运行的容器
- `docker ps -a` --查看所有的容器
- `docker stop` --停止当前容器
- `docker start` --开启当前容器
- `docker create` --只单纯创建容器
- `docker logs` --docker日志（-f可以滚动查看）
- `docker exec 容器id linux命令` --在容器内部执行Linux命令
- docker exec -it 容器id /bin/sh 交互式进入容器内部执行linux命令

#### 04构造镜像
- 编写Dockerfile
	- `FROM ubuntu:22.04          # 基础镜像`
	- `WORKDIR /app               # 设置工作目录`
	- `COPY . .                   # 复制文件`
	- `RUN apt update && apt install -y python3  # 执行命令`
	- `EXPOSE 8080                # 声明端口`
	- `CMD ["python3", "app.py"]  # 启动命令`
- 执行构建命令
	- `docker build -t myapp:v1 .`
- 推送到Docker Hub
	- `docker login`
	- `docker build -t 自己注册的Docker Hub用户名（命名空间）/myapp:v1 .`
	- `docker push 自己注册的Docker Hub用户名（命名空间）/myapp:v1 .`
#### 05Docker网络
- 桥接模式（默认）
	- `docker network create network1`
	- 同一个子网中，Docker自配一个DNS解析，即只通过容器名字就能相互访问
- host模式
	- 容器直接使用宿主机的IP地址，无需-p指定端口
- none模式
	- 不联网模式
#### 06Docker Compose
- 将一个或者多个Docker run命令打包为一个DockerCompose文件
- 编写DockerCompose文件
	`version: '3.8'`  --版本号
	`services:`                                       --
	  `web:`                                          --对应容器名
	    `image: nginx:alpine`              --对应镜像名
	    `ports: ["80:80"]`                   --对应-p
	    `depends_on:`                            --指定执行启动顺序
	      `- db`                                  
	  `db:`
	    `image: postgres:13`
	    `environment:`                          --对应-e
	      `POSTGRES_PASSWORD: secret`
- 执行构建命令
	- `vi docker-compose.yaml` --构建dockercompose文件
	- `docker compose up -d` --严格执行当前目录下名为docker-compose.yaml下的文件
	- `docker compose up -f dockercompose文件 -d` --识别其他命名规则的DockerCompose文件
- 其他命令
	- `docker compose down` --停止并删除当前容器
	- `docker compose stop`  --只停止
	- `docker compose start` --只开启
	- docker compose up
### **Docker注意事项**

- `docker pull nginx`  和 `docker run nginx`其实可以直接使用`docker run nginx`命令，如果镜像不存在，docker会自动拉取
- 设置非root用户使用Docker
	- `sudo usermod -aG docker $USER`
	- 如果不设置，则每次都需要使用root用户权限（sudo）
- Docker开机自启
	- `sudo systemctl enable docker` --docker自启动
	- `sudo systemctl enable containerd` --docker依赖自启动
### 结语
祝大家天天开心！