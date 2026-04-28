<script setup lang="ts">
import { computed } from 'vue'
import { formatMetricValue } from '@/services/growthService'
import type { Gender, GrowthMetric } from '@/types/growth'

const props = defineProps<{
  metric: GrowthMetric
  gender: Gender
}>()

const icon = computed(() => {
  if (props.metric.metricKey === 'weight') return 'kg'
  if (props.metric.metricKey === 'height') return 'cm'
  return '◎'
})
</script>

<template>
  <RouterLink class="card block min-h-[126px] p-3" :to="`/compare/${metric.metricKey}`">
    <div class="mb-2 grid h-8 w-8 place-items-center rounded-lg bg-brand text-xs font-black text-white">{{ icon }}</div>
    <div class="text-sm font-bold text-muted">{{ metric.metricName }}</div>
    <div v-if="gender === 'all'" class="mt-1 space-y-1">
      <div v-if="metric.maleMin !== null && metric.maleMax !== null" class="text-base font-extrabold text-boy">
        {{ metric.maleMin }}-{{ metric.maleMax }}
      </div>
      <div v-if="metric.femaleMin !== null && metric.femaleMax !== null" class="text-base font-extrabold text-girl">
        {{ metric.femaleMin }}-{{ metric.femaleMax }}
      </div>
      <div v-if="metric.maleMin === null" class="text-sm font-bold text-muted">{{ metric.growthRate }}</div>
    </div>
    <div v-else class="mt-1 text-base font-extrabold" :class="gender === 'male' ? 'text-boy' : 'text-girl'">
      {{ formatMetricValue(metric, gender) }}
    </div>
    <div class="mt-1 text-[11px] font-bold text-muted">参考范围 {{ metric.unit }}</div>
  </RouterLink>
</template>
