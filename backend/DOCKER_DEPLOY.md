# Docker 一键部署说明

本方案会启动 4 个容器：前端 Nginx、Java 后端、MySQL 和 Redis。服务器只需对外开放前端端口，后端、MySQL、Redis 均只在 Docker 内部网络通信。

## 1. 上传目录

上传时必须保留下面的同级目录结构：

```text
若依登录模块/
├── backend/
└── frontend/
```

不要只上传 `backend`，因为前端镜像构建时会读取同级的 `frontend` 目录。

## 2. 一键启动

进入服务器上的后端目录并执行：

```bash
cd backend
bash deploy.sh
```

脚本首次运行会自动创建权限为 `600` 的 `.env`，其中数据库密码、Redis 密码和 Token 密钥均为随机值，然后构建并启动全部容器。默认访问地址：

```text
http://服务器IP
```

若服务器的 80 端口已被占用，可在首次启动前复制并编辑配置：

```bash
cp .env.example .env
vi .env
```

修改 `APP_PORT`，并务必替换示例密码和 `TOKEN_SECRET`，再运行 `bash deploy.sh`。

## 3. 常用命令

```bash
# 查看容器状态
docker compose ps

# 查看全部日志
docker compose logs -f --tail=200

# 只看后端日志
docker compose logs -f --tail=200 backend

# 更新代码后重新构建并启动
bash deploy.sh

# 停止服务（保留数据库和上传文件）
docker compose down
```

数据库、Redis 数据和上传文件分别保存在 Docker 命名卷中，执行普通的 `docker compose down` 不会删除。

## 4. 首次初始化与重置

`sql/ry_20260417.sql` 只会在 MySQL 数据卷为空时自动导入。已经运行过后再修改 SQL，不会自动重复导入。

如确定要完全清空并重新初始化，可执行下面的命令。该操作会永久删除数据库、Redis 数据和上传文件：

```bash
docker compose down -v
bash deploy.sh
```

按当前 SQL 数据，系统初始账号为 `admin`，密码为 `admin123`；首次登录后请立即修改管理员密码。

## 5. 防火墙与域名

- 放行 `APP_PORT` 对应的 TCP 端口（默认 `80`）。
- 不需要放行 `3306`、`6379` 或 `8080`。
- 如需 HTTPS，建议在服务器入口处使用 Nginx、Caddy 或云负载均衡配置证书，再反向代理到 `APP_PORT`。
