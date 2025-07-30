Utils = {}

function Utils.DiscordLog(action, msg)
    local webhook = SV_Config.Webhook
    local embed

    if (action == 'log_red') then
        embed = {
            {
                ["color"] = 16711680,
                ["title"] = "ES_Fleeca | Suspicious Log",
                ["description"] = msg,
                ["footer"] = {
                    ["text"] = "Suspicious Activity Detection",
                },
            }
        } 
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif (action == 'log_green') then 
        embed = {
            {
                ["color"] = 65280,
                ["title"] = "ES_Fleeca | Action Log",
                ["description"] = msg,
                ["footer"] = {
                    ["text"] = "Job Loop Log",
                },
            }
        } 
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end