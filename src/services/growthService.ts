import datasetMetaRaw from '@/data/generated/datasetMeta.json'
import stagesRaw from '@/data/generated/stages.json'
import dimensionsRaw from '@/data/generated/dimensions.json'
import growthMetricsRaw from '@/data/generated/growthMetrics.json'
import contentItemsRaw from '@/data/generated/contentItems.json'
import developmentItemsRaw from '@/data/generated/developmentItems.json'
import vaccineItemsRaw from '@/data/generated/vaccineItems.json'
import checkupItemsRaw from '@/data/generated/checkupItems.json'
import { getNearbyStages } from './stageMatcher'
import { sanitizeMedicalCopy } from './medicalCopy'
import type {
  AgeStage,
  CheckupItem,
  CompareRange,
  CompareTextItem,
  ContentItem,
  DatasetMeta,
  DevelopmentItem,
  Dimension,
  Gender,
  GrowthMetric,
  VaccineItem,
} from '@/types/growth'

export const datasetMeta = datasetMetaRaw as DatasetMeta
export const stages = (stagesRaw as AgeStage[]).sort((a, b) => a.sortOrder - b.sortOrder)
export const dimensions = (dimensionsRaw as Dimension[]).sort((a, b) => a.sortOrder - b.sortOrder)
export const growthMetrics = growthMetricsRaw as GrowthMetric[]
export const contentItems = contentItemsRaw as ContentItem[]
export const developmentItems = developmentItemsRaw as DevelopmentItem[]
export const vaccineItems = vaccineItemsRaw as VaccineItem[]
export const checkupItems = checkupItemsRaw as CheckupItem[]

export const growthDimensionKeys = ['weight', 'height', 'head_circumference'] as const

const feedingCategories = ['milk_feeding', 'complementary_food', 'supplements']

export function getStage(stageId: string): AgeStage | undefined {
  return stages.find((stage) => stage.id === stageId)
}

export function getDefaultStage(): AgeStage {
  return getStage('10_12m') ?? stages[0]
}

export function getDimensionsByGroup(group: string): Dimension[] {
  return dimensions.filter((dimension) => dimension.dimensionGroup === group)
}

export function getDimension(dimensionKey: string): Dimension | undefined {
  return dimensions.find((dimension) => dimension.dimensionKey === dimensionKey)
}

export function getCurrentStageMetrics(stageId: string): GrowthMetric[] {
  return growthDimensionKeys
    .map((metricKey) => growthMetrics.find((metric) => metric.stageId === stageId && metric.metricKey === metricKey))
    .filter((metric): metric is GrowthMetric => Boolean(metric))
}

export function getGrowthMetrics(metricKey: string, currentStageId: string, range: CompareRange): GrowthMetric[] {
  const targetStages = range === 'all' ? stages : getNearbyStages(stages, currentStageId)
  const stageIds = new Set(targetStages.map((stage) => stage.id))

  return growthMetrics
    .filter((metric) => metric.metricKey === metricKey && stageIds.has(metric.stageId))
    .sort((a, b) => {
      const stageA = getStage(a.stageId)
      const stageB = getStage(b.stageId)
      return (stageA?.sortOrder ?? 0) - (stageB?.sortOrder ?? 0)
    })
}

export function formatMetricValue(metric: GrowthMetric, gender: Gender): string {
  if (gender === 'male' && metric.maleMin !== null && metric.maleMax !== null) {
    return `${metric.maleMin}-${metric.maleMax}`
  }

  if (gender === 'female' && metric.femaleMin !== null && metric.femaleMax !== null) {
    return `${metric.femaleMin}-${metric.femaleMax}`
  }

  if (
    gender === 'all' &&
    metric.maleMin !== null &&
    metric.maleMax !== null &&
    metric.femaleMin !== null &&
    metric.femaleMax !== null
  ) {
    return `男 ${metric.maleMin}-${metric.maleMax} / 女 ${metric.femaleMin}-${metric.femaleMax}`
  }

  return metric.growthRate ?? '暂无具体范围'
}

export function getStageContent(stageId: string): {
  nutrition: ContentItem[]
  care: ContentItem[]
  medical: ContentItem[]
  development: DevelopmentItem[]
  vaccines: VaccineItem[]
  checkups: CheckupItem[]
} {
  return {
    nutrition: contentItems.filter((item) => item.stageId === stageId && feedingCategories.includes(item.category)),
    care: contentItems.filter((item) => item.stageId === stageId && ['sleep', 'stool'].includes(item.category)),
    medical: contentItems.filter((item) => item.stageId === stageId && ['common_issue', 'warning_sign'].includes(item.category)),
    development: developmentItems.filter((item) => item.stageId === stageId),
    vaccines: vaccineItems.filter((item) => item.stageId === stageId),
    checkups: checkupItems.filter((item) => item.stageId === stageId),
  }
}

export function getCompareTextItems(dimensionKey: string, currentStageId: string, range: CompareRange): CompareTextItem[] {
  const targetStages = range === 'all' ? stages : getNearbyStages(stages, currentStageId)

  return targetStages
    .map((stage) => {
      if (['motor', 'language', 'cognition', 'social_emotional'].includes(dimensionKey)) {
        const item = developmentItems.find((entry) => entry.stageId === stage.id && entry.domain === dimensionKey)
        if (!item) return null
        return {
          stage,
          title: getDimension(dimensionKey)?.dimensionName ?? '发育表现',
          summary: sanitizeMedicalCopy(item.content),
          sourcePages: stage.sourcePages,
        }
      }

      if (dimensionKey === 'vaccine') {
        const items = vaccineItems.filter((entry) => entry.stageId === stage.id)
        if (items.length === 0) return null
        return {
          stage,
          title: '疫苗接种',
          summary: sanitizeMedicalCopy(
            items.map((item) => `${item.ageLabel}：${item.vaccineName}${item.dose ? `（${item.dose}）` : ''}`).join('；'),
          ),
          sourcePages: stage.sourcePages,
        }
      }

      if (dimensionKey === 'checkup') {
        const item = checkupItems.find((entry) => entry.stageId === stage.id)
        if (!item) return null
        return {
          stage,
          title: `${item.ageLabel}体检`,
          summary: sanitizeMedicalCopy(item.purpose),
          sourcePages: stage.sourcePages,
        }
      }

      const categoryKeys =
        dimensionKey === 'complementary_food'
          ? feedingCategories
          : dimensionKey === 'milk_feeding'
            ? ['milk_feeding']
            : [dimensionKey]

      const items = contentItems.filter((entry) => entry.stageId === stage.id && categoryKeys.includes(entry.category))
      if (items.length === 0) return null

      return {
        stage,
        title: getDimension(dimensionKey)?.dimensionName ?? items[0].title,
        summary: sanitizeMedicalCopy(items.map((item) => item.summary ?? item.content).join('；')),
        sourcePages: stage.sourcePages,
      }
    })
    .filter((item): item is CompareTextItem => Boolean(item))
}
