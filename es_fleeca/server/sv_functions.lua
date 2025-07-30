local QBCore = exports['qb-core']:GetCoreObject()

ES = ES or {}
ES.Functions = ES.Functions or {}

function ES.Functions.EnsureDatabaseTables()
    local query = [[
        CREATE TABLE IF NOT EXISTS bank_job_stats (
            identifier VARCHAR(255) PRIMARY KEY, 
            drops INTEGER DEFAULT 0       
        )
    ]]
    local exec = MySQL.rawExecute.await(query, {}, function(affectedRows)
        print("Ensured tables: " .. affectedRows)
    end)
    if (exec) then return true end
    return false
end

function ES.Functions.EnsureUserData(src) 
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license') 
    local doesExist = MySQL.single.await('SELECT * FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1', {
        identifier
    })

    if (not doesExist) then 
        MySQL.insert.await('INSERT INTO `bank_job_stats` (identifier, drops, total_payouts, last_used) VALUES (?, ?, ?, ?)', {
            identifier, 0, 0, 0
        })
    end
end

function ES.Functions.UpdateDrops()
    local src = source 
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local totalDrops = MySQL.query.await("SELECT `total_drops` FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    MySQL.rawExecute.await("INSERT INTO bank_job_stats (identifier, total_drops) VALUES (?, ?) ON DUPLICATE KEY UPDATE total_drops = VALUES(total_drops)", {
        identifier, (totalDrops[1].total_drops + 1)
    })
end

function ES.Functions.UpdateCash(src, payout) 
    local playerName = GetPlayerName(src) 
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local totalPayout = MySQL.query.await("SELECT `total_payouts` FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    MySQL.rawExecute.await("INSERT INTO bank_job_stats (identifier, total_payouts) VALUES (?, ?) ON DUPLICATE KEY UPDATE total_payouts = VALUES(total_payouts)", {
        identifier, (totalPayout[1].total_payouts + payout)
    })

    Utils.DiscordLog("log_green", playerName.. " was awarded: $".. payout.. " from completing a Fleeca delivery job.")
end

function ES.Functions.InitJobTimer(src, minutes) 
    Player(src).state:set("timer", 0, true)

    CreateThread(function() 
        while (minutes > 0) do 
            minutes = minutes - 60000
            Player(src).state:set("timer", math.floor(minutes / 60000), true)  
            Wait(60000)
        end
        TriggerClientEvent('QBCore:Notify', src, "Job has ended...", 'error', 3000)
        TriggerEvent("es_fleeca:server:forceTerminateJob", src)
    end)
end

local function getRandomIndexes(checkpoints, count) 
    local indexes = {}
    for i = 1, #checkpoints do 
        table.insert(indexes, i)
    end

    for i = #indexes, 2, -1 do 
        local j = math.random(1, i)
        indexes[i], indexes[j] = indexes[j], indexes[i]
    end

    local result = {}
    for i = 1, count do 
        table.insert(result, indexes[i])
    end

    return result
end

function ES.Functions.StartJob(src)
    local initialDrops = Config.MaxDrops
    local initialPayout = 0 

    Player(src).state:set("location", "None", true) -- fix this state bag not updating
    Player(src).state:set("payout", initialPayout, true)
    Player(src).state:set("drops", initialDrops, true)
    Player(src).state:set("deliveryCheckpoints", Config.DeliverCheckpoints)

    while (Player(src).state.drops ~= 0) do 
        ES.Functions.RequestDropCheckpoint(src)

        if (Player(src).state.drops == 0) then 
            ES.Functions.ReturnDeliveryTruck(src)
        end
    end
end

function ES.Functions.RequestDropCheckpoint(src)
    local deliveryCheckpoints = Player(src).state.deliveryCheckpoints 
    local randIndexes = getRandomIndexes(deliveryCheckpoints, 1) 
    local randIndex = randIndexes[math.random(1, #randIndexes)] -- redundant

    print("The current location is".. deliveryCheckpoints[randIndex].location)

    Player(src).state:set("location", deliveryCheckpoints[randIndex].name, true)
    Player(src).state:set("currentVector", deliveryCheckpoints[randIndex].location, true)

    local currentDrops = Player(src).state.drops

    TriggerClientEvent("es_fleeca:setGps", src, deliveryCheckpoints[randIndex].location.x, deliveryCheckpoints[randIndex].location.y)
    Wait(500) -- bandaid fix to some problem idk what the fuck it is. 
    TriggerClientEvent("es_fleeca:createTarget", src, {coords = (deliveryCheckpoints[randIndex].location)})

    while (currentDrops == Player(src).state.drops) do 
        Wait(100)
    end
    table.remove(deliveryCheckpoints, randIndex)
    Player(src).state:set("deliveryCheckpoints", deliveryCheckpoints, true)
    print(json.encode(Player(src).state.deliveryCheckpoints))
    print("done")
    return
end

function ES.Functions.ReturnDeliveryTruck(src)
    Player(src).state:set("location", "Return the delivery truck!", true)
    TriggerClientEvent("es_fleeca:setGps", src, Config.DeliveryReturn.x, Config.DeliveryReturn.y)
    

    TriggerClientEvent("es_fleeca:return", src)
end
