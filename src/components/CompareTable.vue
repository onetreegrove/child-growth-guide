<script setup lang="ts">
import { computed } from 'vue'
import { formatMetricValue, getStage } from '@/services/growthService'
import type { Gender, GrowthMetric } from '@/types/growth'

const props = defineProps<{
  metrics: GrowthMetric[]
  currentStageId: string
  gender: Gender
}>()

const rows = computed(() =>
  props.metrics.map((metric) => ({
    metric,
    stage: getStage(metric.stageId),
  })),
)
</script>

<template>
  <div class="overflow-hidden rounded-lg border border-line bg-white">
    <div class="grid min-h-11 grid-cols-[86px_1fr_1fr] bg-[#f5f8f8] text-xs font-extrabold text-muted">
      <div class="border-r border-line p-3">阶段</div>
      <div class="border-r border-line p-3">参考值</div>
      <div class="p-3">说明</div>
    </div>
    <RouterLink
      v-for="{ metric, stage } in rows"
      :key="metric.id"
      class="grid min-h-16 grid-cols-[86px_1fr_1fr] border-t border-line"
      :class="metric.stageId === currentStageId ? 'bg-brand-soft shadow-[inset_4px_0_0_#0f8f85]' : ''"
      :to="`/stages/${metric.stageId}`"
    >
      <div class="grid content-center border-r border-line p-3 text-sm font-extrabold">
        {{ stage?.displayName }}
        <span v-if="metric.stageId === currentStageId" class="tag mt-1 w-fit">当前</span>
      </div>
      <div class="grid content-center border-r border-line p-3 text-sm font-extrabold" :class="gender === 'female' ? 'text-girl' : 'text-boy'">
        {{ formatMetricValue(metric, gender) }}
        <div class="mt-2 h-1.5 overflow-hidden rounded-full bg-line">
          <span class="block h-full rounded-full bg-brand" :style="{ width: metric.maleMin === null ? '46%' : '78%' }" />
        </div>
      </div>
      <div class="grid content-center p-3 text-xs leading-relaxed text-muted">
        {{ metric.maleMin === null ? '仅提供增长速度' : `来源页 ${stage?.sourcePages?.[0] ?? '-'}` }}
      </div>
    </RouterLink>
  </div>
</template>
