<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import MetricCard from '@/components/MetricCard.vue'
import NoticeBar from '@/components/NoticeBar.vue'
import { getCurrentStageMetrics, getDimension, getStage, getStageContent } from '@/services/growthService'
import { sanitizeMedicalCopy } from '@/services/medicalCopy'
import { useBabyProfileStore } from '@/stores/babyProfile'

const route = useRoute()
const babyStore = useBabyProfileStore()
const stageId = computed(() => String(route.params.stageId))
const stage = computed(() => getStage(stageId.value) ?? babyStore.matchedStage)
const metrics = computed(() => getCurrentStageMetrics(stage.value.id))
const content = computed(() => getStageContent(stage.value.id))
const detailDialog = ref<{ title: string; text: string } | null>(null)

function getDevelopmentDomainName(domain: string): string {
  return getDimension(domain)?.dimensionName ?? domain
}

function openDetail(title: string, text: string | null | undefined): void {
  detailDialog.value = {
    title,
    text: sanitizeMedicalCopy(text || '暂无详细说明。'),
  }
}
</script>

<template>
  <main class="page-shell">
    <AppHeader :title="stage.displayName" action-text="对比" back @action="$router.push('/compare')" />
    <section class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-brand to-brand-dark p-5 text-white shadow-hero">
      <div class="absolute -right-10 -top-10 h-32 w-32 rounded-full bg-white/15" />
      <p class="text-sm opacity-90">{{ babyStore.profile.nickname }} · {{ babyStore.babyAgeText }}</p>
      <h1 class="mt-1 text-3xl font-black">当前阶段详情</h1>
      <p class="mt-2 text-xs opacity-90">阶段范围：第 {{ stage.minDays }}-{{ stage.maxDays }} 天</p>
    </section>

    <section class="card mt-4">
      <div class="mb-3 flex items-center justify-between">
        <h2 class="text-lg font-extrabold">生长指标</h2>
        <RouterLink class="text-link" to="/compare/weight">与其他阶段对比</RouterLink>
      </div>
      <div class="grid grid-cols-3 gap-2">
        <MetricCard v-for="metric in metrics" :key="metric.id" :gender="babyStore.profile.gender" :metric="metric" />
      </div>
    </section>

    <section class="card mt-4 space-y-3">
      <h2 class="text-lg font-extrabold">营养喂养</h2>
      <button
        v-for="item in content.nutrition.slice(0, 3)"
        :key="item.id"
        class="soft-card block w-full p-3 text-left"
        type="button"
        @click="openDetail(item.title, item.summary || item.content)"
      >
        <strong class="block text-sm">{{ item.title }}</strong>
        <span class="line-clamp-2 text-xs leading-relaxed text-muted">{{ sanitizeMedicalCopy(item.summary || item.content) }}</span>
      </button>
    </section>

    <section class="card mt-4 space-y-3">
      <h2 class="text-lg font-extrabold">发育表现</h2>
      <button
        v-for="item in content.development"
        :key="item.id"
        class="soft-card block w-full p-3 text-left"
        type="button"
        @click="openDetail(getDevelopmentDomainName(item.domain), item.content)"
      >
        <strong class="block text-sm">{{ getDevelopmentDomainName(item.domain) }}</strong>
        <span class="line-clamp-2 text-xs leading-relaxed text-muted">{{ sanitizeMedicalCopy(item.content) }}</span>
      </button>
    </section>

    <section class="card mt-4 space-y-3">
      <h2 class="text-lg font-extrabold">医疗保健</h2>
      <button
        v-for="item in content.vaccines.slice(0, 3)"
        :key="`v-${item.id}`"
        class="soft-card block w-full p-3 text-left"
        type="button"
        @click="openDetail(`${item.ageLabel} ${item.vaccineName}`, item.dose || item.note || '接种安排以当地接种单位为准')"
      >
        <strong class="block text-sm">{{ item.ageLabel }} {{ item.vaccineName }}</strong>
        <span class="text-xs text-muted">{{ sanitizeMedicalCopy(item.dose || item.note || '接种安排以当地接种单位为准') }}</span>
      </button>
      <button
        v-for="item in content.checkups.slice(0, 1)"
        :key="`c-${item.id}`"
        class="soft-card block w-full p-3 text-left"
        type="button"
        @click="openDetail(`${item.ageLabel}体检`, item.purpose)"
      >
        <strong class="block text-sm">{{ item.ageLabel }}体检</strong>
        <span class="line-clamp-2 text-xs text-muted">{{ sanitizeMedicalCopy(item.purpose) }}</span>
      </button>
    </section>

    <NoticeBar class="mt-3" text="个体差异较大，若有持续担忧，请咨询专业医生。" />

    <div v-if="detailDialog" class="fixed inset-0 z-50 grid place-items-center bg-black/40 px-4 py-5" role="dialog" aria-modal="true" @click.self="detailDialog = null">
      <section class="max-h-[78vh] w-full max-w-[398px] overflow-y-auto rounded-lg bg-white p-4 shadow-hero">
        <div class="flex items-start justify-between gap-3">
          <h2 class="text-lg font-extrabold">{{ detailDialog.title }}</h2>
          <button class="text-link shrink-0" type="button" @click="detailDialog = null">关闭</button>
        </div>
        <p class="mt-3 whitespace-pre-wrap text-sm leading-relaxed text-muted">{{ detailDialog.text }}</p>
      </section>
    </div>
  </main>
</template>
