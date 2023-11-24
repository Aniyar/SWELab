<template>
  <v-card width="90vw" class="bg-brown py-2 ">
    <v-card-title>
      <h1 class="text-[32px]">{{ event.title }}</h1>
    </v-card-title>
    <v-card-text>
      <p class="text-[24px]">{{ event.description }}</p>
    </v-card-text>
    <v-card-subtitle>
      <h2 class="text-[18px]">{{ event.date }}</h2>
      <h2 class="text-[18px]">{{ event.time }}</h2>
      <h2 class="text-[18px]">{{ event.location }}</h2>
    </v-card-subtitle>
  </v-card>
</template>

<script lang="ts" setup>
const props = defineProps({
  event: {
    type: Object,
    required: true
  }
});
</script>
