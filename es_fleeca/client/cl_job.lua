local QBCore = exports['qb-core']:GetCoreObject()

local defaultOverlayState = { timer = "0", drops = LocalPlayer.state.drops, payout = "0", location = "Get to the delivery truck!" }  

isJobActive = false

-- NUI shit 
RegisterNetEvent("fleeca:nui:toggleJobUI", function() 
    local Player = QBCore.Functions.GetPlayerData()
    local name = Player.charinfo.firstname .. " " .. Player.charinfo.lastname

    local totalCash = lib.callback.await('es_fleeca:nui:getTotalMoney', 0)
    local totalDrops = lib.callback.await('es_fleeca:nui:getTotalDrops', 0)

    SetNuiFocus(true, true)
    SendNUIMessage({ 
        action  = "open",
        isLeader = true,
        name = name,
        cash = totalCash,
        drops = totalDrops
    })

    TriggerScreenblurFadeIn(2000)
end)

-- Finish Later
RegisterNetEvent("fleeca:dressPlayer", function()
    local ped = PlayerPedId()

    SetPedComponentVariation(ped, 3, 1, 0, 2)     -- Arms
    SetPedComponentVariation(ped, 4, 10, 0, 2)    -- Suit pants (black)
    SetPedComponentVariation(ped, 6, 10, 0, 2)    -- Dress shoes (black)
    SetPedComponentVariation(ped, 8, 31, 0, 2)    -- Undershirt (white shirt)
    SetPedComponentVariation(ped, 15, 28, 3, 2)   -- Suit jacket (black w/ tie)
    
    SetPedComponentVariation(ped, 5, 45, 0, 2)    -- Bag (duffel bag)

    ClearAllPedProps(ped)
    SetPedPropIndex(ped, 2, 1, 0, true)           -- Earpiece for security look
end)

RegisterNUICallback("searchPlayer", function(name) 
    local result = lib.callback.await('es_fleeca:searchPlayerName', name)
    
    print(result)
end)

RegisterNUICallback("fleeca:ui:close", function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(2000)
end)

RegisterNUICallback("fleeca:start", function()
    local cooldown = lib.callback.await("es_fleeca:checkCooldown", 0)
    if (cooldown) then return end

    isJobActive = true

    local ped = PlayerPedId()
    local modelHash = Config.DeliveryTruck
    SendNUIMessage({
        hudStatus = "open"
    })
    TriggerEvent("es_fleeca:updateClientHudText", { timer = "0", drops = "None", payout = "0", location = "Get to the delivery truck!" })

    RequestModel(modelHash)
    while (not HasModelLoaded(modelHash)) do 
        Wait(1)
    end
        
    g_Truck = CreateVehicle(modelHash, Config.DeliveryReturn, 91.0, true, false)
    local netId = NetworkGetNetworkIdFromEntity(g_Truck)

    SetEntityDrawOutline(g_Truck, true) 
    SetEntityDrawOutlineColor(67, 196, 73, 0)
    SetVehicleDoorsLocked(g_Truck, 1) 
    SetVehicleNeedsToBeHotwired(g_Truck, false) 
    SetEntityAsMissionEntity(g_Truck, true, true)
    SetNetworkIdCanMigrate(netId, false)
    SetNetworkIdExistsOnAllMachines(netId, true)
    TriggerServerEvent("es_fleeca:server:trackVehicle", netId)

    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(g_Truck))

    SetTimeout(20000, function()
        SetEntityDrawOutline(g_Truck, false) 
    end)
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)

    while (not IsPedInVehicle(ped, g_Truck, false)) do 
        Wait(100)
    end

    TriggerServerEvent("es_fleeca:server:startJob")
    TriggerEvent("es_fleeca:createTruckInteraction", g_Truck)
    -- Main job loop
end)

