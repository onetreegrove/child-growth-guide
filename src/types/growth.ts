export type Gender = 'all' | 'male' | 'female'
export type CompareRange = 'nearby' | 'all'

export interface DatasetMeta {
  dataset_name?: string
  version?: string
  source_pdf?: string
  source_pages?: string | number
  generated_at?: string
  note?: string
}

export interface AgeStage {
  id: string
  name: string
  displayName: string
  minDays: number
  maxDays: number
  sortOrder: number
  sourcePages: number[]
}

export interface Dimension {
  dimensionKey: string
  dimensionName: string
  dimensionGroup: string
  unit: string | null
  sortOrder: number
  description: string | null
}

export interface GrowthMetric {
  id: number
  stageId: string
  metricKey: 'weight' | 'height' | 'head_circumference'
  metricName: string
  unit: string
  maleMin: number | null
  maleMax: number | null
  femaleMin: number | null
  femaleMax: number | null
  growthRate: string | null
  sourceText: string | null
}

export interface ContentItem {
  id: number
  stageId: string
  category: string
  title: string
  summary: string | null
  content: string
  sortOrder: number
}

export interface DevelopmentItem {
  id: number
  stageId: string
  domain: string
  content: string
  sortOrder: number
}

export interface VaccineItem {
  id: number
  stageId: string
  ageLabel: string
  vaccineName: string
  dose: string | null
  note: string | null
  sortOrder: number
}

export interface CheckupItem {
  id: number
  stageId: string
  ageLabel: string
  purpose: string
  items: string
  note: string | null
}

export interface CompareTextItem {
  stage: AgeStage
  title: string
  summary: string
  sourcePages: number[]
}
