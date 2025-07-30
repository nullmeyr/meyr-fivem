export class Utils {
    // Delay function
    public static Delay = (time: number) => new Promise(resolve => setTimeout(resolve, time));
    // Send to discord
    public static SendToDiscord(source: number, name: string, wordSaid: string, p1: any, p2: any, p3: any, p4: any, p5: any, p6: any) 
    {
        emit("notion:server:SendToDiscordMessage", source, name, wordSaid, p1, p2, p3, p4, p5, p6); 
    }
}