RegisterNetEvent("es_fleeca:createTruckInteraction", function(truckEntity)
    CreateThread(function()
        local entity = truckEntity

        local netTruck = NetworkGetNetworkIdFromEntity(entity)
        exports.interact:AddEntityInteraction({
            netId = netTruck,
            id = 'door-interaction', -- needed for removing interactions
            distance = 8.0, -- optional
            interactDst = 3.0, -- optional
            ignoreLos = false, -- optional ignores line of sight
            offset = vec3(0.0, -0.5, 0.0), -- optional
            bone = 'door_pside_r', -- optional
            options = {
                {
                    label = 'Get Cash Bag',
                    canInteract = function()
                        if (bBagAttached) then 
                            return false
                        else return true end
                    end,
                    action = function(entity)
                        SetVehicleDoorOpen(entity, 3, false, false)

                        QBCore.Functions.Progressbar('get-cart', 'Getting Money Bag...', 2000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                            }, {
                                animDict = 'missmechanic',
                                anim = 'work2_base',
                                flags = 49,
                            }, {}, {}, function()
                                local ms = 5000
                                local player = PlayerPedId()
                                local coords = GetEntityCoords(player)
                                local heading = GetEntityHeading(player)

                                SetEntityHeading(player, heading + 180)
                                TriggerEvent("es-fleeca:requestMoneyBag")
                                SetVehicleDoorShut(entity, 3, false)
                            end, function()
                        end)
                    end,
                },
            }
        })
    end)
end)

bBagAttached = false
RegisterNetEvent("es-fleeca:requestMoneyBag", function()
    g_Backpack = Animations.GetCashBag()
    bBagAttached = true
end)    


-- Hud Updaters
RegisterNetEvent("es_fleeca:updateClientHudText", function(data)
    if (data.timer) then 
        SendNUIMessage({
            state = "setValues",
            timer = data.timer
        })
    end
    if (data.drops) then 
        SendNUIMessage({
            state = "setValues",
            drops = data.drops
        })
    end
    if (data.location) then 
        SendNUIMessage({
            state = "setValues",
            location = data.location
        })
    end
    if (data.payout) then 
        SendNUIMessage({
            state = "setValues",
            payout = data.payout
        })
    end
end)

RegisterNetEvent("es_fleeca:setGps", function(x, y)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent("es_fleeca:resetClientJobState", function()
    SendNUIMessage({
        action = "reset",
        hudStatus = "reset"
    })

    SetEntityAsNoLongerNeeded(g_Truck)
    DeleteEntity(g_Truck)
    isJobActive = false 
end)

RegisterNetEvent("es_fleeca:return", function()
    local truckCoords
    exports.interact:RemoveInteraction('door-interaction')
    while (true) do 
        truckCoords = GetEntityCoords(g_Truck)
        
        local distance = #(Config.DeliveryReturn - truckCoords)
        local blipColor = { r = 255, g = 0, b = 0 }
        local checkpoint = DrawMarker(27, Config.DeliveryReturn.x, Config.DeliveryReturn.y, Config.DeliveryReturn.z - 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 2.0, blipColor.r, blipColor.g, blipColor.b, 225, false, true, 2, false, nil, nil, nil)

        if (distance <= 3.0) then 
            blipColor = { r = 0, g = 255, b = 0}
            checkpoint = DrawMarker(27, Config.DeliveryReturn.x, Config.DeliveryReturn.y, Config.DeliveryReturn.z - 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 2.0, blipColor.r, blipColor.g, blipColor.b, 225, false, true, 2, false, nil, nil, nil)
            if (IsControlJustReleased(0, 38)) then 
                print("returned")
                bBagAttached = false
                break;
            end
        end
        Wait(0)
    end

    local response = lib.callback.await("es_fleeca:truckReturned", 0, {truckCoords = truckCoords})

    if (response) then 
        TriggerEvent("es_fleeca:resetClientJobState")
    else return end
end)

CreateThread(function()
    Wait(500)

    local id = GetPlayerServerId(PlayerId())
    local myBag = "player:" .. id

    AddStateBagChangeHandler('drops', nil, function(bagName, key, value, reserved, replicated)
        if bagName ~= myBag then return end

        print(value)
        local drop = value

        TriggerEvent("es_fleeca:updateClientHudText", {drops = tostring(drop)})
        print("drops updated" .. drop)
    end)

    AddStateBagChangeHandler('location', nil, function(bagName, key, value, reserved, replicated)
        if bagName ~= myBag then return end

        local location = value
        TriggerEvent("es_fleeca:updateClientHudText", {location = location})
        print("location updated")
    end)

    AddStateBagChangeHandler('payout', nil, function(bagName, key, value, reserved, replicated)
        if bagName ~= myBag then return end
        
        print(value)
        local payout = value
        TriggerEvent("es_fleeca:updateClientHudText", {payout = payout})
        print("payout updated")
    end)

    AddStateBagChangeHandler('timer', nil, function(bagName, key, value, reserved, replicated)
        if bagName ~= myBag then return end
        
        local timer = value

        TriggerEvent("es_fleeca:updateClientHudText", {timer = timer})
        print("timer updated")
    end)
end)

-- Interactions
RegisterNetEvent("es_fleeca:createTarget", function(data)
    local isUsed = false

    exports.interact:AddInteraction({
        coords = data.coords,
        distance = 8.0, 
        interactDst = 1.0,
        id = 'deliver-checkpoint', -- needed for removing interactions
        options = {
            {
                label = 'Deliver Cash Bag',
                action = function()

                    if (bBagAttached) then 
                        lib.callback.await("es_fleeca:requestPlayerDrop")

                        BeginTextCommandThefeedPost("STRING")
                        AddTextComponentSubstringPlayerName("Get to the next drop — no excuses, no delays.")
                        EndTextCommandThefeedPostMessagetext("CHAR_AGENT14", "CHAR_AGENT14", true, 1, "Operations Manager", "Fleeca Bank")
                        EndTextCommandThefeedPostTicker(false, false)
                        PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true)

                        Animations.ClearAnimation(g_Backpack)
                        exports.interact:RemoveInteraction('deliver-checkpoint')
                        bBagAttached = false
                    else 
                        BeginTextCommandThefeedPost("STRING")
                        AddTextComponentSubstringPlayerName("Hey Ding Dong, you need the BAG!!!!")
                        EndTextCommandThefeedPostMessagetext("CHAR_AGENT14", "CHAR_AGENT14", true, 1, "Operations Manager", "Fleeca Bank")
                        EndTextCommandThefeedPostTicker(false, false)
                        PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true) 
                        
                        return
                    end
                end,
            },
        }
    })
