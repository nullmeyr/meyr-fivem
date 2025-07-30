import { Utils } from "../utils/Utils";
const { google } = require("googleapis");


// Chat moderation
const API_KEY = "AIzaSyDMFUjMRnvnecxaxmsPd-0hL4L1l0xWWyE";
const DISCOVERY_URL =
  "https://commentanalyzer.googleapis.com/$discovery/rest?version=v1alpha1";
const global = {
  ret: ""
}
async function CheckMessage(source: number, name: string, message: string):Promise<String> {
  google.discoverAPI(DISCOVERY_URL).then((client: any) => {

      const analyzeRequest = {
        comment: {
          text: message,
        },
        requestedAttributes: {
          TOXICITY: {},
          SEVERE_TOXICITY: {},
          IDENTITY_ATTACK: {},
          INSULT: {},
          PROFANITY: {},
          THREAT: {},
        },
      };

      client.comments.analyze(
        {
          key: API_KEY,
          resource: analyzeRequest,
        },
        (err: any, response: any) => {
          if (err) throw err;
          const res = response.data;
          const TOXICITY =
            res.attributeScores.TOXICITY.spanScores[0].score.value;
          const SEVERE_TOXICITY =
            res.attributeScores.SEVERE_TOXICITY.spanScores[0].score.value;
          const IDENTITY_ATTACK =
            res.attributeScores.IDENTITY_ATTACK.spanScores[0].score.value;
          const INSULT = res.attributeScores.INSULT.spanScores[0].score.value;
          const PROFANITY =
            res.attributeScores.PROFANITY.spanScores[0].score.value;
          const THREAT = res.attributeScores.THREAT.spanScores[0].score.value;

          const KICK_VAL = 6;
          const BAN_VAL = 8;

          switch (TOXICITY) {
            case TOXICITY: {
              if (Math.round(TOXICITY * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(TOXICITY * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
            case SEVERE_TOXICITY: {
              if (Math.round(SEVERE_TOXICITY * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(SEVERE_TOXICITY * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
            case IDENTITY_ATTACK: {
              if (Math.round(IDENTITY_ATTACK * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(IDENTITY_ATTACK * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
            case INSULT: {
              if (Math.round(INSULT * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(INSULT * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
            case PROFANITY: {
              if (Math.round(PROFANITY * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(PROFANITY * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
            case THREAT: {
              if (Math.round(THREAT * 10) == KICK_VAL) {
                console.log("Kicked");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Kick";
                break;
              } else if (Math.round(THREAT * 10) >= BAN_VAL) {
                console.log("Ban");
                Utils.SendToDiscord(
                  source,
                  name,
                  message,
                  Math.round(TOXICITY * 10),
                  Math.round(SEVERE_TOXICITY * 10),
                  Math.round(IDENTITY_ATTACK * 10),
                  Math.round(INSULT * 10),
                  Math.round(PROFANITY * 10),
                  Math.round(THREAT * 10)
                );
                global.ret == "Ban";
                break;
              }
            }
          } 
        }
      );
    })
    .catch((err: any) => {
      throw err;
    });
  console.log("Value to return is A: " + global.ret);
  return global.ret; 
}

var canTrigger: Boolean = true;
on("chatMessage", (source: number, name: string, message: string) => {
  if (canTrigger == true) {
    canTrigger = false;
    var action:any = CheckMessage(source, name, message);

    if (global.ret == "Ban") {
      console.log("ok");
      /*
      emitNet(
        "ElectronAC:BanPlayer",
        source,
        "Banned by Content Filter",
        "Permanent"
      );*/
      
      emitNet("chat:addMessage", -1, {
        color: [255, 0, 0],
        multiline: true,
        args: [
          "[CORE]", name + " has been permanently banned by Content Filter!",
        ],
      });
      CancelEvent();
      return; 
    } else if (global.ret == "Kick") {
      DropPlayer(source.toString(), "[Chat Filter] - Kicked! If you think this was a mistake, open a ticket.")
      emit("chat:addMessage", -1, {
        color: [255, 0, 0],
        multiline: true,
        args: [
          "[CORE]",
          `${name} has been kicked by Content Filter!`,
        ],
      });
      CancelEvent();
      return; 
    } else {
      setTimeout(() => {
        canTrigger = true; 
      }, 15000) 
    }
  } else {
    emitNet("chat:addMessage", source, {
      color: [255, 0, 0],
      multiline: true,
      args: [
        "[CORE]",
        "You can send one message every 15 seconds, please wait!",
      ],
    });
    CancelEvent();
    return; 
  }

});
