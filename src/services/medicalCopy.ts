const replacements: Array<[RegExp, string]> = [
  [/正常长速/g, '参考长速'],
  [/正常出生体重/g, '出生体重参考'],
  [/正常足月儿/g, '足月儿'],
  [/正常新生儿/g, '新生儿'],
  [/发育迟缓筛查/g, '发育筛查'],
  [/发育迟缓/g, '发育情况需专业评估'],
  [/偏高/g, '高于参考范围'],
  [/偏低/g, '低于参考范围'],
]

export function sanitizeMedicalCopy(text: string | null | undefined): string {
  if (!text) return ''

  return replacements.reduce((result, [pattern, replacement]) => result.replace(pattern, replacement), text)
}
