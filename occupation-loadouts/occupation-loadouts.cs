using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Security.AccessControl;
using System.Threading.Tasks;
using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace occupation_loadouts
{
    public class Main : BaseScript
    {
        public Main()
        {
            // Displays a list of available loadouts!

            API.RegisterCommand("loadouts", new Action<int, List<object>, string>((source, args, raw) =>
            {
                TriggerEvent("chat:addMessage", new
                {
                    color = new[] {53, 252, 22},
                    multiline = true,
                    args = new[]
                    {
                        "Loadout Commands: \n" + "^4 [/leolo] (Gives a police Loadout) \n" +
                        "^1 [/crimelo] (Gives a criminal Loadout) \n" + "^2 [/clearlo] (Clears all weapons!) \n" +
                        "^4 [/swatlo] (Gives a swat loadout!)"
                    }

                });
            }), false);

            // Clearing the loadout! (all weapons in wheel!)

            API.RegisterCommand("clearlo", new Action<int, List<object>, string>((source, args, raw) =>
            {
                Game.PlayerPed.Weapons.RemoveAll(); // Clears weapon wheel without giving a loadout!

                TriggerEvent("chat:addMessage", new
                {
                    color = new[] {255, 0, 0},
                    args = new[] {"[LoadoutManager] Cleared your weapons!"}

                });
            }), false);

            // Clears your weapon wheel!

            API.RegisterCommand("crimelo", new Action<int, List<object>, string>((source, args, raw) =>
            {
                Game.PlayerPed.Weapons.RemoveAll();
                Game.PlayerPed.Weapons.Give(WeaponHash.Dagger, 0, false, false);
                Game.PlayerPed.Weapons.Give(WeaponHash.HeavyPistol, 250, false, false);

                TriggerEvent("chat:addMessage", new
                {
                    color = new[] {255, 0, 0},
                    args = new[] {"[LoadoutManager] Successfully given a criminal loadout!"}

                });

            }), false);

            // Gives a crime loadout!

            API.RegisterCommand("leolo", new Action<int, List<object>, string>((source, args, raw) =>
            {
                
                Game.PlayerPed.Weapons.RemoveAll(); // Removes any weapons prior to executing the "leolo" command
                Game.PlayerPed.Weapons.Give(WeaponHash.StunGun, 100, false, false); 
                Game.PlayerPed.Weapons.Give(WeaponHash.Pistol, 100, false, false); 
                Game.PlayerPed.Weapons.Give(WeaponHash.CarbineRifle, 500, false, false);

                TriggerEvent("chat:addMessage", new
                {
                    color = new[] {255, 0, 0},
                    args = new[] {"[LoadoutManager] Successfully given police loadout!"}

                });
                

            }), false);
            
            // Gives a police loadout!

            API.RegisterCommand("swatlo", new Action<int, List<object>, string>((source, args, raw) =>
            {
                Game.PlayerPed.Weapons.RemoveAll();
                Game.PlayerPed.Weapons.Give(WeaponHash.AssaultRifleMk2, 500, false, false);
                Game.PlayerPed.Weapons.Give(WeaponHash.HeavyPistol, 200, false, false);
                Game.PlayerPed.Weapons.Give(WeaponHash.PumpShotgunMk2, 120, false, false);
                Game.PlayerPed.Weapons.Give(WeaponHash.StunGun, 0, false, false);
                
                TriggerEvent("chat:addMessage", new
                {
                   color = new[] {255, 0, 0},
                   args = new[] {"[LoadoutManager] Successfully given a swat loadout!"}
                });

            }), false);
            
            // Gives a swat loadout!
        }

    }
}