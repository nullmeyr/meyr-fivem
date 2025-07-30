import { Logger, Utils } from "../utils/utils"

var firstSpawn = true; 

on("playerSpawned", () => {
    if (firstSpawn) 
    {
        setTimeout(() => { 
            if (firstSpawn)
            {
                emitNet("the-forged:player:spawned"); 
                console.log("fired");
                firstSpawn = false; 
            }
        }, 3000);
        return; 
    }
});