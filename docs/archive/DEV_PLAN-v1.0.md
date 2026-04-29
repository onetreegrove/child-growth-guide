# 0-3岁成长发育 H5 开发计划与验收标准 v1.0

## 1. 文档信息

| 项目 | 内容 |
| --- | --- |
| 对应数据 | [child_growth_seed.sql](./child_growth_seed.sql) |
| 对应 UE | [UE-v1.0.md](./UE-v1.0.md) |
| 对应 UI | [ui-v1.0.html](./ui-v1.0.html)、[ui-v1.0.png](./ui-v1.0.png) |
| 强制技术栈 | TypeScript + Vue 3 + Tailwind CSS |
| 包管理器 | pnpm |
| 目标端 | 移动端 H5，优先适配微信内 WebView |
| MVP 主线 | 当前月龄自动匹配阶段 + 多维度跨阶段对比 |

## 2. 技术约束

### 2.1 必须使用

| 类型 | 技术 |
| --- | --- |
| 构建工具 | Vite |
| 前端框架 | Vue 3 |
| 开发语言 | TypeScript |
| 样式 | Tailwind CSS |
| 路由 | Vue Router |
| 状态管理 | Pinia 或 Vue Composition API store |
| 测试 | Vitest + Vue Test Utils，端到端可用 Playwright |
| 包管理器 | pnpm |

### 2.2 不建议引入

- 不引入重型 UI 组件库，避免 UI 受组件库风格限制。
- 不在前端运行 SQLite 引擎作为 MVP 必需能力。
- 不把 `child_growth_seed.sql` 直接作为运行时数据源。
- 不把静态 UI HTML 直接嵌入 Vue，应拆成组件和数据驱动页面。

### 2.3 数据落地策略

`child_growth_seed.sql` 是结构化数据来源。前端实现建议增加构建期转换脚本，将 SQL seed 转成 typed JSON 或 TS 模块：

```text
child_growth_seed.sql
  -> scripts/convert-seed.ts
  -> src/data/generated/*.json
  -> src/types/growth.ts
  -> src/services/growthService.ts
  -> Vue 页面和组件
```

MVP 可以把转换后的 JSON 打包进前端，后续再替换为接口请求。

## 3. 推荐目录结构

```text
web/
  package.json
  vite.config.ts
  tsconfig.json
  tailwind.config.ts
  postcss.config.js
  index.html
  scripts/
    convert-seed.ts
  src/
    main.ts
    App.vue
    router/
      index.ts
    stores/
      babyProfile.ts
      growth.ts
    services/
      growthService.ts
      stageMatcher.ts
    data/
      generated/
        datasetMeta.json
        stages.json
        dimensions.json
        growthMetrics.json
        contentItems.json
        developmentItems.json
        vaccineItems.json
        checkupItems.json
    types/
      growth.ts
      baby.ts
    components/
      AppShell.vue
      BottomNav.vue
      CurrentStageCard.vue
      MetricCard.vue
      DimensionSelector.vue
      CompareTable.vue
      CompareTextList.vue
      NoticeBar.vue
      BabyProfilePanel.vue
    pages/
      HomePage.vue
      StageListPage.vue
      StageDetailPage.vue
      CompareHomePage.vue
      CompareDetailPage.vue
      DimensionDetailPage.vue
      DataAboutPage.vue
```

## 4. 数据模型

### 4.1 SQL 表与前端模型映射

| SQL 表 | 前端类型 | 用途 |
| --- | --- | --- |
| `dataset_meta` | `DatasetMeta` | 数据版本、来源、更新时间 |
| `age_stage` | `AgeStage` | 阶段匹配、阶段列表、阶段详情 |
| `dimension` | `Dimension` | 多维对比入口、维度分类 |
| `growth_metric` | `GrowthMetric` | 体重、身高、头围跨阶段对比 |
| `content_item` | `ContentItem` | 睡眠、喂养、排便、常见问题等建议类内容 |
| `development_item` | `DevelopmentItem` | 动作、语言、认知、情绪社会性 |
| `vaccine_item` | `VaccineItem` | 疫苗参考信息 |
| `checkup_item` | `CheckupItem` | 体检参考信息 |
| `stage_raw_text` | `StageRawText` | 原文留存，MVP 不直接展示全文 |

