NRP = {} 

-- local functions
function NRP.FetchPlayerLicense(source) 
    local identifiers = GetPlayerIdentifiers(source)
    local license = ""

    for _,v in pairs(identifiers) do
        if (string.match(v, "license:")) then 
            license = v
        end
    end
    return license
end

function NRP.FetchPlayerDiscord(source)
    local identifiers = GetPlayerIdentifiers(source)
    local discord = ""

    for _,v in pairs(identifiers) do
        if (string.match(v, "discord:")) then 
            discord = v
        end
    end
    return discord
end

function NRP.GetPlayer(args)
    local allPlayers = GetPlayers()
    local target = 0
    for playerId, _ in pairs(allPlayers) do
        if (playerId == tonumber(args)) then 
            target = playerId
            break
        else target = 0 end
    end
    return target
end

-- Logging functions

-- VERY basic, will add more in the future
-- @param type Type of log (error, success, info, warning)
function NRP.Log(type, msg)
    if (type == "error") then 
        print("[NRP] [^1ERROR^0] | ^1".. msg.. "^0")
    elseif (type == "success") then 
        print("[NRP] [^2OK^0] | ^2".. msg.. "^0")
    elseif (type == "info") then 
        print("[NRP] [^5INFO^0] | ^5".. msg.. "^0")
    end
end
 
RegisterNetEvent("notion:server:SendToDiscordMessage", function(source, name, message)
    print(message .. " | " .. source)
    local chatModEmbed = {
        title = "H-Core Chat Moderation",
        description = "Action",
        fields = { -- array of fields
            {
                name = "Player Banned",
                value =  GetPlayerName(source) .. " has been kicked for saying ".. message,
                inline = true
            },
        },
        footer = {
            text = "[CORE ACTION]"
        },
        color = 0xf44336
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {chatModEmbed}}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("notion:server:ContentFilterKick", function (source, reason, details)
    DropPlayer(source, "[CORE] - Kicked by content filter!") 
    TriggerEvent("ElectronAC:KickPlayer", source, reason, details)
end)

function NRP.SendToDiscord(source, amount, discordIdentifier, type, target) 

    local source = GetPlayerName(source) 
    if (target == nil) then 
        local paycheckEmbed = {
            title = "H-Core",
            description = "Action",
            fields = { -- array of fields
                {
                    name = "Money Added",
                    value =  source .. " received $" .. amount .. " as their daily paycheck. (This occurs every 48 minutes!)",
                    inline = true
                },
            },
            footer = {
                text = "[CORE ACTION] - Discord ID: ".. discordIdentifier
            },
            color = 0x3de00b
        }

        local withdrawEmbed = {
            title = "H-Core",
            description = "Action",
            fields = { -- array of fields
                {
                    name = "Money Withdrew",
                    value =  source .. " withdrew $" .. amount,
                    inline = true
                },
            },
            footer = {
                text = "[USER ACTION] - Discord ID: ".. discordIdentifier
            },
            color = 0x3de00b
        }

        local depositEmbed = {
            title = "H-Core",
            description = "Action",
            fields = { -- array of fields
                {
                    name = "Money Deposited",
                    value =  source .. " deposited $" .. amount,
                    inline = true
                },
            },
            footer = {
                text = "[USER ACTION] - Discord ID: ".. discordIdentifier
            },
            color = 0x3de00b
        }

        if (type == 'paycheck') then 
            PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {paycheckEmbed}}), { ['Content-Type'] = 'application/json' })
        elseif (type == 'withdraw') then 
            PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {withdrawEmbed}}), { ['Content-Type'] = 'application/json' })
        elseif (type == 'deposit') then 
            PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {depositEmbed}}), { ['Content-Type'] = 'application/json' })
        end
        return
    end
    local target = GetPlayerName(target)

    local addMoneyEmbed = {
        title = "H-Core",
        description = "Action",
        fields = { -- array of fields
            {
                name = "Money Added",
                value =  source .. " added $" .. amount .. " to ".. target,
                inline = true
            },
        },
        footer = {
            text = "[STAFF ACTION] - Discord ID: ".. discordIdentifier
        },
        color = 0x3de00b
    }


    local setMoneyEmbed = {
        title = "H-Core",
        description = "Action",
        fields = { -- array of fields
            {
                name = "Money Set",
                value =  source .. " set $" .. amount .. " to ".. target,
                inline = true
            },
        },
        footer = {
            text = "[STAFF ACTION] - Discord ID: ".. discordIdentifier
        },
        color = 0x3de00b
    }

    local removedMoneyEmbed = {
        title = "H-Core",
        description = "Action",
        fields = { -- array of fields
            {
                name = "Money Removed",
                value =  source .. " removed $" .. amount .. " from " .. target,
                inline = true
            },
        },
        footer = {
            text = "[STAFF ACTION] - Discord ID: ".. discordIdentifier
        },
        color = 0xf44336
    }

    local transferMoneyEmbed = {
        title = "H-Core",
        description = "Action",
        fields = { -- array of fields
            {
                name = "Money Transferred",
                value =  source .. " transferred $" .. amount .. " to ".. target,
                inline = true
            },
        },
        footer = {
            text = "[PLAYER ACTION] - Discord ID: ".. discordIdentifier
        },
        color = 0xf44336
    }
    if (type == 'add') then 
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {addMoneyEmbed}}), { ['Content-Type'] = 'application/json' })
    elseif (type == 'remove') then  
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {removedMoneyEmbed}}), { ['Content-Type'] = 'application/json' })
    elseif (type == 'set') then 
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {setMoneyEmbed}}), { ['Content-Type'] = 'application/json' })
    elseif (type == 'transfer') then 
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {transferMoneyEmbed}}), { ['Content-Type'] = 'application/json' })
    end
