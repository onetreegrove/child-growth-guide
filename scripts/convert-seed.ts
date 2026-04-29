import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const sql = readFileSync(resolve(root, 'docs/archive/child_growth_seed.sql'), 'utf8')
const outDir = resolve(root, 'src/data/generated')

type SqlValue = string | number | null

interface InsertRow {
  table: string
  columns: string[]
  values: SqlValue[]
}

function splitCsv(input: string): string[] {
  const result: string[] = []
  let current = ''
  let quoted = false

  for (let i = 0; i < input.length; i += 1) {
    const char = input[i]
    const next = input[i + 1]

    if (char === "'") {
      if (quoted && next === "'") {
        current += "'"
        i += 1
      } else {
        quoted = !quoted
      }
      continue
    }

    if (char === ',' && !quoted) {
      result.push(current.trim())
      current = ''
      continue
    }

    current += char
  }

  result.push(current.trim())
  return result
}

function parseValue(raw: string): SqlValue {
  if (raw.toUpperCase() === 'NULL') return null
  if (/^-?\d+(?:\.\d+)?$/.test(raw)) return Number(raw)
  return raw
}

function parseInserts(source: string): InsertRow[] {
  const rows: InsertRow[] = []
  const insertPattern = /INSERT INTO ([\w_]+) \(([^)]+)\) VALUES \(([\s\S]*?)\);/g
  let match: RegExpExecArray | null

  while ((match = insertPattern.exec(source)) !== null) {
    rows.push({
      table: match[1],
      columns: match[2].split(',').map((column) => column.trim()),
      values: splitCsv(match[3]).map(parseValue),
    })
  }

  return rows
}

function toCamel(key: string): string {
  return key.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase())
}

function rowToObject(row: InsertRow): Record<string, SqlValue | number[]> {
  return row.columns.reduce<Record<string, SqlValue | number[]>>((object, column, index) => {
    const key = toCamel(column)
    const value = row.values[index]

    if (column === 'source_pages' && typeof value === 'string') {
      object[key] = JSON.parse(value) as number[]
    } else {
      object[key] = value
    }

    return object
  }, {})
}

function writeJson(name: string, data: unknown): void {
  const file = resolve(outDir, `${name}.json`)
  writeFileSync(file, `${JSON.stringify(data, null, 2)}\n`)
}

const inserts = parseInserts(sql)
const byTable = new Map<string, InsertRow[]>()

for (const row of inserts) {
  const existing = byTable.get(row.table) ?? []
  existing.push(row)
  byTable.set(row.table, existing)
}

mkdirSync(outDir, { recursive: true })

const datasetMeta = Object.fromEntries(
  (byTable.get('dataset_meta') ?? []).map((row) => {
    const object = rowToObject(row)
    return [String(object.key), object.value]
  }),
)

writeJson('datasetMeta', datasetMeta)
writeJson('stages', (byTable.get('age_stage') ?? []).map(rowToObject))
writeJson('dimensions', (byTable.get('dimension') ?? []).map(rowToObject))
writeJson('growthMetrics', (byTable.get('growth_metric') ?? []).map(rowToObject))
writeJson('contentItems', (byTable.get('content_item') ?? []).map(rowToObject))
writeJson('developmentItems', (byTable.get('development_item') ?? []).map(rowToObject))
writeJson('vaccineItems', (byTable.get('vaccine_item') ?? []).map(rowToObject))
writeJson('checkupItems', (byTable.get('checkup_item') ?? []).map(rowToObject))

console.log(
  JSON.stringify(
    {
      datasetMeta: Object.keys(datasetMeta).length,
      stages: byTable.get('age_stage')?.length ?? 0,
      dimensions: byTable.get('dimension')?.length ?? 0,
      growthMetrics: byTable.get('growth_metric')?.length ?? 0,
      contentItems: byTable.get('content_item')?.length ?? 0,
      developmentItems: byTable.get('development_item')?.length ?? 0,
      vaccineItems: byTable.get('vaccine_item')?.length ?? 0,
      checkupItems: byTable.get('checkup_item')?.length ?? 0,
    },
    null,
    2,
  ),
)
