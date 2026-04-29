import { expect, test } from '@playwright/test'

const routes = [
  ['home', '/'],
  ['compare', '/compare'],
  ['compare-weight', '/compare/weight'],
  ['compare-sleep', '/compare/sleep'],
  ['stages', '/stages'],
  ['stage-detail', '/stages/10_12m'],
  ['data-about', '/about/data'],
] as const

const viewports = [
  ['iphone-se', { width: 375, height: 667 }],
  ['iphone-12', { width: 390, height: 844 }],
  ['android-wide', { width: 412, height: 915 }],
] as const

test('captures MVP pages across mobile viewports', async ({ page }, testInfo) => {
  for (const [viewportName, viewport] of viewports) {
    await page.setViewportSize(viewport)
    for (const [routeName, route] of routes) {
      await page.goto(route)
      await expect(page.locator('body')).toContainText(route === '/' ? '0-3岁成长发育' : '')
      await page.screenshot({
        path: testInfo.outputPath(`visual-${viewportName}-${routeName}.png`),
        fullPage: true,
      })
    }
  }
})
