import { oxmysql as MySQL } from "@overextended/oxmysql";
import { Logger, Utils, Discord } from "../utils/utils"

const players = new Map<number, ForgedPlayer>(); 

export const PlayerManager =
{
    set(source: number, player: ForgedPlayer)
    {
        Discord.Log("Player Manager", `Object set for ${GetPlayerName(source.toString())}\n Source ID: ${source}`);
        players.set(source, player); 
    },

    get(source: number): ForgedPlayer | undefined 
    {
        return players.get(source)
    },

    has(source: number): boolean 
    {
        return players.has(source);
    }, 

    delete(source: number)
    {
        Discord.Log("Player Manager", `Object deleted for ${GetPlayerName(source.toString())}\n Source ID: ${source}`);
        players.delete(source); 
    }, 

    all(): Map<number, ForgedPlayer>
    {
        return players; 
    },

    createPlayerObject(source: number, name: string, identifier: string): void 
    {
        const player = new ForgedPlayer(source, name, identifier); 
        
        PlayerManager.set(source, player); 
    }
}

export class ForgedPlayer 
{
    source: number; 
    name: string;
    identifier: string;

    constructor(source: number, name: string, identifier: string)
    {
        this.source = source
        this.name = name; 
        this.identifier = identifier;
        
        Logger.LogInfo("Player object created for: " + name); 
    }
}