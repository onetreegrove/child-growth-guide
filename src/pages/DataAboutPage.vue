<script setup lang="ts">
import AppHeader from '@/components/AppHeader.vue'
import NoticeBar from '@/components/NoticeBar.vue'
import { datasetMeta } from '@/services/growthService'
</script>

<template>
  <main class="page-shell">
    <AppHeader title="数据说明" back />
    <section class="card space-y-4">
      <div>
        <h2 class="text-lg font-extrabold">数据来源</h2>
        <p class="mt-1 text-sm text-muted">{{ datasetMeta.dataset_name }}</p>
        <p class="mt-1 text-sm text-muted">{{ datasetMeta.source_pdf }}</p>
      </div>
      <div>
        <h2 class="text-lg font-extrabold">当前数据版本</h2>
        <p class="mt-1 text-sm text-muted">v{{ datasetMeta.version }} · 生成时间 {{ datasetMeta.generated_at }}</p>
      </div>
      <div>
        <h2 class="text-lg font-extrabold">适用范围</h2>
        <p class="mt-1 text-sm text-muted">0-3岁儿童成长发育参考，内容用于育儿信息展示。</p>
      </div>
      <div>
        <h2 class="text-lg font-extrabold">免责声明</h2>
        <p class="mt-1 text-sm leading-relaxed text-muted">本工具仅供参考，不替代医生诊断。疫苗与体检安排以当地机构要求为准。</p>
      </div>
    </section>
    <NoticeBar class="mt-3" text="本工具仅供参考，不替代医生诊断。疫苗与体检安排以当地机构要求为准。" />
  </main>
</template>
