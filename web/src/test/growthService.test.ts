import { describe, expect, it } from 'vitest'
import { formatMetricValue, getGrowthMetrics, stages } from '@/services/growthService'

describe('growthService', () => {
  it('loads all 9 age stages from generated seed data', () => {
    expect(stages).toHaveLength(9)
  })

  it('uses growth rate text when a growth metric has no numeric range', () => {
    const metric = getGrowthMetrics('weight', '10_12m', 'all').find((item) => item.stageId === '4_6m')

    expect(metric).toBeDefined()
    expect(formatMetricValue(metric!, 'male')).toContain('平均每月体重增长')
  })

  it('formats female values separately', () => {
    const metric = getGrowthMetrics('weight', '10_12m', 'all').find((item) => item.stageId === '10_12m')

    expect(formatMetricValue(metric!, 'female')).toBe('7.2-10.8')
  })
})
