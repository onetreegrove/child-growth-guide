<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import type { BabyProfile } from '@/types/baby'
import type { Gender } from '@/types/growth'

const props = defineProps<{
  visible: boolean
  profile: BabyProfile
  error?: string
}>()

const emit = defineEmits<{
  close: []
  save: [profile: Partial<BabyProfile>]
}>()

const nickname = ref(props.profile.nickname)
const birthDate = ref(props.profile.birthDate)
const gender = ref<Gender>(props.profile.gender)
const persist = ref(props.profile.persist)

watch(
  () => props.visible,
  () => {
    nickname.value = props.profile.nickname
    birthDate.value = props.profile.birthDate
    gender.value = props.profile.gender
    persist.value = props.profile.persist
  },
)

const canSave = computed(() => birthDate.value.length > 0)

function save(): void {
  if (!canSave.value) return
  emit('save', {
    nickname: nickname.value || '小树苗',
    birthDate: birthDate.value,
    gender: gender.value,
    persist: persist.value,
    manualStageId: null,
  })
}
</script>

<template>
  <div v-if="visible" class="fixed inset-0 z-40 grid place-items-end bg-black/30">
    <section class="w-full max-w-[430px] rounded-t-2xl bg-white p-4 shadow-hero">
      <header class="mb-4 flex items-center justify-between">
        <h2 class="text-xl font-extrabold">宝宝信息</h2>
        <button class="text-link" type="button" @click="emit('close')">关闭</button>
      </header>

      <div class="space-y-4">
        <label class="block">
          <span class="mb-2 block text-sm font-extrabold">昵称（选填）</span>
          <input v-model="nickname" class="h-11 w-full rounded-lg border border-line bg-[#f7fbfa] px-3 outline-none" maxlength="12" />
        </label>
        <label class="block">
          <span class="mb-2 block text-sm font-extrabold">出生日期（必填）</span>
          <input v-model="birthDate" class="h-11 w-full rounded-lg border border-line bg-[#f7fbfa] px-3 outline-none" type="date" />
        </label>
        <div>
          <span class="mb-2 block text-sm font-extrabold">性别（用于指标展示）</span>
          <div class="grid grid-cols-3 gap-2">
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
        </div>
        <label class="soft-card flex items-center justify-between">
          <span>
            <span class="block text-sm font-extrabold">本地保存</span>
            <span class="text-xs text-muted">仅保存在当前设备，下次访问自动匹配。</span>
          </span>
          <input v-model="persist" class="h-6 w-6 accent-brand" type="checkbox" />
        </label>
        <p v-if="error" class="text-sm font-bold text-girl">{{ error }}</p>
        <button class="primary-btn w-full disabled:opacity-50" :disabled="!canSave" type="button" @click="save">保存并匹配阶段</button>
      </div>
    </section>
  </div>
</template>
