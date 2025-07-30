<script setup lang="ts">
import Axios from '@/api/axios';
import { ref } from 'vue';
import soundFile from '../assets/click.mp3';

const fleecaLogo = new URL('../assets/fleeca.png', import.meta.url).href;
const audio = new Audio(soundFile);

var open = ref(false);
var playerName = ref(""); 
var groupNames = ref<string[]>([])
var cash = ref("")
var drops = ref("")
var loading = ref(false)

function resetState() {
  open.value = false
  groupNames.value = []

}

function click() {
  audio.currentTime = 0;
  audio.volume = 1;
  audio.play();
}

var searchBox = ref(false); 
function handleSearch() {
  searchBox.value = !searchBox.value;
}

function close() {
  Axios.post("fleeca:ui:close"); 
  open.value = false; 
}

function searchPlayer() {
  if ((groupNames.value).length < 5) {
    (groupNames.value).push(playerName.value);
  } else return;
      
  console.log(playerName.value);
}

function startJob() {
  Axios.post("fleeca:start"); 
  close();
}

function kick(index: number) {
  (groupNames.value).splice(index, 1);
}

window.addEventListener('keydown', (e: KeyboardEvent) => {
  if (e.key === "Escape") {
    console.log("UI Closed");
    close();
  }
})

var leaderName = ref(""); 
window.addEventListener("message", (event) => {
  let response = event.data;

  switch (response.action) {
    case ("open"): {
      loading.value = true;
      setTimeout(() => {
        loading.value = false;
        open.value = true
      }, 2000);

      leaderName.value = response.name; 

      var money = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
      });
      cash.value = money.format(response.cash);

      var commaFormat = new Intl.NumberFormat('en-US');
      drops.value = commaFormat.format(response.drops);
      break;
    }
    case ("reset"): {
      resetState()
      break;
    }
  }
});
// Load players based on callback response
</script>
<template>
<Transition >
  <v-app  >
    <v-overlay
      :model-value="loading"
      persistent
      opacity="0.9"
      class="d-flex align-center justify-center loading-overlay"
    >
    <div class="d-flex flex-column align-center justify-center fill-height">
      <h1 id="title"> <img style="width: 90%; z-index: 0; opacity: 80%;" :src="fleecaLogo"> </h1>
      <v-progress-circular
        indeterminate
        size="64"
        color="green"
        width="6"
      />
    </div>
    </v-overlay>


<div class="nui-wrapper" v-show="open" v-if(!loading)>
    <div class="test">
      <div class="heading">
        <h1 id="title"> <img style="transform: translate(-3.5vw, 1vh); width: 10%; z-index: 0; opacity: 80%;" :src="fleecaLogo"> </h1>
        <p id="title" style=""></p>
      </div>
      <div class="views">
        <div class="group-container">
          <div style="position: relative;">
            <h1 style="transform:">Players:</h1>
            <hr style=" position: relative; width: calc(10vw);">
          </div>
          <div class="players">
            <p>{{ leaderName }} (You)<v-icon title="Group Leader" style="color: #C9E957; ">mdi-crown</v-icon></p>
          </div>
          <div v-for="(name, index) in groupNames" :key="index" class="players">
              <p>{{ name }}</p>
              <div id="action">
                <v-btn @click="() => { click(); kick(index);}" title="Kick Member" style="background-color: rgba(231, 76, 60, 0.46); color: transparent; width: calc(0.5vw); height: calc(3vh)"><v-icon >mdi-karate</v-icon></v-btn>
              </div>
          </div>
        </div>
        <div class="containers">
          <div style="position: relative;">
            <h1 style="transform:">Information:</h1>
            <hr style=" position: relative; width: calc(10vw);">
          </div>
          <div class="info-container">
            <h1>Statistics:</h1>
            <hr style=" position: relative; margin-bottom: 2vh; transform: translate(0vw, 0vh); width: calc(5vw);">
            <h2 style="margin-bottom: 2vh;">Total Money Earned: {{ cash }}</h2>
            <h2 style="margin-bottom: 2vh;">Total Drops:  {{ drops }}</h2>
          </div>
            <div class="container-actions">
            <v-btn @click="() => { click(); startJob(); }" title="Start" style="margin-bottom: 1vh; transform: translate(0vw, -0vh); background-color: rgba(33, 118, 53, 0.46); border: 1px solid rgba(33, 118, 53); color: transparent; width: calc(10vw); height: calc(5vh)"><p>Start</p></v-btn>
             <!-- <v-icon>mdi-magnify</v-icon> -->
            <v-btn @click="() => { click(); /*handleSearch();*/ }" title="Kick Member" style="margin-bottom: 1vh; transform: translate(0vw, -0vh); background-color: rgba(31, 64, 70, 0.46); border: 1px solid rgba(31, 64, 70); color: transparent; width: calc(10vw); height: calc(5vh)"><p>Multiplayer SOON!</p></v-btn>
            <v-text-field v-show="searchBox" v-model="playerName" style="width: calc(11vw); color: #f4f4f441;" @keydown.enter="searchPlayer" label="Player Name"></v-text-field>
          </div>
        </div>
      </div>
    </div>
  </div>