### 4.2 TypeScript 类型要求

必须为核心数据定义显式类型，不允许页面直接使用 `any`：

```ts
export type Gender = 'all' | 'male' | 'female'
export type CompareRange = 'nearby' | 'all'

export interface AgeStage {
  id: string
  name: string
  displayName: string
  minDays: number
  maxDays: number
  sortOrder: number
  sourcePages: number[]
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
```

## 5. 路由范围

### 5.1 MVP 必做路由

| 路由 | 页面 | 优先级 | 说明 |
| --- | --- | --- | --- |
| `/` | `HomePage` | P0 | 首页当前阶段摘要 |
| `/stages` | `StageListPage` | P0 | 手动切换阶段 |
| `/stages/:stageId` | `StageDetailPage` | P0 | 阶段详情 |
| `/compare` | `CompareHomePage` | P0 | 多维对比入口 |
| `/compare/:dimensionKey` | `CompareDetailPage` | P0 | 单维度跨阶段对比 |
| `/dimensions/:dimensionKey` | `DimensionDetailPage` | P1 | 单维度详情 |
| `/about/data` | `DataAboutPage` | P0 | 数据说明与免责声明 |

### 5.2 MVP 暂不做独立页面

| 能力 | 处理方式 |
| --- | --- |
| 宝宝信息 | 先做首页内弹层或抽屉组件，不单独做复杂个人中心 |
| 搜索 | 后续版本 |
| 反馈 | 后续版本或占位外部联系方式 |
| 分享海报 | 后续版本 |
| 收藏/最近查看 | 后续版本 |

## 6. 组件拆分

| 组件 | 职责 | 关键 Props |
| --- | --- | --- |
| `AppShell` | 页面安全区、背景、最大宽度约束 | `title?` |
| `BottomNav` | 首页/对比/阶段三入口 | `active` |
| `CurrentStageCard` | 当前宝宝阶段卡片 | `profile`, `stage`, `ageText` |
| `BabyProfilePanel` | 昵称、出生日期、性别、本地保存 | `modelValue`, `visible` |
| `MetricCard` | 首页体重/身高/头围摘要 | `metric`, `gender` |
| `DimensionSelector` | 维度分组选择 | `dimensions`, `activeKey` |
| `CompareTable` | 生长指标跨阶段表格 | `rows`, `gender`, `currentStageId` |
| `CompareTextList` | 睡眠/喂养/发育文本对比 | `items`, `currentStageId` |
| `StageList` | 阶段列表和当前阶段高亮 | `stages`, `currentStageId` |
| `NoticeBar` | 医疗参考提示、缺失说明 | `type`, `text` |

## 7. 开发计划

### 阶段 0：工程初始化

目标：搭建 Vue + TS + Tailwind 工程。

任务：

- 使用 Vite 初始化 Vue 3 + TypeScript 项目。
- 使用 pnpm 安装和管理依赖，不使用 npm/yarn 生成锁文件。
- 接入 Tailwind CSS，配置移动端基础样式。
- 配置 Vue Router。
- 配置 ESLint/Prettier 或项目内等价格式化规则。
- 建立 `src/types`、`src/services`、`src/components`、`src/pages` 目录。

交付：

- `pnpm dev` 可启动。
- `pnpm build` 可通过。
- Tailwind 样式在 Vue 页面中生效。

### 阶段 1：数据转换与服务层

目标：把 SQL seed 转成前端可消费的 typed data。

任务：

- 编写 `scripts/convert-seed.ts`。
- 从 `child_growth_seed.sql` 提取以下数据：`dataset_meta`、`age_stage`、`dimension`、`growth_metric`、`content_item`、`development_item`、`vaccine_item`、`checkup_item`。
- 输出 JSON 到 `src/data/generated`。
- 定义 `src/types/growth.ts`。
- 实现 `stageMatcher.ts`：
  - `calculateAgeDays(birthDate, today)`
  - `formatBabyAge(ageDays)`
  - `matchStageByAgeDays(stages, ageDays)`
  - `getNearbyStages(stages, currentStageId, radius)`
- 实现 `growthService.ts`：
  - `getStages()`
  - `getStageDetail(stageId)`
  - `getDimensions()`
  - `getGrowthMetrics(metricKey, range, gender)`
  - `getTextCompareItems(dimensionKey, range)`

