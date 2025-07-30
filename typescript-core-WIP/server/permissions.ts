import { oxmysql as MySQL } from "@overextended/oxmysql";
import { Logger, Utils , Discord} from "../utils/utils"
import { PlayerManager, ForgedPlayer } from "./player";
import { Database } from "./database";

enum ForgedPermissions 
{
    USER = "user",
    MODERATOR = "mod",
    ADMINISTRATOR = "admin"
}

RegisterCommand("setpermission", (source: any, args: any, rawCommand: any) => 
{
    if (source === 0) 
    {
        var targetId = args[0]
        var requestedPermission = args[1]

        var player = PlayerManager.get(parseInt(targetId));

        console.log(PlayerManager.all());
        console.log(player?.identifier);

        if (GetPlayerName(targetId)) 
        {
            Discord.Log("Permission Updated!", `${GetPlayerName(targetId)} was made an ${requestedPermission} by the server console! ` );

            MySQL.prepare('INSERT INTO `players` (identifier, permission_level) VALUES (?, ?) ON DUPLICATE KEY UPDATE permission_level = ?',
			[
				player?.identifier, requestedPermission	
			]);
        }
        else 
        {
            Logger.LogError("Player is not online!")
        }

    }

}, false);

