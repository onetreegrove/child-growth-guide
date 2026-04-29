import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/pages/HomePage.vue'
import StageListPage from '@/pages/StageListPage.vue'
import StageDetailPage from '@/pages/StageDetailPage.vue'
import CompareHomePage from '@/pages/CompareHomePage.vue'
import CompareDetailPage from '@/pages/CompareDetailPage.vue'
import DimensionDetailPage from '@/pages/DimensionDetailPage.vue'
import DataAboutPage from '@/pages/DataAboutPage.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: HomePage },
    { path: '/stages', name: 'stages', component: StageListPage },
    { path: '/stages/:stageId', name: 'stage-detail', component: StageDetailPage },
    { path: '/compare', name: 'compare', component: CompareHomePage },
    { path: '/compare/:dimensionKey', name: 'compare-detail', component: CompareDetailPage },
    { path: '/dimensions/:dimensionKey', name: 'dimension-detail', component: DimensionDetailPage },
    { path: '/about/data', name: 'about-data', component: DataAboutPage },
  ],
})

export default router
