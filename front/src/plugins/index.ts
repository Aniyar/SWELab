/**
 * plugins/index.ts
 *
 * Automatically included in `./src/main.ts`
 */

// Plugins
import { loadFonts } from './webfontloader'
import vuetify from './vuetify'
import pinia from '../store'
import { createRouter, createWebHistory } from 'vue-router'

import { setupLayouts } from 'virtual:generated-layouts'
import generatedRoutes from 'virtual:generated-pages'

const modifiedRoutes = generatedRoutes.map((route: any) => {
  route.meta = route.meta || {}
  if (route.path === '/') {
    route.meta.layout = 'default'
  } else if (route.path.startsWith('/auth')) {
    route.meta.layout = 'auth'
  } else {
    route.meta.layout = 'blank'
  }
  return route
});

const routes = setupLayouts(modifiedRoutes)

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

// Types
import type { App } from 'vue'

export function registerPlugins (app: App) {
  loadFonts()
  app
    .use(vuetify)
    .use(pinia)
    .use(router)
}
