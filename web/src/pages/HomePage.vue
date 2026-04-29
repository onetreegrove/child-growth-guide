<script setup lang="ts">
import { computed, ref } from 'vue'
import AppHeader from '@/components/AppHeader.vue'
import BabyProfilePanel from '@/components/BabyProfilePanel.vue'
import BottomNav from '@/components/BottomNav.vue'
import CurrentStageCard from '@/components/CurrentStageCard.vue'
import MetricCard from '@/components/MetricCard.vue'
import NoticeBar from '@/components/NoticeBar.vue'
import { getCurrentStageMetrics, getStageContent } from '@/services/growthService'
import { sanitizeMedicalCopy } from '@/services/medicalCopy'
import { useBabyProfileStore } from '@/stores/babyProfile'
import type { BabyProfile } from '@/types/baby'

const babyStore = useBabyProfileStore()
const panelVisible = ref(false)

const currentMetrics = computed(() => getCurrentStageMetrics(babyStore.matchedStage.id))
const stageContent = computed(() => getStageContent(babyStore.matchedStage.id))

function saveProfile(profile: Partial<BabyProfile>): void {
  babyStore.updateProfile(profile)
  if (!babyStore.error) {
    panelVisible.value = false
  }
}
</script>

<template>
  <main class="page-shell">
    <div class="mb-2 flex items-center justify-between">
      <h1 class="text-2xl font-black tracking-normal">0-3岁成长发育</h1>
      <RouterLink class="text-link" to="/about/data">数据说明</RouterLink>
    </div>

    <CurrentStageCard
      :baby-age-text="babyStore.babyAgeText"
      :days-to-next="babyStore.daysToNext"
      :nickname="babyStore.profile.nickname"
      :stage="babyStore.matchedStage"
    />

    <button class="mt-3 w-full rounded-lg border border-line bg-white px-3 py-2 text-left text-sm font-bold text-muted" type="button" @click="panelVisible = true">
      出生日期 {{ babyStore.profile.birthDate || '未填写' }} · 点击修改宝宝信息
    </button>

    <section class="mt-4 grid grid-cols-3 gap-2">
      <MetricCard v-for="metric in currentMetrics" :key="metric.id" :gender="babyStore.profile.gender" :metric="metric" />
    </section>

    <section class="card mt-4">
      <div class="mb-3 flex items-center justify-between">
        <h2 class="text-lg font-extrabold">今日重点</h2>
        <span class="tag">当前阶段</span>
      </div>
      <div class="space-y-2">
        <RouterLink v-if="stageContent.nutrition[0]" class="soft-card flex items-center gap-3 p-3" to="/compare/complementary_food">
          <span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-soft text-xl">🥣</span>
          <span>
            <span class="block text-sm font-extrabold">营养喂养</span>
            <span class="line-clamp-1 text-xs text-muted">{{ sanitizeMedicalCopy(stageContent.nutrition[0].summary) }}</span>
          </span>
        </RouterLink>
        <RouterLink v-if="stageContent.care[0]" class="soft-card flex items-center gap-3 p-3" to="/compare/sleep">
          <span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-soft text-xl">☾</span>
          <span>
            <span class="block text-sm font-extrabold">睡眠节律</span>
            <span class="line-clamp-1 text-xs text-muted">{{ sanitizeMedicalCopy(stageContent.care[0].summary) }}</span>
          </span>
        </RouterLink>
        <RouterLink v-if="stageContent.development[0]" class="soft-card flex items-center gap-3 p-3" to="/compare/motor">
          <span class="grid h-10 w-10 place-items-center rounded-lg bg-brand-soft text-xl">🧸</span>
          <span>
            <span class="block text-sm font-extrabold">发育表现</span>
            <span class="line-clamp-1 text-xs text-muted">{{ sanitizeMedicalCopy(stageContent.development[0].content) }}</span>
          </span>
        </RouterLink>
      </div>
    </section>

    <div class="mt-4 grid grid-cols-2 gap-3">
      <RouterLink class="primary-btn grid place-items-center" :to="`/stages/${babyStore.matchedStage.id}`">查看阶段详情</RouterLink>
      <RouterLink class="secondary-btn grid place-items-center" to="/compare">多维度对比</RouterLink>
    </div>

    <NoticeBar class="mt-3" text="本工具仅供育儿信息参考，不能替代专业医疗建议。" />
    <BabyProfilePanel :error="babyStore.error" :profile="babyStore.profile" :visible="panelVisible" @close="panelVisible = false" @save="saveProfile" />
    <BottomNav />
  </main>
</template>
