<template>
  <v-window-item v-if="!eventExists" :value="tab" class="h-full flex flex-col justify-center align-center text-[32px]">
    <p>{{tab}}</p>
    <p>No Events Yet</p>
  </v-window-item>
  <v-window-item v-else :value="tab" class="h-full flex gap-2 align-center flex-column overflow-y-scroll py-2 scrollbar-hidden !important">
    <event-list/>
  </v-window-item>
</template>

<script lang="ts" setup>
import { ref } from "vue";
import EventList from "@/components/EventList.vue";

const props = defineProps({
  tab: {
    type: String,
    required: true
  },
});

const eventExists = ref(
  props.tab !== "following"
);
</script>
