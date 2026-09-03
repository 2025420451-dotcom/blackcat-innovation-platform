<template>
  <div class="starter-home">
    <section class="welcome-panel">
      <div>
        <el-tag effect="dark" round>开发工作台</el-tag>
        <p class="eyebrow">你好，{{ displayName }}</p>
        <h1>欢迎进入管理系统</h1>
        <p class="description">
          登录认证、用户信息加载、基础布局和异常页面已经就绪，可以从这里开始添加你的业务页面。
        </p>
      </div>
      <div class="status-badge" aria-label="系统状态正常">
        <span class="status-dot"></span>
        基础框架运行正常
      </div>
    </section>

    <el-row :gutter="20" class="info-grid">
      <el-col :xs="24" :md="12">
        <el-card shadow="never" class="info-card">
          <template #header>
            <div class="card-title">
              <el-icon><CircleCheckFilled /></el-icon>
              当前保留能力
            </div>
          </template>
          <ul class="feature-list">
            <li>账号密码与验证码登录</li>
            <li>JWT Token 和请求鉴权</li>
            <li>用户身份与权限信息加载</li>
            <li>响应式后台布局与明暗主题</li>
          </ul>
        </el-card>
      </el-col>

      <el-col :xs="24" :md="12">
        <el-card shadow="never" class="info-card">
          <template #header>
            <div class="card-title">
              <el-icon><Position /></el-icon>
              下一步开发
            </div>
          </template>
          <ol class="feature-list ordered">
            <li>在 <code>src/views</code> 中创建业务页面</li>
            <li>在 <code>src/router/index.js</code> 中添加路由</li>
            <li>在 <code>src/api</code> 中封装对应接口</li>
            <li>根据业务需要补充权限标识</li>
          </ol>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
import useUserStore from '@/store/modules/user'

const userStore = useUserStore()
const displayName = computed(() => userStore.nickName || userStore.name || '用户')
</script>

<style scoped lang="scss">
.starter-home {
  min-height: 100%;
  padding: 28px;
  background:
    radial-gradient(circle at 90% 0, rgba(64, 158, 255, 0.12), transparent 32%),
    var(--el-bg-color-page);
}

.welcome-panel {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  padding: 38px 40px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 16px;
  background: var(--el-bg-color-overlay);
  box-shadow: 0 12px 36px rgba(31, 45, 61, 0.06);
}

.eyebrow {
  margin: 22px 0 6px;
  color: var(--el-color-primary);
  font-size: 14px;
  font-weight: 600;
}

h1 {
  margin: 0;
  color: var(--el-text-color-primary);
  font-size: clamp(28px, 4vw, 42px);
  line-height: 1.2;
}

.description {
  max-width: 680px;
  margin: 16px 0 0;
  color: var(--el-text-color-regular);
  font-size: 16px;
  line-height: 1.8;
}

.status-badge {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 9px;
  padding: 10px 14px;
  border-radius: 999px;
  background: var(--el-color-success-light-9);
  color: var(--el-color-success-dark-2);
  font-size: 13px;
  font-weight: 600;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--el-color-success);
  box-shadow: 0 0 0 4px var(--el-color-success-light-7);
}

.info-grid {
  margin-top: 20px;
}

.info-card {
  height: 100%;
  border-radius: 14px;
}

.card-title {
  display: flex;
  align-items: center;
  gap: 9px;
  color: var(--el-text-color-primary);
  font-size: 16px;
  font-weight: 650;
}

.card-title .el-icon {
  color: var(--el-color-primary);
  font-size: 20px;
}

.feature-list {
  display: grid;
  gap: 14px;
  margin: 0;
  padding-left: 20px;
  color: var(--el-text-color-regular);
  line-height: 1.6;
}

.feature-list li::marker {
  color: var(--el-color-primary);
}

code {
  padding: 2px 6px;
  border-radius: 4px;
  background: var(--el-fill-color-light);
  color: var(--el-color-primary);
}

@media (max-width: 767px) {
  .starter-home {
    padding: 16px;
  }

  .welcome-panel {
    align-items: flex-start;
    flex-direction: column;
    padding: 26px 22px;
  }

  .info-grid .el-col + .el-col {
    margin-top: 16px;
  }
}
</style>
