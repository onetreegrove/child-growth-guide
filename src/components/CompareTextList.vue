<script setup lang="ts">
import { ref } from 'vue'
import type { CompareTextItem } from '@/types/growth'

defineProps<{
  items: CompareTextItem[]
  currentStageId: string
}>()

const detailDialog = ref<CompareTextItem | null>(null)
</script>

<template>
  <div class="space-y-3">
    <button
      v-for="item in items"
      :key="`${item.stage.id}-${item.title}`"
      class="block w-full rounded-lg border border-line bg-white p-4 text-left"
      :class="item.stage.id === currentStageId ? 'border-brand bg-brand-soft' : ''"
      type="button"
      @click="detailDialog = item"
    >
      <div class="mb-2 flex items-center justify-between gap-3">
        <h3 class="font-extrabold">{{ item.stage.displayName }}</h3>
        <span v-if="item.stage.id === currentStageId" class="tag">当前宝宝</span>
        <span v-else class="text-xs font-bold text-muted">来源页 {{ item.sourcePages[0] }}</span>
      </div>
      <p class="line-clamp-4 text-sm leading-relaxed text-muted">{{ item.summary }}</p>
      <p class="mt-2 text-xs font-bold text-muted">来源页 {{ item.sourcePages.join('、') }}</p>
    </button>
  </div>

  <div v-if="detailDialog" class="fixed inset-0 z-50 grid place-items-center bg-black/40 px-4 py-5" role="dialog" aria-modal="true" @click.self="detailDialog = null">
    <section class="max-h-[78vh] w-full max-w-[398px] overflow-y-auto rounded-lg bg-white p-4 shadow-hero">
      <div class="flex items-start justify-between gap-3">
        <div>
          <h2 class="text-lg font-extrabold">{{ detailDialog.stage.displayName }}</h2>
          <p class="mt-1 text-xs font-bold text-muted">{{ detailDialog.title }} · 来源页 {{ detailDialog.sourcePages.join('、') }}</p>
        </div>
        <button class="text-link shrink-0" type="button" @click="detailDialog = null">关闭</button>
      </div>
      <p class="mt-3 whitespace-pre-wrap text-sm leading-relaxed text-muted">{{ detailDialog.summary }}</p>
    </section>
  </div>
</template>
