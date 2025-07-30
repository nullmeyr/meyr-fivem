local QBCore = exports['qb-core']:GetCoreObject()

-- NUI Getters for client requests
lib.callback.register('es_fleeca:nui:getTotalMoney', function(source)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local totalPayout = MySQL.query.await("SELECT `total_payouts` FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    if (totalPayout) then 
        return totalPayout[1].total_payouts
    end
    return false
end)

lib.callback.register('es_fleeca:nui:getTotalDrops', function(source)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local totalDrops = MySQL.query.await("SELECT `total_drops` FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    if (totalDrops) then 
        return totalDrops[1].total_drops
    end
    return false
end)

-- Job Logic Callbacks 
lib.callback.register('es_fleeca:searchPlayerName', function(name)
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do 
        local player = QBCore.Functions.GetPlayer(playerId)
        if player and player.PlayerData.name:lower() == name:lower() then 
            return true
        end
    end
end)

lib.callback.register('es_fleeca:requestPlayerDrop', function(source)
    local entityCoords = GetEntityCoords(GetPlayerPed(source)) 
    local playerName = GetPlayerName(source)
    local identifier = GetPlayerIdentifierByType(source, 'license') 

    if (#(entityCoords - Player(source).state.currentVector) > 5.0) then 
        Utils.DiscordLog("log_red", playerName.. " performed an impossible drop. This is likely the cause of a **LUA executor**.\n Action(s): Mission halted.")
        DropPlayer(source, "Impossible money drop.\nThis action has been logged.\n If you think this was a mistake, please speak with staff.")
        
        return false 
    end

    if (Player(source).state.drops ~= 0) then 
        Player(source).state:set("drops", Player(source).state.drops - 1, true)
        Player(source).state:set("payout", Player(source).state.payout + math.random(SV_Config.CashPerDrop.min, SV_Config.CashPerDrop.max), true)
        
        ES.Functions.UpdateDrops()

        return true
    end
end)

lib.callback.register("es_fleeca:truckReturned", function(source, data)
    local requestedCoords = data.truckCoords -- check client response coords
    local compareDist = #(Config.DeliveryReturn - requestedCoords)

    if (compareDist <= 10.0) then 
        local QBPlayer = QBCore.Functions.GetPlayer(source)
        local bonus = math.random(SV_Config.Bonus.min, SV_Config.Bonus.max)
        local total = Player(source).state.payout + bonus

        QBPlayer.Functions.AddMoney('cash', total)
        ES.Functions.UpdateCash(source, total)
    
        TriggerEvent("es_fleeca:cooldown", source)
        return true
    else 
        print("ban")
        return false
    end
end)

lib.callback.register("es_fleeca:checkCooldown", function(source)
    local src = source
    local currentTime = os.time()
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local timeLeft = MySQL.query.await("SELECT `last_used` FROM `bank_job_stats` WHERE `identifier` = ? LIMIT 1", {
        identifier
    })

    if (timeLeft[1].last_used ~= 0) then
        print((currentTime -  timeLeft[1].last_used)/60)
        if ((currentTime - timeLeft[1].last_used) / 60 >= SV_Config.Cooldown) then 
            MySQL.insert.await('UPDATE `bank_job_stats` SET last_used = 0 WHERE identifier = ?', { identifier })
            return false 
        end

        TriggerClientEvent('QBCore:Notify', src, "You're still on cooldown! Come back soon!", 'error', 3000)
        return true
    end
    return false
end)