#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "错误：未找到 Docker，请先安装 Docker。" >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "错误：Docker 未运行，或当前用户没有访问 Docker 的权限。" >&2
  echo "请启动 Docker，或使用有 Docker 权限的用户重新执行。" >&2
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  compose=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  compose=(docker-compose)
else
  echo "错误：未找到 docker compose 插件或 docker-compose。" >&2
  exit 1
fi

random_hex() {
  od -An -N "$1" -tx1 /dev/urandom | tr -d ' \n'
}

if [[ ! -f .env ]]; then
  umask 077
  cat > .env <<EOF
COMPOSE_PROJECT_NAME=ruoyi
APP_PORT=80
TZ=Asia/Shanghai
MYSQL_DATABASE=ry-vue
MYSQL_USER=ruoyi
MYSQL_PASSWORD=$(random_hex 24)
MYSQL_ROOT_PASSWORD=$(random_hex 24)
REDIS_PASSWORD=$(random_hex 24)
TOKEN_SECRET=$(random_hex 64)
JAVA_XMS=256m
JAVA_XMX=512m
RUOYI_LOG_LEVEL=info
NPM_REGISTRY=https://registry.npmjs.org
EOF
  echo "已生成 .env（含随机数据库、Redis 和 Token 密钥）。"
else
  echo "检测到已有 .env，将沿用现有配置。"
fi

"${compose[@]}" config --quiet
"${compose[@]}" up -d --build --remove-orphans
"${compose[@]}" ps

app_port=$(sed -n 's/^APP_PORT=//p' .env | tail -n 1)
app_port=${app_port:-80}

echo
echo "部署命令已完成。"
echo "访问地址：http://服务器IP:${app_port}"
echo "查看日志：${compose[*]} logs -f --tail=200"

