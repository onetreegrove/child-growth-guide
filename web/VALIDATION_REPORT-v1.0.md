# 0-3岁成长发育 H5 验收报告 v1.0

## 1. 验收范围

本次验收覆盖 `DEV_PLAN-v1.0.md` 的 MVP 主线：

- 当前月龄自动匹配阶段。
- 首页当前阶段摘要。
- 阶段列表与阶段详情。
- 多维度跨阶段对比。
- 维度详情与数据说明。
- 医疗安全文案基础审计。
- 移动端多视口截图检查。

## 2. 命令验证

| 命令 | 结果 |
| --- | --- |
| `pnpm typecheck` | 通过 |
| `pnpm test` | 通过，3 个测试文件，7 个单元测试 |
| `pnpm build` | 通过 |
| `pnpm e2e` | 通过，6 个 E2E/视觉测试 |

## 3. 单元测试覆盖

| 文件 | 覆盖点 |
| --- | --- |
| `src/test/stageMatcher.test.ts` | 出生日期计算、10-12 个月阶段匹配、未来日期错误、相邻阶段 |
| `src/test/growthService.test.ts` | 9 个阶段加载、缺失指标展示增长速度、女孩参考范围 |
| `src/test/medicalCopy.test.ts` | 展示文案中的诊断式词汇替换 |

## 4. E2E 覆盖

| 文件 | 覆盖点 |
| --- | --- |
| `e2e/mvp.spec.ts` | 填写出生日期并匹配阶段、首页到阶段详情、首页到多维对比、体重对比性别切换、全部阶段切换、睡眠对比、数据说明 |
| `e2e/medical-copy.spec.ts` | 核心页面不暴露 `正常`、`异常`、`偏高`、`偏低`、`发育迟缓`、`必须接种`、`应该治疗` 等诊断式或命令式词汇 |
| `e2e/visual.spec.ts` | 7 个核心页面在 3 个移动端视口下截图 |

## 5. 视觉截图

已生成 21 张多视口截图：

- 视口：`iphone-se`、`iphone-12`、`android-wide`
- 页面：`home`、`compare`、`compare-weight`、`compare-sleep`、`stages`、`stage-detail`、`data-about`
- 输出目录：`test-results/visual-captures-MVP-pages-across-mobile-viewports-mobile-chrome/`

关键截图示例：

- `test-results/visual-captures-MVP-pages-across-mobile-viewports-mobile-chrome/visual-iphone-12-home.png`
- `test-results/visual-captures-MVP-pages-across-mobile-viewports-mobile-chrome/visual-iphone-12-compare-weight.png`
- `test-results/visual-captures-MVP-pages-across-mobile-viewports-mobile-chrome/visual-iphone-se-home.png`
- `test-results/visual-captures-MVP-pages-across-mobile-viewports-mobile-chrome/visual-android-wide-stage-detail.png`

## 6. 医疗安全审计

### 已做处理

- 增加 `src/services/medicalCopy.ts`，对展示层文案做诊断式词汇替换。
- 数据说明页增加明确的 `免责声明` 区块。
- 首页、对比详情、维度详情、阶段详情、数据说明页保留参考提示。
- E2E 对核心页面执行禁用词扫描。

### 审计结论

MVP 核心页面未暴露以下禁用表达：

- `正常`
- `异常`
- `偏高`
- `偏低`
- `发育迟缓`
- `必须接种`
- `应该治疗`

说明：原始 seed 数据中仍保留来源原文词汇，当前只在展示层净化。后续如果做“原文依据”页面，需要单独设计“原文引用”和“产品解释”两套文案口径，避免误把来源原文当成产品判断。

## 7. 包管理验收

| 项 | 结果 |
| --- | --- |
| 包管理器 | pnpm |
| 锁文件 | `pnpm-lock.yaml` |
| 不应出现 | 未发现 `package-lock.json` 或 `yarn.lock` |

## 8. 剩余范围

以下不属于当前 MVP 或仍需后续版本继续：

- 搜索。
- 反馈提交与反馈记录。
- 数据更新。
- 分享海报和成长卡。
- 收藏、最近查看。
- 原文依据页面。
- 更细的视觉像素级还原。
- 服务端 API 化和远程数据发布。

