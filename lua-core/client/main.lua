-- 
local time = 0

RegisterNetEvent("notion:client:setHud", function(currentCash, currentBank)
    cash = currentCash 
    bank = currentBank

    SendNUIMessage({
        cash = currentCash,
        bank = currentBank,
        action = "updateHud"
    })
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("notion:server:updateHud")
    TriggerServerEvent("notion:server:clockTime")
end)

AddEventHandler("onResourceStart", function ()
    TriggerServerEvent("notion:server:updateHud")
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/setmoney', 'Set a players money [ADMIN]', {
        {name = "id", help = "Target ID"},
        {name = "type", help = "bank or cash"},
        {name = "amount", help = "Amount to SET money to."}
    })
    TriggerEvent('chat:addSuggestion', '/addmoney', 'Add to a players money [ADMIN]', {
        {name = "id", help = "Target ID"},
        {name = "type", help = "bank or cash"},
        {name = "amount", help = "Amount to ADD money to."}
    })
    TriggerEvent('chat:addSuggestion', '/removemoney', 'Remove a players money [ADMIN]', {
        {name = "id", help = "Target ID"},
        {name = "type", help = "bank or cash"},
        {name = "amount", help = "Amount to REMOVE money from."}
    })
    TriggerEvent('chat:addSuggestion', '/transfermoney', 'Transfer money to another player!', {
        {name = "id", help = "Target ID"},
        {name = "type", help = "bank or cash"},
        {name = "amount", help = "Amount to transfer money from your bank or cash amount."}
    })
end)

-- Keybind

local show = false
RegisterCommand("showmoney", function(source, args)
    show = not show
    if (show) then 
        SendNUIMessage({
            action = "hide"
        })
    else
        SendNUIMessage({
            action = "show"
        })
    end
end, false)

RegisterKeyMapping("showmoney", "Show Money Hud", "keyboard", "G")

-- Playtime 

RegisterNetEvent("notion:client:resetTime", function ()
    time = 0
    print("time reset")
end)

CreateThread(function ()
    while true do
        Wait(60000) -- one min
        time = time + 1 
        TriggerServerEvent("notion:server:updateTime", time)
    end
end)

-- withdraw / deposit 

RegisterNUICallback('hideAtm', function(data, cb)
    if (data == "hide") then 
        SetNuiFocus(false, false)
        cb('hidden')
    end
end)

RegisterNUICallback('checkDeposit', function(data) 
    local value = tonumber(data)
    TriggerServerEvent("notion:server:canDeposit", value)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('checkWithdraw', function(data) 
    local value = tonumber(data)
    TriggerServerEvent("notion:server:canWithdraw", value)
    SetNuiFocus(false, false)
end)


RegisterCommand("atm", function()
    local player = PlayerPedId()
    local isNearAtm = NRP.IsPlayerNearATM(player)
    if (isNearAtm) then 
        NRP.ShowATM()
        SetNuiFocus(true, true)
    end
end, false)