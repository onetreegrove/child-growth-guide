<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const active = computed(() => {
  if (route.path.startsWith('/compare')) return 'compare'
  if (route.path.startsWith('/stages')) return 'stages'
  return 'home'
})
</script>

<template>
  <nav class="fixed inset-x-0 bottom-0 z-30 mx-auto grid h-[72px] max-w-[430px] grid-cols-3 border-t border-line bg-white/95 backdrop-blur">
    <RouterLink class="grid place-items-center content-center gap-1 text-xs font-bold" :class="active === 'home' ? 'text-brand-dark' : 'text-muted'" to="/">
      <span class="text-xl">⌂</span>
      <span>首页</span>
    </RouterLink>
    <RouterLink class="grid place-items-center content-center gap-1 text-xs font-bold" :class="active === 'compare' ? 'text-brand-dark' : 'text-muted'" to="/compare">
      <span class="text-xl">▦</span>
      <span>对比</span>
    </RouterLink>
    <RouterLink class="grid place-items-center content-center gap-1 text-xs font-bold" :class="active === 'stages' ? 'text-brand-dark' : 'text-muted'" to="/stages">
      <span class="text-xl">☷</span>
      <span>阶段</span>
    </RouterLink>
  </nav>
</template>
