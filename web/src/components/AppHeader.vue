<script setup lang="ts">
defineProps<{
  title: string
  back?: boolean
  actionText?: string
}>()

const emit = defineEmits<{
  action: []
}>()
</script>

<template>
  <header class="mb-4 flex h-11 items-center justify-between gap-3">
    <button
      v-if="back"
      class="grid h-9 w-9 place-items-center rounded-full border border-line bg-white text-xl font-extrabold"
      type="button"
      @click="$router.back()"
    >
      ‹
    </button>
    <div v-else class="w-9" />
    <h1 class="min-w-0 flex-1 text-center text-xl font-extrabold tracking-normal">{{ title }}</h1>
    <button v-if="actionText" class="w-16 text-right text-sm font-bold text-brand-dark" type="button" @click="emit('action')">
      {{ actionText }}
    </button>
    <div v-else class="w-16" />
  </header>
</template>
