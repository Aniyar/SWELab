import { defineStore } from 'pinia'
import { state } from "@/store/state"
import { actions } from "@/store/actions"

export const useStore = defineStore('dataStore', {
  state: () => ({...state}),
  actions: actions,
});
