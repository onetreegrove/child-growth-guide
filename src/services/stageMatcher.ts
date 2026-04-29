import type { AgeStage } from '@/types/growth'

const dayMs = 24 * 60 * 60 * 1000

export function calculateAgeDays(birthDate: string, today = new Date()): number {
  const birth = new Date(`${birthDate}T00:00:00`)
  const current = new Date(today.getFullYear(), today.getMonth(), today.getDate())

  if (Number.isNaN(birth.getTime())) {
    throw new Error('出生日期格式不正确')
  }

  const diff = Math.floor((current.getTime() - birth.getTime()) / dayMs)

  if (diff < 0) {
    throw new Error('出生日期不能晚于今天')
  }

  return diff
}

export function formatBabyAge(ageDays: number): string {
  if (ageDays < 42) return `${ageDays}天`

  const months = Math.floor(ageDays / 30.4375)
  const days = Math.max(0, Math.round(ageDays - months * 30.4375))

  if (months < 1) return `${ageDays}天`
  return `${months}个月${days}天`
}

export function matchStageByAgeDays(stages: AgeStage[], ageDays: number): AgeStage | null {
  return stages.find((stage) => ageDays >= stage.minDays && ageDays <= stage.maxDays) ?? null
}

export function getNearbyStages(stages: AgeStage[], currentStageId: string, radius = 2): AgeStage[] {
  const ordered = [...stages].sort((a, b) => a.sortOrder - b.sortOrder)
  const index = ordered.findIndex((stage) => stage.id === currentStageId)

  if (index < 0) return ordered.slice(0, radius * 2 + 1)

  const start = Math.max(0, index - radius)
  const end = Math.min(ordered.length, index + radius + 1)
  return ordered.slice(start, end)
}

export function daysUntilNextStage(stages: AgeStage[], currentStage: AgeStage, ageDays: number): number | null {
  const ordered = [...stages].sort((a, b) => a.sortOrder - b.sortOrder)
  const next = ordered.find((stage) => stage.sortOrder === currentStage.sortOrder + 1)

  if (!next) return null
  return Math.max(0, next.minDays - ageDays)
}
