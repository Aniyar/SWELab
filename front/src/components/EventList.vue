<template>
  <div v-for="event in eventList" :key="event.id">
    <event-card :event="event"/>
  </div>
</template>

<script lang="ts" setup>
import EventCard from "@/components/EventCard.vue";

const eventList = [
  {
    id: 1,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Sherkhan's Birthday Party",
  },
{
    id: 2,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 3,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 4,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 5,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 6,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 7,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  },
  {
    id: 8,
    title: "Case Club Event",
    date: "2021-10-01",
    time: "12:00",
    location: "Case Club",
    description: "Case Club Event",
  }
]
</script>
