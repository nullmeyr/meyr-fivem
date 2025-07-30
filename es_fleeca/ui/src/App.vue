<template>
  <v-app>
    <v-main>
      <DisplayHUD/>
      <FleecaJob />
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
import FleecaJob from './components/FleecaJob.vue';
import DisplayHUD from './components/DisplayHUD.vue'

</script>

<style>
html {
  overflow: hidden;
}

body {
  background: transparent !important;
}


</style>