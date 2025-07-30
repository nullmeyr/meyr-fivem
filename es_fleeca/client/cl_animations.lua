Animations = {}

-- This animation uses a mechanic emote to simulate the player getting the money bag from the back of the truck. 
function Animations.GetCashBag(ms)
    local player = PlayerPedId()
 
    local coords = GetEntityCoords(player)
    local heading = GetEntityHeading(player)
    local rotation = GetEntityRotation(player)

    local anim = 'idle'
    local animDict = 'move_p_m_zero_rucksack'

    local model = 'p_michael_backpack_s'

    RequestModel(model)
    while (not HasModelLoaded(model)) do Wait(0) end

    local prop = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)

    RequestAnimDict(animDict)
    while (not HasAnimDictLoaded((animDict))) do Wait(0) end

    TaskPlayAnim(player, animDict, anim, 8.0, 1.0, -1, 49, 1.0, false, false, false)
    AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 24818), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0, nil, true, true, true, 1, true)

    return prop
end

function Animations.ClearAnimation(prop)
    local player = PlayerPedId()

    DeleteEntity(prop)
    ClearPedTasksImmediately(player)
end

-- This animation uses the trolly cart. 
function Animations.GatherMoney(ms)
    local player = PlayerPedId()
    
    local coords = GetEntityCoords(player)
    local heading = GetEntityHeading(player)
    local rotation = GetEntityRotation(player)

    local model = `hei_prop_heist_cash_pile`

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    while (not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash")) do Wait(0) end 

    while (not HasModelLoaded("hei_p_m_bag_var22_arm_s") and HasModelLoaded(model) and HasModelLoaded("hei_prop_hei_cash_trolly_01")) do Wait(0) end

    local duffel = CreateObject("hei_p_m_bag_var22_arm_s", coords.x, coords.y, coords.z, true, false, false)
    local cash  = CreateObject(model, coords.x, coords.y, coords.z, true, false, false)
    local cart = CreateObject("hei_prop_hei_cash_trolly_01", coords.x, coords.y, coords.z - 1.0, true, false, false)

    SetEntityVisible(cash, false)
    FreezeEntityPosition(cash, true)
    SetEntityInvincible(cash, true)
    SetEntityNoCollisionEntity(cash, player)


    local bagEnter = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z - 0.5, rotation.x, rotation.y, rotation.z, 2, false, false, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(player, bagEnter, "anim@heists@ornate_bank@grab_cash", "intro", 8.0, -8.0, 1148846080, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(duffel, bagEnter, "anim@heists@ornate_bank@grab_cash", "bag_intro", 8.0, -8.0, 1148846080)
    NetworkStartSynchronisedScene(bagEnter)

        
    Wait(500)
    AttachEntityToEntity(cash, player, GetPedBoneIndex(player, 0x1049), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    local grabBag = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z - 0.5, rotation.x, rotation.y, rotation.z, 2, false, false, 1.0, 0.0, 1.0)
    CreateThread(function ()
        while (DoesEntityExist(cash)) do
            SetEntityVisible(cash, true)
            Wait(600)

            SetEntityVisible(cash, false)
            Wait(600)
        end
    end)

    NetworkAddPedToSynchronisedScene(player, grabBag, "anim@heists@ornate_bank@grab_cash", "grab", 8.0, -8.0, 1148846080, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(duffel, grabBag, "anim@heists@ornate_bank@grab_cash", "bag_grab", 8.0, -8.0, 1148846080)  
    NetworkAddEntityToSynchronisedScene(cart, grabBag, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 8.0, -8.0, 1148846080)
    NetworkStartSynchronisedScene(grabBag)
    Wait(ms)

    NetworkStopSynchronisedScene(grabBag)
    DeleteObject(cash)
    DeleteObject(cart)
    DeleteObject(duffel)
end


--[[
RegisterCommand("anim", function()
    local prop = Animations.GetCashBag()
    Wait(5000)
    Animations.ClearAnimation(prop)
end, false)
]]