交付：

- 数据转换脚本可重复执行。
- 所有 generated JSON 可被 TypeScript import。
- 单元测试覆盖阶段匹配和相邻阶段计算。

### 阶段 2：首页与宝宝信息

目标：完成自动匹配当前阶段主路径。

任务：

- 实现 `BabyProfile` store，本地保存昵称、出生日期、性别。
- 实现 `HomePage`。
- 实现 `BabyProfilePanel`。
- 实现 `CurrentStageCard`。
- 实现 `MetricCard`。
- 首页展示当前阶段、体重、身高、头围、今日重点和医疗提示。
- 未填写出生日期时展示填写入口，同时允许手动选阶段。
- 出生日期超出 0-3 岁时展示提示，不阻断手动浏览。

交付：

- 填写出生日期后首页自动刷新当前阶段。
- 当前阶段可跳转阶段详情和多维对比。

### 阶段 3：阶段列表与阶段详情

目标：支持手动修正阶段和查看阶段完整信息。

任务：

- 实现 `StageListPage`。
- 实现 `StageDetailPage`。
- 阶段列表按 `sort_order` 排序。
- 当前宝宝阶段高亮。
- 阶段详情展示：
  - 阶段摘要
  - 生长指标
  - 营养喂养
  - 发育表现
  - 医疗保健
  - 数据来源与免责声明入口
- 阶段详情内的指标支持跳转对应维度对比。

交付：

- 手动切换阶段后，阶段列表、首页、对比页上下文一致。
- 阶段详情信息来自 seed 数据，不写死在页面里。

### 阶段 4：多维对比

目标：完成跨阶段多维数据对比主路径。

任务：

- 实现 `CompareHomePage`。
- 实现 `CompareDetailPage`。
- 实现 `DimensionSelector`。
- 实现 `CompareTable`。
- 实现 `CompareTextList`。
- 支持维度：
  - 生长指标：体重、身高、头围
  - 日常照护：睡眠、喂养、排便
  - 发育表现：动作、语言、认知、情绪社会性
  - 医疗保健：疫苗、体检、警示信号
- 生长指标支持 `全部/男孩/女孩`。
- 对比范围支持 `相邻阶段/全部阶段`。
- 当前宝宝阶段必须高亮。
- 对于 `male_min/male_max` 为空的增长指标，展示 `growth_rate`，不能展示空白。

交付：

- `/compare` 可选择维度。
- `/compare/weight`、`/compare/height`、`/compare/head_circumference` 可展示生长指标表格。
- `/compare/sleep`、`/compare/complementary_food`、`/compare/motor` 等文本类维度可展示阶段卡片。

### 阶段 5：维度详情与数据说明

目标：补足对比后的详情解释与可信度说明。

任务：

- 实现 `DimensionDetailPage`。
- 实现 `DataAboutPage`。
- 维度详情展示当前阶段数据、说明、缺失数据解释、跨阶段对比入口。
- 数据说明展示：
  - 数据集名称
  - 版本
  - 来源 PDF
  - 生成时间
  - 适用范围
  - 免责声明
- 所有医疗相关页面展示安全提示。

交付：

- 关键页面都可进入数据说明页。
- 文案不出现诊断式表达。

### 阶段 6：视觉还原与移动端适配

目标：用 Tailwind CSS 还原 `ui-v1.0.html` 的视觉方向。

任务：

- 建立 Tailwind 主题色：
  - 主色：`#0f8f85`
  - 深主色：`#08766e`
  - 背景：`#f4f7f6`
  - 线框：`#dde7e5`
  - 男孩蓝：`#2879d8`
  - 女孩红：`#ec675f`
- 统一卡片圆角、间距、阴影。
- 页面最大宽度按移动 H5 控制，桌面浏览居中展示。
- 适配 iPhone SE、iPhone 12/13/14、常见 Android WebView 宽度。
- 避免按钮文案溢出和表格横向挤压。

交付：

- 页面与 `ui-v1.0.png` 保持同一信息层级和视觉风格。
- 主流程在 375px 宽度下不出现文本互相覆盖。

### 阶段 7：测试与验收

目标：以自动测试和人工走查验证 MVP 可用。

任务：

