<script setup lang="ts">
defineProps<{
  text: string
  mark?: string
}>()
</script>

<template>
  <div class="notice flex gap-2">
    <strong>{{ mark ?? 'i' }}</strong>
    <span>{{ text }}</span>
  </div>
</template>
