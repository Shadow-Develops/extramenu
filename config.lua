--[[
───────────────────────────────────────────────────────────────

	Extra Changer Menu (config.lua) - Created by Agent Squad Prodcutions
	
	Website: https://agentsquad.org
    Documentation: https://docs.agentsquad.org/extramenu
    Discord: https://discord.agentsquad.org

───────────────────────────────────────────────────────────────
]]
Config = {}

Config.MenuKey = 244
--Default = 244 [M]  |  To change the button check out https://docs.fivem.net/game-references/controls/

Config.MenuOrientation = 1
--Left = 0  |  Right = 1 [Default]

Config.MenuWidth = 80
--Default = 80

Config.MenuTitle = 0
--Default       = The default title of the menu is 'Extras Menu'
--Player Name   = This is the name of the player
--Custom        = This is a custom title set by you at Config.MenuTitleCustom
--Default = 0 [Default]  |  Player Name = 1  |  Custom = 2

Config.MenuTitleCustom = 'Extras Menu'
--If chosen at Config.MenuTitle

Config.EnableCredits = 'true'
-- On = true  |  Off = false
--We would love if you could leave them on, but we know sometimes it looks better to turn them off. :)

Config.CustomNames = {
    {vehicle = '19Charger', extra = {
        ['1'] = 'Ram Bar', ['2'] = 'Light Bar', ['3'] = 'Visor Lights', ['4'] = 'Dashboard Lights', ['5'] = 'Spot Lights'
    }},
}
--If you want extra names to display as something custom for certain vehicles
--[[
Formt: 
    {vehicle = 'spancode', extra = {
        ['extra_number'] = 'custom name', ['extra_number'] = 'custom name', ['extra_number'] = 'custom name'
    }},
EX:
    {vehicle = '19Charger', extra = {
        ['1'] = 'Ram Bar', ['2'] = 'Light Bar', ['3'] = 'Visor Lights', ['4'] = 'Dashboard Lights', ['5'] = 'Spot Lights'
    }},
]] 
-- You can add more into the extra section