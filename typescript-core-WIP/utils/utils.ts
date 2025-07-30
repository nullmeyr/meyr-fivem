import { describe } from "node:test";
import { text } from "stream/consumers";

import fetch from "node-fetch"

export namespace Utils
{
    export const Delay = (ms: number) => new Promise(res => setTimeout(res, ms)); 
}


export namespace Logger
{
    interface Logger
    {
        timestamp: number; 
        level: string;
        message: string; 
    }

    export function LogInfo(message: string): void
    {
        const logInfo: Logger =
        {
            timestamp: Date.now(),
            level: 'INFO', 
            message: message
        }
        console.log(`----------------------------------------\n[\x1b[32m${logInfo.level}\x1b[0m] - ${message}\n----------------------------------------`);
    }

    export function LogError(message: string): void
    {
        const logError: Logger =
        {
            timestamp: Date.now(),
            level: 'ERROR', 
            message: message
        }
        console.log(`----------------------------------------\n[\x1b[31m${logError.level}\x1b[0m] - ${message}\n----------------------------------------`);
    }
}

export namespace Discord 
{
    const webhookURL: string = "https://discord.com/api/webhooks/1398740588345557092/mj6EdF1X1UFjU-Yk9rrsYnXodsvyp41N2cvKGY66cMmJkAJftDJ5M_Fzm1eEvbjiWziw"

    export async function Log(reason: string, message: string)
    {
        const embed = 
        {
            embeds: [
                {
                    title: reason, 
                    description: message, 
                    color: 0xffd700,
                    footer: {
                        text: "The Forged - Logs"
                    },
                    timestamp: new Date().toISOString()
                }
            ]
        }
        
        await fetch(webhookURL, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(embed)
        })
    }
}