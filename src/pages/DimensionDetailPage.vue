<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import NoticeBar from '@/components/NoticeBar.vue'
import { formatMetricValue, getCompareTextItems, getDimension, getGrowthMetrics, growthDimensionKeys } from '@/services/growthService'
import { sanitizeMedicalCopy } from '@/services/medicalCopy'
import { useBabyProfileStore } from '@/stores/babyProfile'

const route = useRoute()
const babyStore = useBabyProfileStore()
const dimensionKey = computed(() => String(route.params.dimensionKey))
const dimension = computed(() => getDimension(dimensionKey.value))
const isGrowth = computed(() => (growthDimensionKeys as readonly string[]).includes(dimensionKey.value))
const currentMetric = computed(() => getGrowthMetrics(dimensionKey.value, babyStore.matchedStage.id, 'all').find((metric) => metric.stageId === babyStore.matchedStage.id))
const currentText = computed(() => getCompareTextItems(dimensionKey.value, babyStore.matchedStage.id, 'nearby').find((item) => item.stage.id === babyStore.matchedStage.id))
</script>

<template>
  <main class="page-shell">
    <AppHeader :title="dimension?.dimensionName ?? '维度详情'" back />
    <section class="card">
      <div class="text-sm font-bold text-muted">当前阶段：{{ babyStore.matchedStage.displayName }}</div>
      <template v-if="isGrowth && currentMetric">
        <div class="mt-3 text-2xl font-black text-brand-dark">{{ formatMetricValue(currentMetric, babyStore.profile.gender) }} {{ currentMetric.unit }}</div>
        <p class="mt-2 text-sm leading-relaxed text-muted">{{ sanitizeMedicalCopy(currentMetric.sourceText ?? currentMetric.growthRate) }}</p>
      </template>
      <template v-else-if="currentText">
        <h2 class="mt-3 text-xl font-extrabold">{{ currentText.title }}</h2>
        <p class="mt-2 text-sm leading-relaxed text-muted">{{ sanitizeMedicalCopy(currentText.summary) }}</p>
      </template>
      <RouterLink class="primary-btn mt-4 grid place-items-center" :to="`/compare/${dimensionKey}`">查看跨阶段对比</RouterLink>
    </section>
    <section class="card mt-4">
      <h2 class="text-lg font-extrabold">说明</h2>
      <ul class="mt-3 space-y-2 text-sm leading-relaxed text-muted">
        <li>参考范围用于信息展示，不代表诊断结论。</li>
        <li>如当前阶段暂无具体范围，页面会展示增长趋势或建议。</li>
        <li>若有持续担忧，请咨询专业医生。</li>
      </ul>
    </section>
    <NoticeBar class="mt-3" text="本数据为参考范围，个体差异较大。" />
  </main>
</template>
