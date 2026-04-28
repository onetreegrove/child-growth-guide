<script setup lang="ts">
import AppHeader from '@/components/AppHeader.vue'
import BottomNav from '@/components/BottomNav.vue'
import { stages } from '@/services/growthService'
import { useBabyProfileStore } from '@/stores/babyProfile'

const babyStore = useBabyProfileStore()
</script>

<template>
  <main class="page-shell">
    <AppHeader action-text="修改" title="阶段" @action="$router.push('/')" />
    <section class="soft-card mb-4">
      <div class="font-extrabold">当前匹配：{{ babyStore.matchedStage.displayName }}</div>
      <div class="mt-1 text-sm text-muted">{{ babyStore.profile.nickname }} · {{ babyStore.babyAgeText }}。可手动切换查看其他阶段。</div>
    </section>
    <section class="card space-y-2">
      <RouterLink
        v-for="stage in stages"
        :key="stage.id"
        class="flex min-h-14 items-center justify-between rounded-lg border border-line bg-white p-3"
        :class="stage.id === babyStore.matchedStage.id ? 'border-brand bg-brand-soft' : ''"
        :to="`/stages/${stage.id}`"
        @click="babyStore.setManualStage(stage.id)"
      >
        <span class="font-extrabold">{{ stage.displayName }}</span>
        <span v-if="stage.id === babyStore.matchedStage.id" class="tag">当前宝宝</span>
        <span v-else class="text-xs font-bold text-muted">{{ stage.name.replace(stage.displayName, '') }}</span>
      </RouterLink>
    </section>
    <BottomNav />
  </main>
</template>
