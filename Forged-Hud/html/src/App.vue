<template>
  <v-app theme="dark">
    <Health :hour=newHour :minute=newMinute :health=newHealth :visible="true"></Health>
  </v-app>
</template>

<script setup>
import { h, ref } from "vue";
import Health from "./components/Health.vue";

const isVisible = ref(false); 
const newHealth = ref(200); 
const newHour = ref(0);
const newMinute = ref(0);

// Perhaps another way this can be done ? 
window.addEventListener('message', (event) => {
  let health = event.data.health; 
  let hour = event.data.hour; 
  let minute = event.data.minute; 
  if (health) {
    newHealth.value = health;
  }

  if (minute) {
    newMinute.value = minute;
    newHour.value = hour; 
    console.log(newMinute.value) 
  }
})

</script>

<style>
::-webkit-scrollbar {
  width: 0;
  display: inline !important;
}
.v-application {
  background: rgba(255,255,255,0) !important;
}

:root {
  color-scheme: none !important;
}
</style>
