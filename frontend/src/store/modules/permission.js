import { constantRoutes } from '@/router'

const usePermissionStore = defineStore(
  'permission',
  {
    state: () => ({
      routes: [],
      addRoutes: [],
      sidebarRouters: constantRoutes
    }),
    actions: {
      setRoutes(routes) {
        this.addRoutes = routes
        this.routes = constantRoutes.concat(routes)
      },
      setSidebarRouters(routes) {
        this.sidebarRouters = routes
      },
      generateRoutes() {
        this.setRoutes([])
        this.setSidebarRouters(constantRoutes)
        return Promise.resolve([])
      }
    }
  })

export default usePermissionStore
