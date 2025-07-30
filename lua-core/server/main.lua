AddEventHandler("playerJoining", function()
    local src = source
    NRP.LoadPlayer(src)
    NRP.Log("success", GetPlayerName(src) .. " has been updated into the database!")
end)

-- playtime

RegisterNetEvent("notion:server:clockTime", function()
    local src = source
    local license = NRP.FetchPlayerLicense(src) 

    local formattedTime = os.date("%Y/%m/%d %X")
    NRP.UpdateLastConnection(license, src, formattedTime)
end)

RegisterNetEvent("notion:server:updateTime", function(time)
    local src = source
    local license = NRP.FetchPlayerLicense(src) 

    if (time == Config.PaycheckInterval) then 
        TriggerClientEvent("notion:client:resetTime", src)
        NRP.AddPlaytimeMoney(license, "bank", Config.PaycheckAmount, src)
    end

    NRP.UpdatePlayerMins(license)
end)


-- money / bank commands

RegisterCommand("setmoney", function(source, args)
    local src = source
    if (IsPlayerAceAllowed(src, "setmoney")) then 
        local target = NRP.GetPlayer(args[1])
        if (target == 0) then 
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[Core]", "Player not online!"}
            })
            return 
        end

        local license = NRP.FetchPlayerLicense(target) 
        -- args[2] == type (bank or cash)
        NRP.SetMoney(license, args[2], args[3], src, target)
    else 
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Core]", "You don't have permission for this command!"}
        })
    end
end, true)

RegisterCommand("addmoney", function (source, args)
    local src = source
    if (IsPlayerAceAllowed(src, "addmoney")) then 
        local target = NRP.GetPlayer(args[1])
        if (target == 0) then 
            TriggerClientEvent("hydrogen:displayNotification", source, "Error", "Player not online!", "error", 4000)
            return 
        end

        local license = NRP.FetchPlayerLicense(target) 
    
    
        NRP.AddMoney(license, args[2], args[3], target, source)

        local title = "Money Added"
        local message = "You've been given $".. args[3].."!"
        local type = "info"
        local time = 4000 

        -- TriggerClientEvent("hydrogen:displayNotification", target, title, message, type, time)
    else 
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Core]", "You don't have permission for this command!"}
        })
    end
end, true)

RegisterCommand("transfermoney", function (source, args)
    local src = source
    local target = NRP.GetPlayer(args[1])
    if (target == 0) then 
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Core]", "Player not online!"}
        })
        return 
    end

    local license = NRP.FetchPlayerLicense(target) 
    NRP.TransferMoney(license, args[2], args[3], target, src)
    TriggerClientEvent('codem-notification', src, "You have transferred $" .. args[2] .. " to " .. GetPlayerName(target) .. ".", 5000, "venicebank")
    TriggerClientEvent('codem-notification', target, "You have received $" .. args[2] .. " from " .. GetPlayerName(src) .. ".", 5000, "venicebank")    
end, false)

RegisterCommand("removemoney", function(source, args)
    local src = source
    local target = NRP.GetPlayer(args[1])
    if (target == 0) then 
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Core]", "Player not online!"}
        })
        return 
    end

    local license = NRP.FetchPlayerLicense(target) 
    if (IsPlayerAceAllowed(src, "removemoney")) then 
        if (target == 0) then 
            return 
        end

        NRP.RemoveMoney(license, args[2], args[3], source, target)
    else 
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Core]", "You don't have permission for this command!"}
        })
    end
end, true)

-- atm
RegisterNetEvent("notion:server:canDeposit", function(value) 
    local src = source 
    local license = NRP.FetchPlayerLicense(src)
    local discord = NRP.FetchPlayerDiscord(src)
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 

    if (value > currentCash) then 
        NRP.UpdateMoney(license, src)
        return 
    else 
        local newBank = currentBank + value
        local newCash = currentCash - value
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            newBank,
            license
        })
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            newCash,
            license
        })
    end
    NRP.SendToDiscord(src, value, discord, 'deposit', nil)
    NRP.UpdateMoney(license, src)
end)

RegisterNetEvent("notion:server:canWithdraw", function(value)
    local src = source 
    local license = NRP.FetchPlayerLicense(src)
    local discord = NRP.FetchPlayerDiscord(src)
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 

    if (value > currentBank) then 
        NRP.UpdateMoney(license, src)
        return 
    else 
        local newBank = currentBank - value
        local newCash = currentCash + value
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            newBank,
            license
        })
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            newCash,
            license
        })
    end
    NRP.SendToDiscord(src, value, discord, 'withdraw', nil)
    NRP.UpdateMoney(license, src)
end)