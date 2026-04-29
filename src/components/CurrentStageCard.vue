<script setup lang="ts">
import type { AgeStage } from '@/types/growth'

defineProps<{
  nickname: string
  babyAgeText: string
  stage: AgeStage
  daysToNext: number | null
}>()
</script>

<template>
  <section class="relative overflow-hidden rounded-2xl bg-gradient-to-br from-brand to-brand-dark p-5 text-white shadow-hero">
    <div class="absolute -right-10 -top-10 h-32 w-32 rounded-full bg-white/15" />
    <div class="relative flex items-center gap-4">
      <div class="grid h-16 w-16 place-items-center rounded-full border-4 border-white/75 bg-[#fff3e8] text-3xl">☺</div>
      <div>
        <p class="text-sm opacity-90">{{ nickname }} · {{ babyAgeText }}</p>
        <h2 class="text-3xl font-black tracking-normal">{{ stage.displayName }}</h2>
        <p class="mt-1 text-xs opacity-90">
          当前匹配阶段<span v-if="daysToNext !== null">，距离下一阶段约{{ daysToNext }}天</span>
        </p>
      </div>
    </div>
    <div class="relative mt-4 flex gap-2">
      <button class="rounded-full border border-white/70 bg-white/10 px-3 py-2 text-xs font-bold" type="button">
        自动匹配
      </button>
      <RouterLink class="rounded-full border border-white/70 bg-white/10 px-3 py-2 text-xs font-bold" to="/stages">
        手动切换
      </RouterLink>
    </div>
  </section>
</template>
