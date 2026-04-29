<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import CompareTable from '@/components/CompareTable.vue'
import CompareTextList from '@/components/CompareTextList.vue'
import NoticeBar from '@/components/NoticeBar.vue'
import {
  getCompareTextItems,
  getDimension,
  getGrowthMetrics,
  growthDimensionKeys,
} from '@/services/growthService'
import { useBabyProfileStore } from '@/stores/babyProfile'
import type { CompareRange, Gender } from '@/types/growth'

const route = useRoute()
const babyStore = useBabyProfileStore()
const range = ref<CompareRange>('nearby')
const gender = ref<Gender>(babyStore.profile.gender)

const dimensionKey = computed(() => String(route.params.dimensionKey))
const dimension = computed(() => getDimension(dimensionKey.value))
const isGrowth = computed(() => (growthDimensionKeys as readonly string[]).includes(dimensionKey.value))
const growthMetrics = computed(() => getGrowthMetrics(dimensionKey.value, babyStore.matchedStage.id, range.value))
const textItems = computed(() => getCompareTextItems(dimensionKey.value, babyStore.matchedStage.id, range.value))

const siblingTabs = computed(() =>
  isGrowth.value
    ? [
        ['weight', '体重'],
        ['height', '身高'],
        ['head_circumference', '头围'],
      ]
    : [
        ['sleep', '睡眠'],
        ['complementary_food', '喂养'],
        ['motor', '发育'],
      ],
)
</script>

<template>
  <main class="page-shell">
    <AppHeader :title="`${dimension?.dimensionName ?? '维度'}对比`" action-text="说明" back @action="$router.push('/about/data')" />

    <div class="mb-3 flex gap-2 overflow-hidden">
      <RouterLink
        v-for="[key, name] in siblingTabs"
        :key="key"
        class="grid h-9 min-w-20 place-items-center rounded-full border border-line bg-white px-4 text-sm font-extrabold text-muted"
        :class="key === dimensionKey ? '!border-brand !bg-brand !text-white' : ''"
        :to="`/compare/${key}`"
      >
        {{ name }}
      </RouterLink>
    </div>

    <div v-if="isGrowth" class="mb-3 grid grid-cols-3 gap-2">
      <button
        v-for="item in [
          ['all', '全部'],
          ['male', '男孩'],
          ['female', '女孩'],
        ]"
        :key="item[0]"
        class="seg-btn"
        :class="gender === item[0] ? 'seg-btn-active' : ''"
        type="button"
        @click="gender = item[0] as Gender"
      >
        {{ item[1] }}
      </button>
    </div>

    <div class="mb-3 grid grid-cols-2 gap-2">
      <button class="seg-btn" :class="range === 'nearby' ? 'seg-btn-active' : ''" type="button" @click="range = 'nearby'">相邻阶段</button>
      <button class="seg-btn" :class="range === 'all' ? 'seg-btn-active' : ''" type="button" @click="range = 'all'">全部阶段</button>
    </div>

    <CompareTable v-if="isGrowth" :current-stage-id="babyStore.matchedStage.id" :gender="gender" :metrics="growthMetrics" />
    <CompareTextList v-else :current-stage-id="babyStore.matchedStage.id" :items="textItems" />

    <NoticeBar class="mt-3" mark="★" text="当前宝宝阶段已高亮。数值为参考范围，不代表诊断结论。" />
  </main>
</template>