end


-- Money Functions

function NRP.UpdateMoney(license, source)
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 

    TriggerClientEvent('notion:client:setHud', source, currentCash, currentBank)
end

function NRP.AddMoney(license, type, amount, target, source) 
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local total = currentCash + amount   
    local bTotal = currentBank + amount
    local discord = NRP.FetchPlayerDiscord(source)

    if (type == 'cash') then
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            total,
            license
        })
    elseif (type == 'bank') then 
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            bTotal,
            license
        })
    end
    NRP.UpdateMoney(license, source)
    NRP.SendToDiscord(source, amount, discord, 'add', target)
end

function NRP.TransferMoney(license, type, amount, target, source) 
    local discord = NRP.FetchPlayerDiscord(source)
    local amount = tonumber(amount)
    local sourceLicense = NRP.FetchPlayerLicense(source)

    local targetCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local targetBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 

    local sourceCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {sourceLicense}) 
    local sourceBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {sourceLicense}) 

    local deductionCashAmount = sourceCash - amount
    local deductionBankAmount = sourceBank - amount

    local newTotal = targetCash + amount   
    local newBankTotal = targetBank + amount

    
    if (type == 'cash') then
        if (amount > sourceCash) then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[Core]", "You don't have that cash!"}
            })

            return
        else 
            MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
                newTotal,
                license
            })

            MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
                deductionCashAmount,
                sourceLicense
            })
        end
    elseif (type == 'bank') then 
        if (amount > sourceBank) then 
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[Core]", "You don't have that money in your bank!"}
            })

            return 
        else 

            MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
                newBankTotal,
                license
            })

            MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
                deductionBankAmount,
                sourceLicense
            })
        end
    else
        return
    end 
    NRP.UpdateMoney(license, target)
    NRP.UpdateMoney(sourceLicense, source)

    NRP.SendToDiscord(source, amount, discord, 'transfer', target)
end

function NRP.SetMoney(license, type, amount, source, target) 
    local discord = NRP.FetchPlayerDiscord(source)
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local newAmount = amount    

    if (type == 'cash') then 
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            newAmount,
            license
        })
    elseif (type == 'bank') then 
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            newAmount,
            license
        })
    end
    NRP.UpdateMoney(license, source)
    NRP.SendToDiscord(source, amount, discord, 'set', target)
end

function NRP.RemoveMoney(license, type, amount, source, target) 
    local discord = NRP.FetchPlayerDiscord(source)
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local deductionAmount = currentCash - amount 
    local bDeductionAmount = currentBank - amount

    if (type == 'cash') then 
        if (deductionAmount < 0) then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[Core]", "You cannot put the player in a negative balance!"}
            })
            NRP.Log("error", GetPlayerName(source).. " tried to put a target player into negative balance.")
            return
        end
    
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            deductionAmount,
            license
        })
    elseif (type == 'bank') then 
        if (bDeductionAmount < 0) then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[Core]", "You cannot put the player in a negative balance!"}
            })
            NRP.Log("error", GetPlayerName(source).. " tried to put a target player into negative balance.")
            return
        end
    
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            bDeductionAmount,
            license
        })
    end
    NRP.SendToDiscord(source, amount, discord, 'remove', target)
    NRP.Log("info", GetPlayerName(source).. " removed ".. amount .. " from " .. GetPlayerName(target))
    NRP.UpdateMoney(license, source)
end


function NRP.LoadPlayer(source)
    local src = source

    local identifiers = {
        playerName = GetPlayerName(src),
        playerIp = GetPlayerEndpoint(src), 
        playerLicense = NRP.FetchPlayerLicense(src) ,
        playerDiscord = NRP.FetchPlayerDiscord(src)
    }

    MySQL.prepare('INSERT INTO players (name, ip, license, cash, bank, playtime, discordIdentifier) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), ip = VALUES(ip), discordIdentifier = VALUES(discordIdentifier)', {
        identifiers.playerName, 
        identifiers.playerIp, 
        identifiers.playerLicense, 
        100, 
        100,
        0,
        identifiers.playerDiscord
    })
    NRP.UpdateMoney(identifiers.license, source)
end

RegisterNetEvent("notion:server:updateHud", function()
    local src = source 
    local license = NRP.FetchPlayerLicense(src)
    NRP.UpdateMoney(license, src)
end)

-- Playtime 
function NRP.UpdateLastConnection(identifier, source, osTime)
    MySQL.update.await('UPDATE players SET lastConnection = ? WHERE license = ?', {
        osTime,
        identifier
    })
end

function NRP.UpdatePlayerMins(license, mins)
    local playtime = MySQL.scalar.await('SELECT `playtime` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    if (playtime == nil) then  return end
    local mins = playtime + 1

    MySQL.update.await('UPDATE players SET playtime = ? WHERE license = ?', {
        mins,
        license
    })
end

function NRP.AddPlaytimeMoney(license, type, amount, source) 
    local currentCash = MySQL.scalar.await('SELECT `cash` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local currentBank = MySQL.scalar.await('SELECT `bank` FROM `players` WHERE `license` = ? LIMIT 1', {license}) 
    local total = currentCash + amount   
    local bTotal = currentBank + amount
    local discord = NRP.FetchPlayerDiscord(source)

    if (type == 'cash') then
        MySQL.update.await('UPDATE players SET cash = ? WHERE license = ?', {
            total,
            license
        })
    elseif (type == 'bank') then 
        MySQL.update.await('UPDATE players SET bank = ? WHERE license = ?', {
            bTotal,
            license
        })
    end
    NRP.UpdateMoney(license, source)
    NRP.SendToDiscord(source, amount, discord, 'paycheck', nil)
end
