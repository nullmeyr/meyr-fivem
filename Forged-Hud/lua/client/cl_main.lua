-- entityDamaged(victim: number, culprit: number, weapon: number, baseDamage: number): void
function UpdateHud(newHealth)
    SendNUIMessage({
        health = newHealth
    })
end

local function UpdateHUDClock()
    local newHour = GetClockHours()
    local newMinutes = GetClockMinutes()

    SendNUIMessage({
        hour = newHour,
        minute = newMinutes
    })
end

AddEventHandler('onResourceStart', function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    Wait(1000)
    UpdateHud(health)
end)

AddEventHandler('playerSpawned', function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    print(health)
    Wait(1000)
    UpdateHud(health)
end)

CreateThread(function()
    while (true) do
        local ped = PlayerPedId()
        local oldHealth = GetEntityHealth(ped)
        Wait(100)
        local newHealth = GetEntityHealth(ped)

        if (oldHealth ~= newHealth) then
            if (newHealth == 0) then
                Wait(5000)
                print("Dead Updated")
                TriggerEvent("Forged:client:UpdateHud", "0")
                TriggerEvent("Forged-Death:client:isDead")
            end

            TriggerEvent("Forged:client:UpdateHud", newHealth)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(100)
        UpdateHUDClock()
    end
end)

RegisterNetEvent('Forged:client:UpdateHud', function(newHealth)
    UpdateHud(newHealth)
end)

print(GetEntityHealth(PlayerPedId()))
