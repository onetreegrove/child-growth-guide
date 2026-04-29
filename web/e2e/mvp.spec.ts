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
