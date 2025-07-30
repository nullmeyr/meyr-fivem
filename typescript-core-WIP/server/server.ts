import { oxmysql as MySQL } from "@overextended/oxmysql";
import { Logger, Utils, Discord } from "../utils/utils";
import { Database } from "./database";
import { PlayerManager, ForgedPlayer } from "./player";

// check database connection
on("onResourceStart", (resName: string) => {
    if (resName == GetCurrentResourceName())
    {
        if (Database.CheckDatabaseTables())
        {
            return; 
        }
    }
});

on("playerConnecting", (playerName: string, setKickReason: (reason: string) => void, deferrals: { defer: any; done: any; handover: any; presentCard: any; update: any }): void => {

    let _source = (source).toString()
    deferrals.defer();
    deferrals.update("The server is checking your information, stranger!");

    var playerLicense: string; 
    var endpoint: string = GetPlayerEndpoint(_source);
    var steam: string; 

    let playerIdentifiers = getPlayerIdentifiers(_source);

    // defer if steam is not found
	playerIdentifiers.forEach((key, value) =>
    {
	    if (key.match("license:"))
		{
			playerLicense = key;
			deferrals.update("The server is checking your information, stranger!\n License Found!\n");
        }

        if (key.match("steam:"))
        {
            steam = key
            deferrals.update("The server is checking your information, stranger!\n Steam Found!\n");
        }
	})

    setTimeout(async () => 
    {
        let count = 3;
        while (count != 0) 
        {
            count--;
            await Utils.Delay(1000);
            deferrals.update(`Checks are done! Welcome ${playerName} \n\n Joining in ${count}`)

        }
        deferrals.done();

        Database.SavePlayerIdentifiers(playerLicense, endpoint); 

        Discord.Log("Player Connecting!", `${playerName} is connecting to the server!\n `)
    });
});

onNet("the-forged:player:spawned", () => {
    let playerIdentifiers = getPlayerIdentifiers(source);
    let playerLicense = ""; 
    let playerName: string = GetPlayerName(source.toString()); 

    console.log("triggered")

    playerIdentifiers.forEach((key, value) =>
    {
        if (key.match("license:"))
        {
            playerLicense = key;
            return;
        }
    })

    PlayerManager.createPlayerObject(source, playerName, playerLicense); 
    
    let player = PlayerManager.get(source);  

    Discord.Log("Player Joined!", `${player?.name} has joined to the server!`);
}); 

enum DisconnectCodes
{
    // resource dropped the client
    RESOURCE_DROPPED_CLIENT = "1",
    // client initiated a disconnect
    CLIENT_INITIATED_DISCONNECT = "2",
    // server initiated a disconnect
    SERVER_INITIATED_DISCONNECT = "3",
    // client with same guid connected and kicks old client
    CLIENT_REPLACED = "4",
    // server -> client connection timed out
    CLIENT_CONNECTION_TIMED_OUT = "5",
    // server -> client connection timed out with pending commands
    CLIENT_CONNECTION_TIMED_OUT_WITH_PENDING_COMMANDS = "6",
    // server shutdown triggered the client drop
    SERVER_SHUTDOWN = "7",
    // state bag rate limit exceeded
    STATE_BAG_RATE_LIMIT = "8",
    // net event rate limit exceeded
    NET_EVENT_RATE_LIMIT = "9",
    // latent net event rate limit exceeded
    LATENT_NET_EVENT_RATE_LIMIT = "10",
    // command rate limit exceeded
    COMMAND_RATE_LIMIT = "11",
    // too many missed frames in OneSync
    ONE_SYNC_TOO_MANY_MISSED_FRAMES = "12"
}

on("playerDropped", (reason: string, resourceName: string, clientDropReason: string) =>
{
    var name: string = GetPlayerName(source.toString());

    const getEnumKeyFromValue = (value: string): string | undefined => {
        const values = Object.values(DisconnectCodes) as string[]; 
        const keys = Object.keys(DisconnectCodes); 

        const index = values.indexOf(value)
        
        return keys[index + 2]; 
    }

    PlayerManager.delete(source); 

    Discord.Log("Player Left!", `${name} left the server!\n Reason: ${getEnumKeyFromValue(clientDropReason)}`);
});
