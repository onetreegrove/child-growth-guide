import { describe, expect, it } from 'vitest'
import { sanitizeMedicalCopy } from '@/services/medicalCopy'

describe('medicalCopy', () => {
  it('replaces diagnostic wording in displayed copy', () => {
    expect(sanitizeMedicalCopy('正常长速：每月增长1cm，需做发育迟缓筛查')).toBe('参考长速：每月增长1cm，需做发育筛查')
  })
})
