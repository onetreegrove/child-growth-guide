import { computed, ref, watch } from 'vue'
import { defineStore } from 'pinia'
import { getDefaultStage, stages } from '@/services/growthService'
import { calculateAgeDays, daysUntilNextStage, formatBabyAge, matchStageByAgeDays } from '@/services/stageMatcher'
import type { BabyProfile } from '@/types/baby'
import type { Gender } from '@/types/growth'

const storageKey = 'child-growth:baby-profile'

const defaultProfile: BabyProfile = {
  nickname: '小树苗',
  birthDate: '',
  gender: 'all',
  persist: true,
  manualStageId: null,
}

function loadProfile(): BabyProfile {
  const raw = localStorage.getItem(storageKey)
  if (!raw) return defaultProfile

  try {
    return { ...defaultProfile, ...(JSON.parse(raw) as Partial<BabyProfile>) }
  } catch {
    return defaultProfile
  }
}

export const useBabyProfileStore = defineStore('babyProfile', () => {
  const profile = ref<BabyProfile>(loadProfile())
  const error = ref('')

  const ageDays = computed(() => {
    if (!profile.value.birthDate) return null
    try {
      error.value = ''
      return calculateAgeDays(profile.value.birthDate)
    } catch (err) {
      error.value = err instanceof Error ? err.message : '出生日期不正确'
      return null
    }
  })

  const matchedStage = computed(() => {
    if (profile.value.manualStageId) {
      return stages.find((stage) => stage.id === profile.value.manualStageId) ?? getDefaultStage()
    }

    if (ageDays.value === null) return getDefaultStage()
    return matchStageByAgeDays(stages, ageDays.value) ?? getDefaultStage()
  })

  const babyAgeText = computed(() => (ageDays.value === null ? '未填写出生日期' : formatBabyAge(ageDays.value)))

  const daysToNext = computed(() =>
    ageDays.value === null ? null : daysUntilNextStage(stages, matchedStage.value, ageDays.value),
  )

  function updateProfile(next: Partial<BabyProfile>): void {
    profile.value = { ...profile.value, ...next }
  }

  function setGender(gender: Gender): void {
    profile.value.gender = gender
  }

  function setManualStage(stageId: string | null): void {
    profile.value.manualStageId = stageId
  }

  watch(
    profile,
    (value) => {
      if (value.persist) {
        localStorage.setItem(storageKey, JSON.stringify(value))
      } else {
        localStorage.removeItem(storageKey)
      }
    },
    { deep: true },
  )

  return {
    profile,
    error,
    ageDays,
    matchedStage,
    babyAgeText,
    daysToNext,
    updateProfile,
    setGender,
    setManualStage,
  }
})