end)

RegisterNetEvent("es_fleeca:cleanUp", function()
    SendNUIMessage({
        hudStatus = "close"
    })
end)

CreateThread(function()
    local isUsed = false

    exports.interact:AddInteraction({
        coords = Config.JobStart,
        distance = 8.0, 
        interactDst = 1.0,
        id = 'job-start', -- needed for removing interactions
        options = {
            {
                label = 'Armored Truck Job',
                canInteract = function()
                    return not isUsed
                end,
                action = function()
                    if (isUsed) then return end
                    isUsed = true

                    if (isJobActive) then 
                        QBCore.Functions.Notify("You're already in a job!", 'error', 4000)
                        isUsed = false
                        return
                    end

                    local hasItem = QBCore.Functions.HasItem('security_key', 1) 
                    local ped = PlayerPedId()
                    local laptopCoords = vector4(247.38, 208.58, 110.28, 81.88)

                    if (hasItem) then 
                        SetEntityCoords(ped, laptopCoords.x, laptopCoords.y, laptopCoords.z, true, false, false, true)
                        SetEntityHeading(ped, laptopCoords.w)

                        local chair = GetClosestObjectOfType(laptopCoords.x, laptopCoords.y, laptopCoords.z, 5.5, GetHashKey("prop_off_chair_01"), true, false, false)

                        if (chair ~= 0) then 
                            if (IsEntityAMissionEntity(chair)) then 
                                SetEntityAsMissionEntity(chair, false, true)
                            end

                            SetEntityAsNoLongerNeeded(chair)
                            SetEntityVisible(chair, false, 0)
                            SetEntityCollision(chair, false, false)
                            DeleteObject(chair)
                        end

                        QBCore.Functions.Progressbar('start-progBar', 'Accessing Interface...', 3500, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                            }, {
                                animDict = 'missheist_jewel@hacking',
                                anim = 'hack_loop',
                                flags = 49,
                            }, {}, {}, function()
                                TriggerEvent("fleeca:nui:toggleJobUI")
                                isUsed = false
                            end, function()
                        end)
                    else 
                        QBCore.Functions.Notify("You lack security clearance!", 'error', 4000)
                        isUsed = false
                    end
                end,
            },
        }
    })

end)
