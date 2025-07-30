<template>
    <!--Fix spacing in between progress bars and icons for resizeablity-->
    <div class="main-container">
        <h2 class="time-clock">{{ hour }}:{{ minute }}</h2>
        <div class="health-container">
            <div class="progress-shield">
                <img id="health-img" src="../assets/health-bar-main.png">
            </div>
            <v-progress-linear height="13vh" id="progress-bar" :model-value="health" :max="200" color="#0DFF00"></v-progress-linear>
        </div>
    </div>
</template>
<script setup lang="ts">

defineProps({
    visible: Boolean, 
    health: Number,
    hour: Number, 
    minute: Number
})

</script>
<style scoped>  
:root {
    --health-bar-color: #0DFF00;
}

.time-clock {
    color: #0DFF00;

    font-size: 170%;
    position: absolute; 
    top: 91%; 
    right: 80%;
    left: 1.8%;
    bottom: 10%;
    margin: auto;
}

#health-img {
    position: absolute;
    width: 130.5%;
    max-width: 500%;
    height: auto;
}
.health-container {
    position: absolute; 
    top: 90%; 
    right: 85%;
    left: 1%;
    bottom: 0%;
    margin: auto;
}

.progress-shield {
    border-radius: 20px;
    box-shadow: none;
    max-width: 500%;
    width: 100%;
    position: absolute;
 
    top: 29%;
    right: -5.8%;
}

#progress-bar {
    position: absolute;
    margin: auto;

    top: 0; 
    right: 0%;
    left: 10.2%;
    bottom: -0.7vh; 

    width: 122%;
}
</style>
