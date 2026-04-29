import { expect, test } from '@playwright/test'

const routes = ['/', '/compare/weight', '/compare/sleep', '/stages/10_12m', '/dimensions/weight', '/about/data']
const forbidden = ['正常', '异常', '偏高', '偏低', '发育迟缓', '必须接种', '应该治疗']

test('core pages do not expose diagnostic wording', async ({ page }) => {
  for (const route of routes) {
    await page.goto(route)
    const text = await page.locator('body').innerText()

    for (const word of forbidden) {
      expect(text, `${route} should not include ${word}`).not.toContain(word)
    }
  }
})
