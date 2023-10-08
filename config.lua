--[[
───────────────────────────────────────────────────────────────

	Extra Changer Menu (config.lua) - Created by Shadow Development
	
	Website: https://shadowdevs.com
    Documentation: https://docs.shadowdevs.com/opensource/extramenu
    Discord: https://shadowdevs.com/discord

───────────────────────────────────────────────────────────────
]]
Config = {}

Config.MenuKey = 244
-- Default = 244 [M]  |  To change the button check out https://docs.fivem.net/game-references/controls/

Config.requirePerms = false
-- When enabled (true), a user must have the ace permissions to open the menu.
-- If using, add this to server.cfg: "add_ace identifier.steam:steamidhere use.ExtraMenu" allow or "add_ace group.groupName use.ExtraMenu allow"

Config.locationOpen = false
-- Default = false | When this is true you will need to input information in Config.locationMarker, as the menu will only work when a player walks over a marker on the map.

Config.commandOpen = false
-- Default = false | When this is true you will be able to open the menu via the command defined on the next line. | Doesn't work with "locationOpen".
Config.command = 'extramenu'
-- Default = 'extramenu' | This defines the command used to open the extra menu when "Config.commandOpen = true".
Config.commandOnly = false
-- Default = false | When enabled the menu can only be opened with the command.

Config.MenuOrientation = 1
-- Left = 0  |  Right = 1 [Default]

Config.MenuWidth = 80
-- Default = 80

Config.MenuTitle = 0
-- Default       = The default title of the menu is 'Extras Menu'
-- Player Name   = This is the name of the player
-- Custom        = This is a custom title set by you at Config.MenuTitleCustom
-- Default = 0 [Default]  |  Player Name = 1  |  Custom = 2

Config.MenuTitleCustom = 'Extras Menu'
-- If chosen at Config.MenuTitle

Config.EnableCredits = 'true'
-- On = true  |  Off = false
--We would love if you could leave them on, but we know sometimes it looks better to turn them off. :)

Config.DamageStopper = true
-- Enabling this means that vehicles will not be abled to change their extras when over the damage limit.
-- Note: Recommended to have this disabled when using "locationOpen", as you should have the locations at repair shops anyway.

Config.DamageLimit = 980
-- The max damage value a vehicle can have. Anything over this will result in the vehicle not being allow to change extras. [Default = 980]

Config.CustomNames = {
    {vehicle = '19Charger', extra = {
        ['1'] = 'Ram Bar', ['2'] = 'Light Bar', ['3'] = 'Visor Lights', ['4'] = 'Dashboard Lights', ['5'] = 'Spot Lights'
    }},
}
--If you want extra names to display as something custom for certain vehicles
--[[
Formt: 
    {vehicle = 'spawncode', extra = {
        ['extra_number'] = 'custom name', ['extra_number'] = 'custom name', ['extra_number'] = 'custom name'
    }},
EX:
    {vehicle = '19Charger', extra = {
        ['1'] = 'Ram Bar', ['2'] = 'Light Bar', ['3'] = 'Visor Lights', ['4'] = 'Dashboard Lights', ['5'] = 'Spot Lights'
    }},
]] 
-- You can add more into the extra section

Config.enableLivery = true
-- Turns on (true)/off (false) the livery changer

Config.CustomLiveryNames = {
    {vehicle = '19Charger', livery = {
        [0] = 'Sheriff', [1] = 'Police', [2] = 'Unmarked'
    }},
}
--If you want livery names to display as something custom for certain vehicles (Liveries start at 0, not 1)
--[[
Formt: 
    {vehicle = 'spawncode', livery = {
        [livery_number] = 'custom name', [livery_number] = 'custom name', [livery_number] = 'custom name'
    }},
EX:
    {vehicle = '19Charger', livery = {
        [0] = 'Sheriff', [1] = 'Police', [2] = 'Unmarked'
    }},
]] 
-- You can add more into the livery section

Config.positions = {
    -- {{Marker X, Marker Y, Marker Z, Marker Heading}, {Red, Green, Blue}, "Text for Marker"} (Do not put the key to press in the text, it auto is added.)
    {{1867.42, 3666.11, 32.80, 0},{36,237,157}, "Test"} -- Outside the Sheriff's Station
}
