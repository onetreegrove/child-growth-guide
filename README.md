# Child Growth Guide

0-3 岁儿童成长发育指南 H5 前端。项目基于结构化儿童成长数据，提供阶段浏览、成长指标对比、喂养护理、发育表现、疫苗体检和数据来源说明等页面。

这是一个纯 Web 前端仓库，使用 Vue 3、Vite、TypeScript、Pinia、Vue Router 和 Tailwind CSS 实现。

## 功能范围

- 首页：根据宝宝资料展示当前阶段和核心成长信息。
- 阶段列表：浏览 0-3 岁全部年龄阶段。
- 阶段详情：查看当前阶段的营养、护理、医疗、发育、疫苗和体检内容。
- 多维对比：按体重、身高、头围、睡眠、喂养、发育、疫苗、体检等维度跨阶段对比。
- 数据说明：展示数据集版本、来源和生成信息。

## 技术栈

- Vue 3
- TypeScript
- Vite
- Pinia
- Vue Router
- Tailwind CSS
- Vitest
- Playwright

## 环境要求

- Node.js 22
- pnpm 9

## 本地开发

```bash
pnpm install
pnpm run dev
```

默认开发服务由 Vite 启动。若 `5173` 被占用，Vite 会自动使用下一个可用端口。

## 常用命令

```bash
pnpm run convert:data
pnpm run test
pnpm run typecheck
pnpm run build
pnpm run e2e
pnpm run preview
```

命令说明：

- `convert:data`：从 `docs/archive/child_growth_seed.sql` 生成前端 JSON 数据。
- `test`：运行 Vitest 单元测试。
- `typecheck`：运行 TypeScript 类型检查。
- `build`：类型检查并生成生产构建产物到 `dist/`。
- `e2e`：启动本地 Vite 服务并运行 Playwright 测试。
- `preview`：预览生产构建结果。

## 数据生成

运行时数据位于 `src/data/generated/`，由归档 SQL 生成：

```bash
pnpm run convert:data
```

数据转换脚本是 `scripts/convert-seed.ts`。如果修改了 `docs/archive/child_growth_seed.sql`，需要重新执行数据转换，并检查生成的 JSON 是否符合预期。

## 目录结构

```text
.
├── .github/workflows/          # GitHub Actions
├── docs/archive/               # 历史 PRD、UE、验收报告、种子 SQL 和 UI 资源
├── e2e/                        # Playwright 端到端测试
├── scripts/                    # 构建期辅助脚本
├── src/
│   ├── components/             # 通用 UI 组件
│   ├── data/generated/         # 构建期生成的 JSON 数据
│   ├── pages/                  # 路由页面
│   ├── router/                 # Vue Router 配置
│   ├── services/               # 数据查询、阶段匹配和文案处理逻辑
│   ├── stores/                 # Pinia 状态
│   ├── test/                   # 单元测试
│   └── types/                  # TypeScript 类型定义
└── dist/                       # 本地构建产物，未提交
```

## 主要路由

- `/`：首页
- `/stages`：阶段列表
- `/stages/:stageId`：阶段详情
- `/compare`：多维对比首页
- `/compare/:dimensionKey`：维度对比详情
- `/dimensions/:dimensionKey`：单维度详情
- `/about/data`：数据说明

## CI 与发布

GitHub Actions 配置在 `.github/workflows/build-and-release.yml`。

- 推送到 `main` 或向 `main` 发起 PR 时，会安装依赖、运行单测并编译。
- 推送 `v*` tag 时，会在编译通过后创建或更新 GitHub Release，并上传 `child-growth-guide-<tag>.tar.gz`。

发布示例：

```bash
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```
