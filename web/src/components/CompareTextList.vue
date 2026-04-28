<script setup lang="ts">
import type { CompareTextItem } from '@/types/growth'

defineProps<{
  items: CompareTextItem[]
  currentStageId: string
}>()
</script>

<template>
  <div class="space-y-3">
    <RouterLink
      v-for="item in items"
      :key="`${item.stage.id}-${item.title}`"
      class="block rounded-lg border border-line bg-white p-4"
      :class="item.stage.id === currentStageId ? 'border-brand bg-brand-soft' : ''"
      :to="`/stages/${item.stage.id}`"
    >
      <div class="mb-2 flex items-center justify-between gap-3">
        <h3 class="font-extrabold">{{ item.stage.displayName }}</h3>
        <span v-if="item.stage.id === currentStageId" class="tag">当前宝宝</span>
        <span v-else class="text-xs font-bold text-muted">来源页 {{ item.sourcePages[0] }}</span>
      </div>
      <p class="line-clamp-4 text-sm leading-relaxed text-muted">{{ item.summary }}</p>
      <p class="mt-2 text-xs font-bold text-muted">来源页 {{ item.sourcePages.join('、') }}</p>
    </RouterLink>
  </div>
</template>