- Vitest 覆盖数据服务和阶段匹配。
- Vue Test Utils 覆盖关键组件。
- Playwright 覆盖核心路径：
  - 填写出生日期并匹配阶段
  - 从首页进入阶段详情
  - 从首页进入多维对比
  - 体重对比切换性别
  - 对比范围切换相邻/全部
- 执行移动端截图检查。

交付：

- `pnpm typecheck` 通过。
- `pnpm test` 通过。
- `pnpm build` 通过。
- 核心页面截图无明显布局错乱。

## 8. 验收标准

### 8.1 工程验收

| 编号 | 标准 |
| --- | --- |
| A-001 | 项目必须基于 Vue 3 + TypeScript + Tailwind CSS 实现 |
| A-002 | 不允许页面核心数据写死在 Vue template 中，必须来自 SQL 转换后的 typed data |
| A-003 | 必须使用 pnpm 管理依赖，并提交 `pnpm-lock.yaml` |
| A-004 | 不应提交 `package-lock.json` 或 `yarn.lock` |
| A-005 | `pnpm build` 必须通过 |
| A-006 | `pnpm typecheck` 必须通过 |
| A-007 | 移动端 375px 宽度下核心页面无横向滚动和文字重叠 |

### 8.2 数据验收

| 编号 | 标准 |
| --- | --- |
| D-001 | `age_stage` 9 个阶段全部可展示 |
| D-002 | `dimension` 维度按 `dimension_group` 分组展示 |
| D-003 | 体重、身高、头围数据来自 `growth_metric` |
| D-004 | `growth_metric` 为空的阶段展示 `growth_rate`，不展示空白 |
| D-005 | 睡眠、喂养、排便等内容来自 `content_item` |
| D-006 | 动作、语言、认知、情绪社会性来自 `development_item` |
| D-007 | 疫苗和体检信息可作为医疗保健维度内容展示 |
| D-008 | 数据说明页展示 `dataset_meta.version`、`source_pdf`、`generated_at` |

### 8.3 阶段匹配验收

| 编号 | 标准 |
| --- | --- |
| S-001 | 输入合法出生日期后能计算宝宝年龄天数 |
| S-002 | 年龄天数能按 `age_stage.min_days/max_days` 匹配阶段 |
| S-003 | 2025-06-20 在 2026-04-28 应匹配到 `10_12m` 或等价的 10-12 个月阶段 |
| S-004 | 出生日期晚于当前日期时提示错误 |
| S-005 | 超出 0-3 岁范围时提示适用范围，但保留手动浏览入口 |
| S-006 | 手动切换阶段后，首页、阶段详情、对比页高亮阶段一致 |

### 8.4 首页验收

| 编号 | 标准 |
| --- | --- |
| H-001 | 首页首屏展示产品标题、数据说明入口、当前阶段卡片 |
| H-002 | 当前阶段卡片展示宝宝昵称、月龄、匹配阶段 |
| H-003 | 首页展示体重、身高、头围三个核心指标 |
| H-004 | 首页提供“查看阶段详情”和“多维度对比”两个主操作 |
| H-005 | 未填写出生日期时展示填写入口和手动选阶段入口 |
| H-006 | 首页展示医疗参考提示 |

### 8.5 宝宝信息验收

| 编号 | 标准 |
| --- | --- |
| B-001 | 支持昵称、出生日期、性别、本地保存 |
| B-002 | 出生日期必填，未填时不能保存匹配 |
| B-003 | 性别默认为 `全部` |
| B-004 | 本地保存开启后刷新页面仍能恢复宝宝信息 |
| B-005 | 修改出生日期后当前阶段重新计算 |

### 8.6 阶段列表与阶段详情验收

| 编号 | 标准 |
| --- | --- |
| ST-001 | 阶段列表按 `sort_order` 展示 9 个阶段 |
| ST-002 | 当前宝宝阶段有明确高亮 |
| ST-003 | 点击阶段可进入对应阶段详情 |
| ST-004 | 阶段详情展示生长指标、营养喂养、发育表现、医疗保健 |
| ST-005 | 阶段详情内可进入对应维度对比 |
| ST-006 | 阶段详情展示免责声明或可达数据说明 |

### 8.7 多维对比验收

