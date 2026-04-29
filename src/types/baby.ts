import type { Gender } from './growth'

export interface BabyProfile {
  nickname: string
  birthDate: string
  gender: Gender
  persist: boolean
  manualStageId: string | null
}
