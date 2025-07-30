local QBCore = exports['qb-core']:GetCoreObject()

-- Initilizations
AddEventHandler('onServerResourceStart', function(resName)
    if (GetCurrentResourceName() == resName) then 
        if (ES.Functions.EnsureDatabaseTables()) then 
            print("^2[es_fleeca] | Started without errors...^0")  
        end
    end
end)

AddEventHandler("playerJoining", function()
    local src = source

    ES.Functions.EnsureUserData(src) 
end)

-- Gameplay Events
RegisterNetEvent("es_fleeca:server:startJob", function(data)
    local src = source
    local jobTime = (Config.JobTimer) * 60000

    ES.Functions.InitJobTimer(src, jobTime)
    ES.Functions.StartJob(src)
end)

RegisterNetEvent("es_fleeca:finalJobCleanUp", function()
    Player(source).state:set("currentVector", nil, true)

    Player(source).state:set("timer", nil, true)
    Player(source).state:set("drops", nil, true)
    Player(source).state:set("location", nil, true)
    Player(source).state:set("payout", nil, true)

    Player(src).state:set("deliveryCheckpoints", Config.DeliverCheckpoints) 
end)

RegisterNetEvent("es_fleeca:cooldown", function(source)
    local src = source 
    local currentTime = os.time()
    local playerName = GetPlayerName(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    print(identifier)

    MySQL.insert.await('UPDATE `bank_job_stats` SET last_used = ? WHERE identifier = ?', {
        currentTime, identifier
    })
    
    Utils.DiscordLog("log_green", playerName .. " is now on cooldown for: ".. SV_Config.Cooldown.. " minutes!")
end)


-- Gameplay vehicle
RegisterNetEvent("es_fleeca:server:forceTerminateJob", function(src)
    local name = GetPlayerName(src)
    
    Player(src).state:set("currentVector", nil, true)

    Player(src).state:set("timer", nil, true)
    Player(src).state:set("drops", -1, true)
    Player(src).state:set("location", nil, true)
    Player(src).state:set("payout", nil, true)

    Player(src).state:set("deliveryCheckpoints", Config.DeliverCheckpoints)  
    
    Wait(100)

    TriggerClientEvent("es_fleeca:resetClientJobState", src)
end)

RegisterNetEvent("es_fleeca:server:trackVehicle", function(netId)
    local src = source
    CreateThread(function()
        while (true) do 
            local veh = NetworkGetEntityFromNetworkId(netId)
            local engineHealth = GetVehicleEngineHealth(veh)

            if (engineHealth <= 0) then 
                -- kill job loop, no player reward
                TriggerEvent("es_fleeca:server:forceTerminateJob", src)

                -- Utils.DiscordLog("log_red", "The delivery vehicle spawned by [" .. GetPlayerName(src) .. "] was destroyed!\n Action(s): Job Terminated, No Client Reward.")
                break
            end

            Wait(500)
        end
    end)
end)

