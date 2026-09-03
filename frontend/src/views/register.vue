<template>
  <div class="register">
    <el-form ref="registerRef" :model="registerForm" :rules="registerRules" class="register-form">
      <h3 class="title">{{ title }}</h3>
      <el-form-item prop="username">
        <el-input
          v-model="registerForm.username"
          type="text"
          size="large"
          autocomplete="off"
          placeholder="账号"
        >
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          v-model="registerForm.password"
          type="password"
          size="large"
          autocomplete="new-password"
          placeholder="密码"
          show-password
        >
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="confirmPassword">
        <el-input
          v-model="registerForm.confirmPassword"
          type="password"
          size="large"
          autocomplete="new-password"
          placeholder="确认密码"
          show-password
          @keyup.enter="handleRegister"
        >
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item v-if="captchaEnabled" prop="code">
        <el-input
          v-model="registerForm.code"
          size="large"
          autocomplete="off"
          placeholder="验证码"
          style="width: 63%"
          @keyup.enter="handleRegister"
        >
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="register-code">
          <img :src="codeUrl" class="register-code-img" alt="验证码" @click="getCode">
        </div>
      </el-form-item>
      <el-form-item class="actions">
        <el-button
          :loading="loading"
          size="large"
          type="primary"
          class="register-button"
          @click.prevent="handleRegister"
        >
          {{ loading ? '注 册 中...' : '注 册' }}
        </el-button>
        <router-link class="login-link" to="/login">使用已有账户登录</router-link>
      </el-form-item>
    </el-form>
    <div class="el-register-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script setup>
import { ElMessageBox } from 'element-plus'
import { getCodeImg, register } from '@/api/login'
import defaultSettings from '@/settings'

const title = import.meta.env.VITE_APP_TITLE
const footerContent = defaultSettings.footerContent
const router = useRouter()
const { proxy } = getCurrentInstance()

const registerForm = ref({
  username: '',
  password: '',
  confirmPassword: '',
  code: '',
  uuid: ''
})

const validateConfirmPassword = (_rule, value, callback) => {
  if (value !== registerForm.value.password) {
    callback(new Error('两次输入的密码不一致'))
    return
  }
  callback()
}

const registerRules = {
  username: [
    { required: true, message: '请输入您的账号', trigger: 'blur' },
    { min: 2, max: 20, message: '账号长度必须介于 2 和 20 个字符之间', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入您的密码', trigger: 'blur' },
    { min: 5, max: 20, message: '密码长度必须介于 5 和 20 个字符之间', trigger: 'blur' },
    { pattern: /^[^<>"'|\\]+$/, message: '密码不能包含非法字符：< > " \' \\ |', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入您的密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  code: [{ required: true, message: '请输入验证码', trigger: 'change' }]
}

const codeUrl = ref('')
const loading = ref(false)
const captchaEnabled = ref(true)

function handleRegister() {
  proxy.$refs.registerRef.validate(valid => {
    if (!valid) return

    loading.value = true
    register(registerForm.value).then(() => {
      const username = registerForm.value.username
      ElMessageBox.alert(`恭喜，账号 ${username} 注册成功！`, '系统提示', {
        type: 'success'
      }).then(() => router.push('/login')).catch(() => router.push('/login'))
    }).catch(() => {
      loading.value = false
      if (captchaEnabled.value) getCode()
    })
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = `data:image/gif;base64,${res.img}`
      registerForm.value.uuid = res.uuid
    } else {
      codeUrl.value = ''
      registerForm.value.code = ''
      registerForm.value.uuid = ''
    }
  })
}

getCode()
</script>

<style lang="scss" scoped>
.register {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url('../assets/images/login-background.jpg');
  background-size: cover;
}

.title {
  margin: 0 auto 30px;
  text-align: center;
  color: #707070;
}

.register-form {
  z-index: 1;
  width: 400px;
  padding: 25px 25px 5px;
  border-radius: 6px;
  background: #fff;

  .el-input {
    height: 40px;

    input {
      height: 40px;
    }
  }

  .input-icon {
    width: 14px;
    height: 39px;
    margin-left: 0;
  }
}

.register-code {
  float: right;
  width: 33%;
  height: 40px;
}

.register-code-img {
  height: 40px;
  padding-left: 12px;
  cursor: pointer;
  vertical-align: middle;
}

.actions {
  width: 100%;
}

.register-button {
  width: 100%;
}

.login-link {
  float: right;
  margin-top: 10px;
}

.el-register-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  height: 40px;
  color: #fff;
  font-family: Arial, sans-serif;
  font-size: 12px;
  line-height: 40px;
  text-align: center;
  letter-spacing: 1px;
}

html.dark .register {
  background-image: linear-gradient(rgba(0, 0, 0, 0.55), rgba(0, 0, 0, 0.55)), url('../assets/images/login-background.jpg');

  .register-form {
    background: var(--el-bg-color-overlay) !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
  }
}
</style>
