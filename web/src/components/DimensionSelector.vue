<script setup lang="ts">
import type { Dimension } from '@/types/growth'

defineProps<{
  title: string
  subtitle?: string
  dimensions: Dimension[]
  activeKey?: string
}>()

const icons: Record<string, string> = {
  weight: '⚖',
  height: '↕',
  head_circumference: '◎',
  sleep: '☾',
  stool: '▥',
  complementary_food: '🥣',
  milk_feeding: '🍼',
  motor: '🧸',
  language: '…',
  cognition: '◇',
  social_emotional: '♡',
  vaccine: '＋',
  checkup: '⌁',
  warning_sign: '!',
}
</script>

<template>
  <section class="card">
    <div class="mb-3 flex items-center justify-between">
      <h3 class="text-lg font-extrabold">{{ title }}</h3>
      <span v-if="subtitle" class="text-xs font-bold text-muted">{{ subtitle }}</span>
    </div>
    <div class="grid grid-cols-3 gap-2">
      <RouterLink
        v-for="dimension in dimensions"
        :key="dimension.dimensionKey"
        class="grid min-h-20 place-items-center gap-1 rounded-lg border border-line bg-white p-2 text-center text-sm font-extrabold"
        :class="activeKey === dimension.dimensionKey ? '!border-brand !bg-brand !text-white' : ''"
        :to="`/compare/${dimension.dimensionKey}`"
      >
        <span class="text-xl">{{ icons[dimension.dimensionKey] ?? '•' }}</span>
        <span>{{ dimension.dimensionName.replace('/主食', '') }}</span>
      </RouterLink>
    </div>
  </section>
</template>
