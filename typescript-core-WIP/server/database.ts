import { oxmysql as MySQL } from "@overextended/oxmysql";
import { Logger, Utils } from "../utils/utils"

export namespace Database
{
	export function SavePlayerIdentifiers(license: string, endpoint: string)
	{
		MySQL.prepare('INSERT INTO `players` (identifier, ip) VALUES (?, ?) ON DUPLICATE KEY UPDATE identifier = identifier, ip = ip',
			[
				license, endpoint	
			]);
	}

	export function CheckDatabaseTables(): Boolean
	{
		MySQL.prepare(`
			CREATE TABLE IF NOT EXISTS players (identifier VARCHAR(255) PRIMARY KEY,
			ip VARCHAR(255) NOT NULL DEFAULT 0,
			permission_level VARCHAR(255) NOT NULL DEFAULT 'user')`
			, [], (response) =>
		{
			Logger.LogInfo("Ensured 'players' table."); 
			return true; 
		})
		return false; 
	}
	
	/*
	export function AddPlaytime(license: string)
	{
		MySQL.prepare('INSERT INTO `rewards` (identifier, playtime) VALUES (?, 1) ON DUPLICATE KEY UPDATE identifier = VALUES(identifier), playtime = playtime + 1',
			[
				license,
			]);
	}
	*/
}