# Child Growth Guide

本仓库仅保留 Web 前端工程。原 `web/` 目录内容已经提升到项目根目录，历史 PRD、UE、开发计划、验收报告、种子 SQL 和 UI 截图统一归档到 `docs/archive/`。

## 常用命令

```bash
pnpm install
pnpm run dev
pnpm run build
pnpm run test
pnpm run e2e
```

## 目录说明

- `src/`：Vue 3 前端源码、页面、组件、状态、服务和测试。
- `e2e/`：Playwright 端到端测试。
- `scripts/`：构建期辅助脚本，例如从归档 SQL 生成前端 JSON 数据。
- `docs/archive/`：历史需求、UE、开发计划、验收报告和原始数据资料。
- `docs/archive/assets/`：历史 UI 截图和视觉稿资源。
