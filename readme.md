# 若依登录与主界面精简版

当前工作区使用以下组合：

- `backend`：Spring Boot 3 后端
- `frontend`：Vue 3 前端，也是后续页面开发的唯一前端入口

## 已保留

- 验证码、注册、登录、退出和 JWT Token 鉴权
- 登录用户、角色与权限信息加载
- `ruoyi-common`、`ruoyi-system`、`ruoyi-framework`、`ruoyi-admin`
- 后台主布局、首页、401、404 和重定向页面
- 侧栏、面包屑、明暗主题和响应式布局

用户、角色、菜单等后端基础服务继续保留，用于支撑认证与以后扩展；对应管理页面已经从 Vue 3 前端移除。

## 已移除

- Vue 3 前端的系统管理、系统监控、代码生成、表单构建等业务页面
- 锁屏、个人中心和动态菜单页面入口
- `ruoyi-generator` 与 `ruoyi-quartz` 后端模块及 Quartz 初始化脚本
- 仅由上述页面使用的前端组件和第三方依赖

后端数据库中的原菜单记录无需立刻删除。精简版前端使用本地静态路由，不再请求 `/getRouters`，因此旧菜单不会出现在界面中；权限数据仍可供后续业务接口使用。

## 添加新页面

1. 在 `frontend/src/views` 下创建页面。
2. 在 `frontend/src/router/index.js` 的首页路由后添加对应路由。
3. 在 `frontend/src/api` 下封装业务接口。
4. 如新页面需要按钮级权限，再按业务需要添加权限指令；精简版未保留未使用的 `v-hasPermi`、`v-hasRole` 封装。

如果以后需要恢复后端动态菜单，可从 Git 历史恢复 `src/api/menu.js` 和原来的 `src/store/modules/permission.js`，再为每个菜单准备对应页面。

## 启动

后端依赖 MySQL 和 Redis，先用 `--default-character-set=utf8mb4` 导入 `backend/sql/ry_20260417.sql`，并检查后端数据源配置。初始化 SQL 默认开启注册和验证码。

```bash
cd backend
mvn -DskipTests package
java -jar ./ruoyi-admin/target/ruoyi-admin.jar
```

```bash
cd frontend
npm install
npm run dev
```

前端开发服务器默认将 `/dev-api` 代理到 `http://localhost:8080`。
