NRP = {}
-- future client sided functionality goes here:
function NRP.IsPlayerNearATM(player)
    local ret = false
    local player = PlayerPedId()
    local entityCoords = GetEntityCoords(player)
    local atmHash = GetHashKey('prop_fleeca_atm')
    local closestAtm = GetClosestObjectOfType(entityCoords.x, entityCoords.y, entityCoords.z, 1.0, atmHash, false, false, false)

    if (DoesEntityExist(closestAtm)) then 
        ret = true
    else 
        ret = false 
    end  
    return ret 
end 

function NRP.ShowATM()
    SendNUIMessage({
        action = 'openAtm'
    })
end