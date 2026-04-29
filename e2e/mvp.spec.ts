import { expect, test } from '@playwright/test'

test.beforeEach(async ({ page }) => {
  await page.goto('/')
  await page.evaluate(() => localStorage.clear())
  await page.reload()
})

test('fills birth date and matches the 10-12 month stage', async ({ page }) => {
  await page.getByRole('button', { name: /出生日期 未填写/ }).click()
  await page.getByLabel('出生日期（必填）').fill('2025-06-20')
  await page.getByRole('button', { name: '保存并匹配阶段' }).click()

  await expect(page.getByText('10-12个月').first()).toBeVisible()
  await expect(page.getByText(/小树苗 · 10个月/)).toBeVisible()
})

test('centers the baby profile panel in the mobile viewport', async ({ page }) => {
  await page.getByRole('button', { name: /出生日期 未填写/ }).click()

  const panel = page.getByRole('heading', { name: '宝宝信息' }).locator('xpath=ancestor::section[1]')
  const box = await panel.boundingBox()
  const viewport = page.viewportSize()

  expect(box).not.toBeNull()
  expect(viewport).not.toBeNull()
  expect(Math.abs(box!.x + box!.width / 2 - viewport!.width / 2)).toBeLessThanOrEqual(2)
})

test('navigates from home to stage detail and compare home', async ({ page }) => {
  await page.getByRole('button', { name: /出生日期 未填写/ }).click()
  await page.getByLabel('出生日期（必填）').fill('2025-06-20')
  await page.getByRole('button', { name: '保存并匹配阶段' }).click()

  await page.getByRole('link', { name: '查看阶段详情' }).click()
  await expect(page).toHaveURL(/\/stages\/10_12m$/)
  await expect(page.getByText('当前阶段详情')).toBeVisible()

  await page.goto('/')
  await page.getByRole('link', { name: '多维度对比' }).click()
  await expect(page).toHaveURL(/\/compare$/)
  await expect(page.getByText('生长指标')).toBeVisible()
})

test('shows Chinese development dimension names on stage detail', async ({ page }) => {
  await page.goto('/stages/7_9m')

  await expect(page.getByRole('link', { name: /动作发展/ })).toBeVisible()
  await expect(page.getByRole('link', { name: /语言发展/ })).toBeVisible()
  await expect(page.getByRole('link', { name: /认知发展/ })).toBeVisible()
  await expect(page.getByRole('link', { name: /情感与社会性/ })).toBeVisible()

  await expect(page.getByText('motor')).toHaveCount(0)
  await expect(page.getByText('language')).toHaveCount(0)
  await expect(page.getByText('cognition')).toHaveCount(0)
  await expect(page.getByText('social_emotional')).toHaveCount(0)
})

test('switches gender and range in growth comparison', async ({ page }) => {
  await page.goto('/compare/weight')

  await expect(page.getByText('10-12个月')).toBeVisible()
  await expect(page.getByText('7.7-11.5')).toBeVisible()

  await page.getByRole('button', { name: '女孩' }).click()
  await expect(page.getByText('7.2-10.8')).toBeVisible()

  await page.getByRole('button', { name: '全部阶段' }).click()
  await expect(page.getByText('31-36个月')).toBeVisible()
})

test('shows text comparison and data disclaimer', async ({ page }) => {
  await page.goto('/compare/sleep')

  await expect(page.getByText('睡眠对比')).toBeVisible()
  await expect(page.getByRole('link', { name: /10-12个月 当前宝宝.*12-16小时/ })).toBeVisible()

  await page.getByRole('button', { name: '说明' }).click()
  await expect(page).toHaveURL(/\/about\/data$/)
  await expect(page.getByText('免责声明')).toBeVisible()
})
