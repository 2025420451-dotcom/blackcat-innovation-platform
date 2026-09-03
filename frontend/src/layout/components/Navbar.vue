<template>
  <div class="navbar">
    <hamburger
      id="hamburger-container"
      :is-active="appStore.sidebar.opened"
      class="hamburger-container"
      @toggleClick="toggleSideBar"
    />
    <breadcrumb id="breadcrumb-container" class="breadcrumb-container" />

    <div class="right-menu">
      <el-tooltip content="切换主题" effect="dark" placement="bottom">
        <button class="theme-button" type="button" aria-label="切换主题" @click="toggleTheme">
          <svg-icon :icon-class="settingsStore.isDark ? 'sunny' : 'moon'" />
        </button>
      </el-tooltip>

      <el-dropdown class="user-menu" trigger="hover" @command="handleCommand">
        <div class="user-summary">
          <img :src="userStore.avatar" class="user-avatar" alt="用户头像" />
          <span class="user-nickname">{{ userStore.nickName || userStore.name }}</span>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup>
import { ElMessageBox } from 'element-plus'
import Breadcrumb from '@/components/Breadcrumb'
import Hamburger from '@/components/Hamburger'
import useAppStore from '@/store/modules/app'
import useUserStore from '@/store/modules/user'
import useSettingsStore from '@/store/modules/settings'

const appStore = useAppStore()
const userStore = useUserStore()
const settingsStore = useSettingsStore()

function toggleSideBar() {
  appStore.toggleSideBar()
}

function handleCommand(command) {
  if (command === 'logout') {
    logout()
  }
}

function logout() {
  ElMessageBox.confirm('确定注销并退出系统吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    userStore.logOut().then(() => {
      location.href = '/login'
    })
  }).catch(() => {})
}

async function toggleTheme(event) {
  const x = event?.clientX || window.innerWidth / 2
  const y = event?.clientY || window.innerHeight / 2
  const wasDark = settingsStore.isDark
  const isReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  const isSupported = document.startViewTransition && !isReducedMotion

  if (!isSupported) {
    settingsStore.toggleTheme()
    return
  }

  try {
    const transition = document.startViewTransition(async () => {
      settingsStore.toggleTheme()
      await nextTick()
    })
    await transition.ready
    const endRadius = Math.hypot(Math.max(x, window.innerWidth - x), Math.max(y, window.innerHeight - y))
    const clipPath = [`circle(0px at ${x}px ${y}px)`, `circle(${endRadius}px at ${x}px ${y}px)`]
    document.documentElement.animate(
      { clipPath: wasDark ? [...clipPath].reverse() : clipPath },
      {
        duration: 500,
        easing: 'ease-in-out',
        fill: 'forwards',
        pseudoElement: wasDark ? '::view-transition-old(root)' : '::view-transition-new(root)'
      }
    )
  } catch {
    settingsStore.toggleTheme()
  }
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 50px;
  display: flex;
  align-items: center;
  overflow: hidden;
  background: var(--navbar-bg);
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
}

.hamburger-container {
  height: 100%;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: background 0.2s;
}

.hamburger-container:hover,
.theme-button:hover {
  background: rgba(0, 0, 0, 0.04);
}

.breadcrumb-container {
  flex-shrink: 0;
}

.right-menu {
  height: 100%;
  display: flex;
  align-items: center;
  gap: 4px;
  margin-left: auto;
  padding-right: 16px;
}

.theme-button {
  width: 42px;
  height: 42px;
  border: 0;
  border-radius: 6px;
  background: transparent;
  color: var(--el-text-color-primary);
  font-size: 18px;
  cursor: pointer;
}

.user-summary {
  display: flex;
  align-items: center;
  gap: 8px;
  height: 42px;
  padding: 0 8px;
  border-radius: 6px;
  cursor: pointer;
}

.user-summary:hover {
  background: rgba(0, 0, 0, 0.04);
}

.user-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  object-fit: cover;
}

.user-nickname {
  max-width: 140px;
  overflow: hidden;
  color: var(--el-text-color-primary);
  font-size: 14px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}

@media (max-width: 600px) {
  .breadcrumb-container,
  .user-nickname {
    display: none;
  }
}
</style>
