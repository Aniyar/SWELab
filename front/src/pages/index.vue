<template>
  <div class="flex flex-column h-full">
<!--    <nav>-->
<!--      <v-tabs v-model="tab" class="bg-semi-light h-full" fixed-tabs>-->
<!--        <v-tab :ripple="false" value="following" class="text-none">Following</v-tab>-->
<!--        <v-tab :ripple="false" value="club" class="text-none">Club Events</v-tab>-->
<!--        <v-tab :ripple="false" value="open" class="text-none">Open Events</v-tab>-->
<!--      </v-tabs>-->
<!--    </nav>-->
<!--    <v-window v-model="tab" class="flex flex-column h-screen overflow-scroll scrollbar-autos">-->
<!--      <window-item tab="following" />-->
<!--      <window-item tab="club" />-->
<!--      <window-item tab="open" />-->
<!--    </v-window>-->
  </div>
</template>

<script lang="ts" setup>
import { ref } from "vue";
import WindowItem from "@/components/WindowItem.vue";

const tab = ref('open');
</script>