| 编号 | 标准 |
| --- | --- |
| C-001 | `/compare` 展示生长指标、日常照护、发育表现、医疗保健分组 |
| C-002 | 生长指标至少包含体重、身高、头围 |
| C-003 | 文本建议至少包含睡眠、喂养、动作发展 |
| C-004 | `/compare/:dimensionKey` 默认高亮当前宝宝阶段 |
| C-005 | 生长指标对比支持全部/男孩/女孩切换 |
| C-006 | 对比范围支持相邻阶段/全部阶段切换 |
| C-007 | 相邻阶段展示当前阶段前后至少 1 个阶段，边界阶段可自动收缩 |
| C-008 | 点击阶段行或阶段卡片可进入阶段详情 |
| C-009 | 缺失数值时展示增长速度或缺失说明 |
| C-010 | 不出现“正常/异常/偏高/偏低”等诊断式判断文案 |

### 8.8 视觉验收

| 编号 | 标准 |
| --- | --- |
| V-001 | 整体视觉参考 `ui-v1.0.png`：浅背景、绿色主色、卡片式信息组织 |
| V-002 | 首页、阶段列表、阶段详情、多维对比、对比详情的布局结构与 UE 一致 |
| V-003 | 当前阶段高亮在首页、阶段列表、对比详情中保持一致 |
| V-004 | 男孩数值使用蓝色，女孩数值使用红色或等价明确区分 |
| V-005 | 按钮、卡片、筛选控件均使用 Tailwind CSS 实现 |
| V-006 | 不使用内联大段 CSS 复刻 `ui-v1.0.html`，应沉淀为 Tailwind class 或组件样式 |

### 8.9 医疗安全验收

| 编号 | 标准 |
| --- | --- |
| M-001 | 首页、生长指标详情、医疗保健相关页面有参考提示 |
| M-002 | 疫苗信息提示以当地接种单位和最新政策为准 |
| M-003 | 体检信息提示以当地儿保机构要求为准 |
| M-004 | 警示信号提示及时咨询医生或就医 |
| M-005 | 页面不输出诊断结论 |

## 9. 测试用例建议

### 9.1 单元测试

| 用例 | 输入 | 期望 |
| --- | --- | --- |
| 阶段匹配 10-12 月 | 出生日期 `2025-06-20`，当前日期 `2026-04-28` | 匹配 `10_12m` |
| 阶段边界 42 天 | 年龄天数 `42` | 匹配 `0_42d` 或按产品确认边界规则 |
| 阶段边界 43 天 | 年龄天数 `43` | 匹配 `42d_3m` |
| 超出未来日期 | 出生日期晚于当前日期 | 返回错误 |
| 相邻阶段 | 当前 `10_12m`，半径 1 | 返回 `7_9m`、`10_12m`、`13_18m` |
| 缺失指标 | `4_6m` 体重 | 展示 `growth_rate` |

### 9.2 端到端测试

| 用例 | 步骤 | 期望 |
| --- | --- | --- |
| 自动匹配 | 打开首页，填写出生日期，保存 | 首页显示 10-12 个月 |
| 阶段详情 | 首页点击查看阶段详情 | 进入 `/stages/10_12m` |
| 多维对比 | 首页点击多维度对比 | 进入 `/compare` |
| 体重对比 | 选择体重 | 当前阶段高亮，显示体重数据 |
| 性别切换 | 在体重对比切换女孩 | 表格展示女孩参考范围 |
| 全部阶段 | 切换全部阶段 | 显示 9 个阶段 |
| 文本对比 | 进入睡眠对比 | 展示不同阶段睡眠建议 |
| 数据说明 | 点击数据说明 | 展示版本和免责声明 |

## 10. 里程碑建议

| 里程碑 | 内容 | 建议验收方式 |
| --- | --- | --- |
| M1 | 工程初始化 + Tailwind + 路由 | `pnpm build` |
| M2 | SQL 转 JSON + 类型定义 + 服务层 | 单元测试 |
| M3 | 首页 + 宝宝信息 + 阶段匹配 | 本地浏览器走查 |
| M4 | 阶段列表 + 阶段详情 | 页面走查 + 数据核对 |
| M5 | 多维对比 + 维度详情 | E2E + 截图核对 |
| M6 | 数据说明 + 医疗安全文案 + 移动端适配 | 验收清单逐项确认 |
