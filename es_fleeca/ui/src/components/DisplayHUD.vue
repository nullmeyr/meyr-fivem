<script setup lang="ts">
const fleecaLogo = new URL('../assets/fleeca.png', import.meta.url).href;
import Axios from '@/api/axios';
import { ref }  from 'vue' 

var open = ref(false);
var timer = ref("")
var drops = ref("");
var location = ref(""); 
var payout = ref(""); 

function resetState() {
  // test 
}

window.addEventListener("message", (event) => {
  let response = event.data;

  if (response.hudStatus === "open") {
    open.value = true; 
  } else if (response.hudStatus === "reset") {
    open.value = false; 
    timer.value = "N/A";
    drops.value = "N/A"; 
    location.value = "N/A"; 
    payout.value = "N/A"; 
  }

  if (response.state === "setValues") {
    if (response.timer) {
      timer.value = response.timer; 
    }
    if (response.drops) {
        drops.value = response.drops;
    }
    if (response.location) {
        location.value = response.location;
    }
    if (response.payout) {
        payout.value = response.payout;
    }
  }
});

</script>

<template>
<Transition name="fade">
    <div class="main-container" v-show="open">
        <div class="header-image">
            <img style="width: calc(50%);" :src="fleecaLogo">
            <hr style="width: calc(50%);">
        </div>
        <div class="info">
            <p>Time Left: <span style="color: #27AE60;"> {{ timer }} Minutes</span> </p> 
            <p>Drops Left: <span style="color: #27AE60;"> {{ drops }} </span> </p> 
            <p>Current Objective: <span style="color: #27AE60;"> {{ location }} </span></p> 
            <p>Current Payout: <span style="color: #27AE60;"> ${{ payout }} </span></p> 
        </div>
    </div>
</Transition>
</template>

<style scoped>
html, body {
    background: transparent;
}

p {
    color: #F4F4F4;
    font-size: 0.78vw;
    margin-bottom: 1vh;
    padding: 1px;
}

hr {
  display: block;
  margin-top: 0.5em;
  margin-bottom: 0.5em;
  margin-left: auto;
  margin-right: auto;
  border-style: inset;
  border-width: 1px;
  color: #F4F4F4;

  width: 20%;
}


.header-image {
    position: relative;

    margin-bottom: 2vh;
}

.info {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    gap: 0.5rem;
}

.main-container {
    position: absolute;

    top: 50%;
    left: 70%;
    transform: translate(100%, -50%);

    width: 14vw;
    height: auto;

    background-color: rgba(26, 26, 26, 0.6); 
    border-radius: 1rem;
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);

    text-align: center;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 2.5s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>