</v-app>
</Transition>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900');

* {
  font-family: 'Orbitron', 'Eurostile', 'BankGothic', sans-serif;
  font-weight: 380;
  color: rgba(255, 255, 255, 0.8);
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

v-icon {
  color: #F4F4F4;
}

.v-input,
.v-input:focus-within {
  background-color: transparent !important;
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

.v-enter-active,
.v-leave-active {
  transition: opacity 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}

.loading-overlay {
  background: rgba(0, 0, 0, 0) !important;
}

:root {
  /* Fleeca Primary Colors  */
  --fleeca-green: #2ECC71;
  --fleeca-green-dark: #27AE60;
  --fleeca-red: #e74d3c;

  /* Background & Neutral  */
  --fleeca-bg-dark: #1A1A1A;
  --fleeca-gray: #3C3C3C;
  --fleeca-gray-light: #BFBFBF;
  --fleeca-white: #F4F4F4;

  /* Utility Gradient (Optional)  */
  --fleeca-gradient-green: linear-gradient(135deg, #2ECC71, #27AE60);
}

.nui-wrapper {
  position: absolute;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden;
  border: 1px solid rgba(26, 26, 26, 0.49);
  background-color: #1a1a1a89;
}

#logo {
  position: relative;

  width: 50%;
  transform: translate(43%, 0%);
}

.no-hover {
  position: relative;
  color: #f4f4f460;
  background-color: #e74d3c00 !important;
  border-radius: 100%;
}

.heading {
  position: relative;
  transform: translate(-40%, 0%);
  top: 4%;

  padding-bottom: 5%;
}

#title {
  position: relative;

  font-size: calc(1.35vh + 1.35vw);
  display: flex;
  justify-content: center;
  transform: translate(0%, -3vh);
}

#action {
  padding: calc(2%);
}

.views {
  display: flex;
  justify-content: space-between;
  gap: 1%;
  align-items: center;

  padding: 0 24vw;

}

.players {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 22.625vw;
  height: 5.78vh;

  background: rgba(33, 118, 53, 0.46);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(46, 204, 113, 0.49);  

  margin-bottom: 0.3vh;

  padding-left: calc(2%);
  margin: calc(1%);

}

.group-container {
  width: 25.625vw;
  height: 60.78vh;
  border-radius: 5px;
  font-size: calc(0.5vh + 0.5vw);
  text-align: center;

  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;



  background: linear-gradient(180deg,rgba(31, 96, 46, 0.50) 1%, rgba(31, 96, 46, 0.01) 100%);

}

.containers {
  width: 25.625vw;
  height: 60.78vh;
  border-radius: 5px;
  font-size: calc(0.5vh + 0.5vw);
  text-align: center;

  display: flex;
  flex-direction: column;

  align-items: center;

  background: linear-gradient(180deg,rgba(31, 96, 46, 0.50) 1%, rgba(31, 96, 46, 0.01) 100%);
}

.info-container {
  width: 20.625vw;
  height: 14.58vh;
  border-radius: 10px;
  font-size: calc(0.34vh + 0.34vw);
  text-align: center;

  display: flex;
  flex-direction: column;

  margin-top: 1vh;
  
  background: rgba(33, 118, 53, 0.46);
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(9.1px);
  -webkit-backdrop-filter: blur(9.1px);
  border: 1px solid rgba(46, 204, 113, 0.49);
}

.container-actions {
  display: flex;
  flex-direction: column;
  width: 20.625vw;
  height: auto;
  border-radius: 10px;
  font-size: calc(0.5vh + 0.5vw);

  margin-top: 5%;

  text-align: center;
  align-items: center;
  justify-content: center;
  
}

.test {
  width: 100%;
  height: 100%;
  z-index: 1;
  background: transparent;
  border-radius: inherit;
}
</style>