import { describe, expect, it } from 'vitest'
import { stages } from '@/services/growthService'
import { calculateAgeDays, getNearbyStages, matchStageByAgeDays } from '@/services/stageMatcher'

describe('stageMatcher', () => {
  it('matches 2025-06-20 to 10-12 month stage on 2026-04-28', () => {
    const ageDays = calculateAgeDays('2025-06-20', new Date('2026-04-28T12:00:00'))
    const stage = matchStageByAgeDays(stages, ageDays)

    expect(stage?.id).toBe('10_12m')
  })

  it('rejects a future birth date', () => {
    expect(() => calculateAgeDays('2026-04-29', new Date('2026-04-28T12:00:00'))).toThrow('出生日期不能晚于今天')
  })

  it('returns nearby stages around the current stage', () => {
    const nearby = getNearbyStages(stages, '10_12m', 1).map((stage) => stage.id)

    expect(nearby).toEqual(['7_9m', '10_12m', '13_18m'])
  })
})
