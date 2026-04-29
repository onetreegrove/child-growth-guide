<script setup lang="ts">
import AppHeader from '@/components/AppHeader.vue'
import BottomNav from '@/components/BottomNav.vue'
import DimensionSelector from '@/components/DimensionSelector.vue'
import { getDimensionsByGroup } from '@/services/growthService'
import { useBabyProfileStore } from '@/stores/babyProfile'

const babyStore = useBabyProfileStore()
const growth = getDimensionsByGroup('growth')
const care = getDimensionsByGroup('care')
const nutrition = getDimensionsByGroup('nutrition')
const development = getDimensionsByGroup('development')
const medical = getDimensionsByGroup('medical')
</script>

<template>
  <main class="page-shell">
    <AppHeader action-text="筛选" title="多维对比" />
    <section class="soft-card mb-4">
      <div class="font-extrabold">当前宝宝：{{ babyStore.babyAgeText }}</div>
      <div class="mt-1 text-sm text-muted">当前阶段 {{ babyStore.matchedStage.displayName }}，默认对比相邻阶段。</div>
      <div class="mt-3 grid grid-cols-2 gap-2">
        <span class="seg-btn seg-btn-active">相邻阶段</span>
        <span class="seg-btn">全部阶段</span>
      </div>
    </section>

    <div class="space-y-4">
      <DimensionSelector :dimensions="growth" subtitle="参考范围" title="生长指标" />
      <DimensionSelector :dimensions="[...care, ...nutrition]" subtitle="建议类" title="日常照护与喂养" />
      <DimensionSelector :dimensions="development" subtitle="阶段变化" title="发育表现" />
      <DimensionSelector :dimensions="medical" subtitle="参考安排" title="医疗保健" />
    </div>
    <BottomNav />
  </main>
</template>
